# a strategy that covers all queries based and orders based on cardinality
# maybe the sorting logic (cardinality) should be extracted too
module IndexHunter
  module OptimizationStrategies
    class FullCoverageStrategy
      def initialize(query_sets, klass)
        @sort_strategy = ::IndexHunter::SortStrategies::CardinalityStrategy.new(klass, query_sets.flatten.uniq)
        @klass = klass
        @query_sets = query_sets
      end

      def optimize
        find_covering_indexes
      end

      private
      # REWRITTE THIS SHIT EVEN THOUGH ITS WORKING
      def find_covering_indexes
        # each element is sorted based on cardinality, query_sets sorted in descending order based on el size
        sorted_query_sets = @query_sets.map {|query_set| @sort_strategy.sort(query_set)}.sort_by{|el| -el.size}
        max_dimension = sorted_query_sets[0].size
        index_possibilities = sorted_query_sets.select{|query_set| query_set.size == max_dimension}

        uncovered_queries = sorted_query_sets - index_possibilities
        uncovered_queries_dup = uncovered_queries.dup
        uncovered_queries.each do |query|
          index_possibilities.push(query) unless is_covered_by_index_options?(query, index_possibilities)
          uncovered_queries_dup.shift
          break if uncovered_queries_dup.empty?
        end
        index_possibilities
      end

      def is_covered_by_index_options?(query, index_possibilities)
        covered = false
        index_possibilities.each do |index|
          return true if index_covers_query?(index, query)
        end
      end

      def index_covers_query?(index, query)
        covers = true
        query.each_with_index do |field, i|
          if field != index[i]
            return false
          end
        end
      end
    end
  end
end
