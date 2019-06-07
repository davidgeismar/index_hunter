# finds best possible index based on a set of queries
# BAD REWRITE
module IndexHunter
  class IndexOptimiser
    attr_accessor :query_sets, :klass, :cardinality, :index_suggestions
    def initialize(query_sets, klass)
      @query_sets = query_sets
      @klass = klass
      @cardinality = find_fields_cardinality(query_sets.flatten.uniq)
      @index_suggestions = []
    end

    # finds a common intersection if it exists
    def discover_indexes
      @index_suggestions = find_covering_indexes
      @index_suggestions = Display.show_indexes(@index_suggestions)
      Readline.pre_input_hook = nil
      @index_suggestions
    end


    def find_fields_cardinality(fields)
      field_cardinality = {}
      fields.each do |field|
        field_cardinality[field] = @klass.count("DISTINCT #{field}")
      end
      field_cardinality
    end
    # highest cardinality first
    def sort_based_on_cardinality(fields)
      sorted_fields = fields.sort_by { |field| -@cardinality[field] }
    end


    # REWRITTE THIS SHIT EVEN THOUGH ITS WORKING

    def find_covering_indexes
      # each element is sorted based on cardinality, query_sets sorted in descending order based on el size
      sorted_query_sets = @query_sets.map {|query_set| sort_based_on_cardinality(query_set)}.sort_by{|el| -el.size}
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
    # def find_most_efficient_intersection(matrix)
    #   binding.pry
    #   grouped_values = Hash.new{|h, k| h[k] = []}
    #   matrix.each.with_index(1) do |row, i|
    #     row.each do |value|
    #       grouped_values[value] << i
    #     end
    #   end
    #   binding.pry
    #   grouped_sets = Hash.new{|h, k| h[k] = []}
    #   grouped_values.each do |value, sets|
    #     grouped_sets[sets.sort] << value if sets.size > 1
    #   end
    #   binding.pry
    #   grouped_sets
    # end
    # def find_most_efficient_intersection(arr)
    #   common_intersection = arr.reduce{|sub_arr, acc| sub_arr & acc}
    #   return common_intersection if common_intersection.present?
    #   smallest_dim = arr.last.size
    #   least_dim_sub_arrs = arr.select { |sub_arr| sub_arr.size == smallest_dim }
    #   arr_without_least_dim_sub_arrs = arr - least_dim_sub_arrs
    #   least_dim_sub_arrs_combinations = least_dim_sub_arrs.combination(least_dim_sub_arrs.size - 1)
    #   least_dim_sub_arrs_combinations.each do |least_dim_sub_arr_combination|
    #     arr_minus_one = arr_without_least_dim_sub_arrs
    #     arr_minus_one += least_dim_sub_arr_combination
    #     common_intersection = arr_minus_one.reduce{|arr, acc| arr & acc}
    #     return common_intersection if common_intersection.present?
    #   end
    #   find_most_efficient_intersection(arr_without_least_dim_sub_arrs)
    # end
  end
end
