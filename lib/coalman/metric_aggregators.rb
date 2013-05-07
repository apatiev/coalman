module Coalman
  module Aggregator
    def self.for(method)
      case method
      when "avg"
        Avg
      when "sum"
        Sum
      when "min"
        Min
      when "max"
        Max
      else
        Avg
      end
    end 

    class Avg
      def self.aggregate(points)
        points.empty? ? 0.0 : points.inject { |sum, item| sum + item }.to_f / points.size
      end
    end

    class Sum
      def self.aggregate(points)
        points.inject { |sum, item| sum + item }.to_f
      end
    end

    class Min
      def self.aggregate(points)
        points.min.to_f
      end
    end

    class Max
      def self.aggregate(points)
        points.max.to_f
      end
    end
  end
end
