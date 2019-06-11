module ORM
  module ActiveRecord
    QUERY_METHODS = ['find', 'find_by', 'find_by!', 'find_by_sql', 'pluck', 'take', 'where', 'order', 'limit', 'offset', 'group', 'select', 'unscope', 'only', 'reorder', 'reverse_order', 'rewhere', 'joins', 'left_outer_joins', 'includes', 'select_all', 'distinct', 'exists?', 'any?', 'many?', 'count', 'minimum', 'maximum', 'sum']
    SQLABLE = ['where', 'order', 'rewhere','order', 'limit', 'offset', 'group', 'select', 'unscope', 'only', 'reorder', 'reverse_order', 'rewhere', 'joins', 'includes', 'select_all', 'distinct']
    NOT_SQLABLE = [ 'find_by', 'find_by!', 'find_by_sql', 'pluck', 'take', 'exists?', 'any?', 'many?', 'count', 'minimum', 'maximum', 'sum']
    # we will replace those with where to retrieve fields
    HACKABLE = ['find_by', 'find_by!']

    AFTER_GROUP = ['having']
    AFTER_WHERE = ['not', 'or']
    # TODO make it better
    SEARCH_REGEX = "(#{ACTIVE_RECORD_QUERIES.join('|')})\\(.*?\\)"
  end
end
