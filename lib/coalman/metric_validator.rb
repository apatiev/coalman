require 'coalman'

module Coalman
  module Validator
    def self.check(metrics, min, max, agg = Aggregator::Avg, empty_ok = true)
      metrics.map do |m| 
        value = m.value(agg)

        { 
          :name   => m.name,
          :value  => value,
          :result => m.data.empty? ? !!empty_ok : !((!!min && (value < min)) || (!!max && (value > max)))
        }  
      end
    end
  end  
end