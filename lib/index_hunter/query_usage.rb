module IndexHunter
  class QueryUsage
    def initialize(table_name, client)
      @table_name = table_name
      @client = "#{client.classify}Client".constantize.new
    end


    def analyze_logs(server)
      server.call(endpoint, @query)
    end

  end
end
