# this class does too much
module IndexHunter
  class QueryFinder
    attr_accessor :queries_as_string, :queries_as_lambdas, :mocked_queries_as_string, :mocked_queries_as_lambdas, :queries, :mocked_queries

    ACTIVE_RECORD_QUERIES = ['find', 'find_by', 'find_by!', 'find_by_sql', 'pluck', 'take', 'where', 'order', 'limit', 'offset', 'group', 'select', 'unscope', 'only', 'reorder', 'reverse_order', 'rewhere', 'joins', 'left_outer_joins', 'includes', 'select_all', 'distinct', 'exists?', 'any?', 'many?', 'count', 'minimum', 'maximum', 'sum']
    ACTIVE_RECORD_SQLABLE = ['where', 'order', 'rewhere','order', 'limit', 'offset', 'group', 'select', 'unscope', 'only', 'reorder', 'reverse_order', 'rewhere', 'joins', 'includes', 'select_all', 'distinct']
    ACTIVE_RECORD_NOT_SQLABLE = [ 'find_by', 'find_by!', 'find_by_sql', 'pluck', 'take', 'exists?', 'any?', 'many?', 'count', 'minimum', 'maximum', 'sum']
    # we will replace those with where to retrieve fields
    ACTIVE_RECORD_HACKABLE = ['find_by', 'find_by!']

    ACTIVE_RECORD_AFTER_GROUP = ['having']
    ACTIVE_RECORD_AFTER_WHERE = ['not', 'or']
    # TODO make it better
    ACTIVE_RECORD_REGEX = "(#{ACTIVE_RECORD_QUERIES.join('|')})\\(.*?\\)"
    def initialize(klass, root=nil)
      @klass = klass
      @regex = /#{@klass}(.#{ACTIVE_RECORD_REGEX})+/mx
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
