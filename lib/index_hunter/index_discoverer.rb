# finds best possible index based on a set of queries
# BAD REWRITE
module IndexHunter
  class IndexDiscoverer
    attr_accessor :query_sets, :klass, :cardinality, :index_suggestions
    def initialize(query_sets, klass)
      @query_sets = query_sets
      @klass = klass
      @index_suggestions = []
    end

    # finds a common intersection if it exists

    def discover_indexes
      strategy = OptimizationStrategies::FullCoverageStrategy.new(@query_sets, @klass)
      @index_suggestions = IndexOptimizer.new(strategy).optimize
      @index_suggestions = Display.show_indexes(@index_suggestions)
      Readline.pre_input_hook = nil
      @index_suggestions
    end
  end
end
