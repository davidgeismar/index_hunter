module IndexHunter
  module ColumnsExtractor
    class ActiveRecord
      def initialize(klass)
        @klass = klass
      end


      def extract_columns(query: String)
        q = query_as_lambda(query)
        q.call.where_values_hash.keys.map(&:to_sym) if q.call.is_a? ActiveRecord::Relation
      end

      private

      def query_as_lambda(query)
        if @query.include?("#{@klass}.find_by")
          extractable = @query.sub("#{@klass}.find_by", "#{@klass}.where")
          -> { eval(extractable) }
        else
          -> { eval(@query)}
        end
      end
    end
  end
end


    # def retrieve_query_fields_from_hash
    #   @queries.each do |query_as_string, query_as_lambda|
    #     begin
    #       # if QueryFinder::ACTIVE_RECORD_NOT_SQLABLE.any? {|ar_method| query_as_string.include?(ar_method)}
    #       #   query_as_lambda
    #       # end
    #       if query_as_string.include?("#{@klass}.find_by")
    #         query_as_string = query_as_string.sub("#{@klass}.find_by", "#{@klass}.where")
    #         query_as_lambda = -> { eval(query_as_string) }
    #       end
    #       # WORKS FOR WHERE clause fucks up with FIND
    #       @query_sets << query_as_lambda.call.where_values_hash.keys.map(&:to_sym) if query_as_lambda.call.is_a? ActiveRecord::Relation
    #     rescue => e
    #       puts e
    #     end
    #   end
    # end
