require 'uri'
require 'coalman'

module Coalman
  module Graphite
    extend self

    def fetch(url, target, range)
      begin
        json = RestClient.get(url_encode(url, target, range))
        data = JSON.parse(json)

        raise MetricNotFound if data.empty?

        data.map { |d| 
          Metric.new(
            d['target'], 
            d['datapoints'].map { |v, _| v }.compact) 
        }     
      rescue => e
        raise MetricServiceRequestFailed
      end
    end

    def url_encode(url, target, range)
      URI.encode(URI.decode("#{url}/render/?target=#{target}&format=json&from=-#{range}s"))
    end
  end
end