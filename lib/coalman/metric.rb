require 'coalman'

module Coalman
  class Metric
    attr_reader :name
    attr_reader :data

    def initialize(name, data)
      @name = name
      @data = data
    end

    def value(agg = Aggregator::Avg)
      agg.aggregate(@data)
    end

    def to_json(*a)
      {'name' => @name, 'data' => @data}.to_json(*a)
    end
  end
end