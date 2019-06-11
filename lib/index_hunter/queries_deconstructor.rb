# bad name this class will be the base for fetching infos about the queries in your project
module IndexHunter

  class QueriesDeconstructor
    def initialize(queries=[],orm= :active_record,  klass)
      @queries = queries
      @klass = klass
      @columns_extractor = "::IndexHunter::ColumnsExtractor::#{orm.classify}".constantize.new(klass)
    end

    def get_query_sets
      @query_sets = []
      if @queries.is_a? Hash
        retrieve_query_fields_from_hash
      else
        retrieve_query_fields_from_array
      end
      @query_sets.uniq! {|arr| arr.sort}
      @query_sets
    end

    private

    def retrieve_query_fields_from_hash
      @queries.each do |query_as_string, query_as_lambda|
        begin
          # WORKS FOR WHERE clause fucks up with FIND
          @query_sets << @columns_extractor.extract_columns(query_ast_string)
        rescue => e
          puts e
        end
      end
    end

    def retrieve_query_fields_from_array
      @queries.each do |query_as_lambda|
        begin
          # WORKS FOR WHERE clause fucks up with FIND
          @query_sets << query_as_lambda.call.where_values_hash.keys.map(&:to_sym) if query_as_lambda.call.is_a? ActiveRecord::Relation
        rescue => e
          puts e
        end
      end
    end

  end
end
