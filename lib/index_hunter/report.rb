module IndexHunter
  class Report
    def initialize(file_path, headers, requests, klass, index_names)
      @file_path = file_path
      @headers = headers
      @requests = requests
      @klass = klass
      @index_names = index_names
    end

    def build
      puts "---------------------------------- \n \n"
      puts "Building Report... We are running each one of your queries 100 times, so it might take a while.... \n \n"
      puts "---------------------------------- \n \n"
      ::CSV.open(@file_path, 'wb') do |csv|
        csv << @headers
        @requests.each do |request|
          csv << RequestAnalysis.new(@klass, request, @index_names).run_all
        end
      end
    end
  end
end
