# runs index migration
module IndexHunter
  class IndexBuilder
    def initialize(table_name, columns=[])
      @table_name = table_name
      @columns = columns
    end

    def create_composite
      ActiveRecord::Migration.add_index(@table_name, @columns, name: build_index_name)
      @index_name
    end

    def remove_indexes(index_names)
      index_names.each do |index_name|
        ActiveRecord::Migration.remove_index @table_name, name: index_name
      end
    end

    def build_index_name
      @index_name = 'by'
      @columns.each do |column|
        @index_name += "_#{column}"
      end
      @index_name
    end
  end
end
