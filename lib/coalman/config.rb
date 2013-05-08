module Coalman
  module Config
    def self.env!(key)
      ENV[key] || raise("Missing configuration: #{key}")
    end

    def self.api_key; ENV['COALMAN_API_KEY']; end
    def self.graphite_url; env!('COALMAN_GRAPHITE_URL'); end
  end
end