Gem::Specification.new do |s|
  s.name        = 'index_hunter'
  s.version     = '0.0.1'
  # s.executables << 'index_hunter_init'
  s.date        = '2019-06-07'
  s.summary     = "IndexCityHunter ^^"
  s.description = "An automat that finds the ultimate indexes for u"
  s.authors     = ["David GEISMAR"]
  s.email       = 'dageismar@gmail.com'
  s.files       = [ "lib/index_hunter/optimization_strategies/full_coverage_strategy.rb",
                    "lib/index_hunter/ORM/active_record.rb",
                    "lib/index_hunter/sort_strategies/cardinality_strategy.rb",
                    "lib/index_hunter.rb",
                    "lib/index_hunter/display.rb",
                    "lib/index_hunter/folder_builder.rb",
                    "lib/index_hunter/index_builder.rb",
                    "lib/index_hunter/index_discoverer.rb",
                    "lib/index_hunter/index_hunter.rb",
                    "lib/index_hunter/index_optimizer.rb",
                    "lib/index_hunter/queries_deconstructor.rb",
                    "lib/index_hunter/query_finder.rb",
                    "lib/index_hunter/report.rb",
                    "lib/index_hunter/request_analysis.rb"]
  s.homepage    =
    'https://rubygems.org/gems/index_hunter'
  s.license       = 'MIT'
end
