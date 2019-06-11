module IndexHunter
  module SortStrategies
    class CardinalityStrategy
      def initialize(klass, columns)
        @klass = klass
        @columns = columns
        @cardinality = find_fields_cardinality
      end
      # highest cardinality first
      def sort(fields)
        sorted_fields = fields.sort_by { |field| -@cardinality[field] }
      end

      private

      def find_fields_cardinality
        field_cardinality = {}
        @columns.each do |field|
          field_cardinality[field] = @klass.count("DISTINCT #{field}")
        end
        field_cardinality
      end
    end
  end
end
