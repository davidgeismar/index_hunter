module IndexHunter
  class IndexHunter
    def initialize(table_name:, discover_queries: true, search_path: Rails.root.join("app"), discover_indexes: true, benchmark: true, queries: [], indexes: [])
      @table_name = table_name
      @klass = table_name.to_s.classify.constantize
      @discover_queries = discover_queries
      @search_path = search_path
      @discover_indexes = discover_indexes
      @benchmark = benchmark
      @queries = queries
      @indexes = indexes
    end

    def chase
      discover_queries
      query_sets = QueriesDeconstructor.new(@queries, @klass).get_query_sets
      @indexes = discover_indexes(query_sets)
      begin
        create_indexes
        perform_analysis
      ensure
         if !Display.should_keep_index?
           IndexBuilder.new(@table_name).remove_indexes(@index_names)
         end
      end
    end

    private

    def discover_queries
      if @discover_queries
        query_finder = QueryFinder.new(@klass, @search_path)
        query_finder.discover_queries
        query_finder.replace_variables_in_query_string
        @queries = query_finder.mocked_queries
      else
        @queries
      end
    end

    def discover_indexes(query_sets)
      if @discover_indexes
        puts "-------------------------"
        puts "Crunching best indexes........."
        puts "-------------------------"
        index_optimiser = IndexOptimiser.new(query_sets, MerchantTransaction)
        index_optimiser.discover_indexes
      else
        @indexes
      end
    end

    def create_indexes
      puts "-------------------------"
      puts "The answer is 42...Please hold tight while we build your indexes"
      puts "-------------------------"
      @index_names = []
      @indexes.each do |index|
        @index_names << IndexBuilder.new(@table_name, index).create_composite
      end
    end

    def perform_analysis
      folder_builder = FolderBuilder.new(@index_names)
      folder_builder.create
      csv_file_path = Rails.root.join('lib', 'tasks', "index_reports", folder_builder.folder_name, "#{Time.now.to_i}.csv")
      headers = ['INDEXES', 'RAW SQL', 'EXPLAIN', 'BENCHMARK (ms)']
      Report.new(csv_file_path, headers, @queries, @klass, @index_names).build
    end
  end
end
