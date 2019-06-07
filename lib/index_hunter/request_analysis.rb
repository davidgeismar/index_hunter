module IndexHunter
  class RequestAnalysis
    def initialize(klass, request, indexes)
      @klass = klass
      @request = request
      @indexes = indexes
      @analysis_data = []
    end

    def run_all
      @analysis_data = [@indexes.join(', '), raw_sql, explain, benchmark]
    end

    def raw_sql
      begin
        if @request.is_a? Array
          @request.last.call.to_sql
        else
          @request.call.to_sql
        end
      rescue => e
        puts e
        if @request.is_a? Array
          @request.first
        else
          'CANT COMPUTE SQL'
        end
      end
    end

    def explain
      begin
        if @request.is_a? Array
          pure_explain(@request.last.call.explain, raw_sql)
        else
          pure_explain(@request.call.explain, raw_sql)
        end
      rescue => e
        puts e
        if @request.is_a? Array
          @request.first
        else
          'CANT EXPLAIN SQL'
        end
      end
    end

    def benchmark
      load = true
      benchmarkable = true
      begin
        @request.call
      rescue => e
        return "NOT BENCHMARKABLE, please fix : #{e}"
      end
      begin
        @request.call.load
      rescue
        load = false
      end
      if load
        time =   Benchmark.ms do
                    100.times do
                      @request.call.load
                    end
                  end
      else
        time =   Benchmark.ms do
                    100.times do
                      @request.call
                    end
                  end
      end
    end

    def pure_explain(full_explain, raw_sql)
      full_explain.slice!("EXPLAIN for: #{raw_sql}") unless raw_sql == 'CANT COMPUTE SQL'
      full_explain
    end
  end
end
