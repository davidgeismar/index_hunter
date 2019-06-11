# this class does too much
module IndexHunter
  class QueryFinder
    attr_accessor :queries_as_string, :queries_as_lambdas, :mocked_queries_as_string, :mocked_queries_as_lambdas, :queries, :mocked_queries

    def initialize(klass,root=nil,orm= :active_record)
      @klass = klass
      @regex = /#{@klass}(.#{"IndexHunter::ORM::#{orm.to_s.classify.constantize}::SEARCH_REGEX".constantize})+/mx if orm
      # ORIGINAL QUERIES
      @queries_as_string = []
      @queries_as_lambdas = []
      # QUERIES UPDATED BY USER
      @mocked_queries_as_string = []
      @mocked_queries_as_lambdas = []

      @search_scope = root ? Dir["#{root}/**/*.rb"] : Dir["#{Rails.root}/**/*.rb"]
    end

    def discover_queries
      @search_scope.each do |filepath|
        discover_queries_in_file(filepath)
      end
      evaluate_queries_as_lambdas
    end

    # TODO this needs to be extracted to another class
    def replace_variables_in_query_string
      # if @queries_as_string.empty?
      #   Display.write_your_own_query
      # else
        # binding.pry
        # MOCKED DATA IF NECESSARY
        # @queries_as_string = ["MerchantTransaction.find(10553628)",
        #   "MerchantTransaction.find_by(reference: '1055-3628', kind: 'PLACE_BATCH')",
        #   "MerchantTransaction.find_by(reference: '1055-3628', kind: 'PLACE_BATCH')",
        #   "MerchantTransaction.where(parent_ref: '1055-3627', kind: 'BATCH_BET')",
        # ]
        @queries_as_string.each_with_index do | query, index |
          mocked_query = Display.query(query)
          @mocked_queries_as_string << mocked_query ? mocked_query : query
        end
        Readline.pre_input_hook = nil
        evaluate_queries_as_lambdas
      # end
    end
    #
    def discover_queries_in_file(filepath)
      text = File.read(filepath)
      extract_query(text) if text =~ @regex
    end


    def evaluate_queries_as_lambdas
      @queries_as_lambdas = @queries_as_string.map { |query| -> { eval(query) } } if @queries_as_string.present?
      @queries = @queries_as_string.each_with_object({}) {|query_as_string, h| h[query_as_string] = -> { eval(query_as_string) } }
      @mocked_queries_as_lambdas = @mocked_queries_as_string.map { |query| -> { eval(query) } } if @mocked_queries_as_string.present?
      @mocked_queries = @mocked_queries_as_string.each_with_object({}) {|query_as_string, h| h[query_as_string] = -> { eval(query_as_string) } }
    end

    private

    def extract_query(text)
      unless @queries_as_string.include? text[@regex]
        text.to_enum(:scan, @regex).map{Regexp.last_match}.each do |match_data|
          @queries_as_string << match_data[0]
        end
      end
    end

  end
end
