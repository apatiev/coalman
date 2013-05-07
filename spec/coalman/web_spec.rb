require 'rack/test'

require 'coalman/web'


module Coalman
  describe Coalman::Web do
    include Rack::Test::Methods

    def app
      Coalman::Web
    end

    context 'GET /health' do
      it 'should return status' do
        get '/health'
        last_response.should be_ok
        last_response.body.should eq({'status' => 'ok'}.to_json)
      end
    end

  end
end
