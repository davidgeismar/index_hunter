class IndexOptimizer
  def initialize(strategy)
    @strategy = strategy
  end

  def optimize
    @strategy.optimize
  end
end
