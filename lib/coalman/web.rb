require 'sinatra'
require 'sinatra/config_file'
require 'rest-client'
require 'json'

require 'coalman'

module Coalman
  class Web < Sinatra::Base
    register Sinatra::ConfigFile

    config_file 'config/coalman.yml'

    configure do
      enable :logging
    end

    before do
      content_type :json
      protected! if settings.api_key
    end

    helpers do
      def protected!
        unless authorized?
          headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
          halt 401, {:result => false, :error => 'Not authorized'}.to_json
        end
      end

      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials[1] == settings.api_key
      end

      def valid?(params)
        params["metric"] && (params["min"] || params["max"]) && params["range"]
      end
    end

    get '/check' do
      unless valid?(params)
        halt 400, {:result => false, :error => 'Missing parameters'}.to_json
      end

      metric      = params['metric']
      range       = (params['range'] && params['range'].to_i)
      min         = (params['min'] && params['min'].to_f)
      max         = (params['max'] && params['max'].to_f)
      empty_ok    = params['empty_ok']
      aggregate   = params['aggregate']
      satisfy_all = params['satisfy'] == 'all'

      begin
        data = Graphite.fetch(settings.graphite_url, metric, range)
      rescue MetricNotFound
        halt 404, {:result => false, :error => 'Metric not found'}.to_json
      rescue MetricServiceRequestFailed
        halt 503, {:result => false, :error => 'Connecting to backend metrics service failed'}.to_json
      end

      result = !!satisfy_all      
      result_body = Validator.check(data, min, max, Aggregator.for(aggregate), empty_ok)

      result_body.each do |m|
        result = satisfy_all ?
          result && m[:result] :
          result || m[:result]
      end

      status result ? 200 : 500
      {'result' => result, 'metrics' => result_body}.to_json
    end

    get '/health' do
      {'status' => 'Ok'}.to_json
    end

    get "/*" do
      halt 404, {:result => false, :error => 'Not found'}.to_json
    end
  end
end