require 'yaml'

module Coalman
  module Config
    extend self

    def get(key)
      @@conf ||= YAML.load_file(File.expand_path('../../../config/coalman.yml', __FILE__))
      @@conf ? @@conf[key.downcase] : ENV[key.upcase]
    end

    def get!(key)
      get(key) || raise("Missing required configuration parameter: #{key}")
    end

    def api_key; get('api_key'); end
    def graphite_url; get!('graphite_url'); end
  end
end