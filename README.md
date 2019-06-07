# index_hunter
Index Hunter, the tool you ve all been waiting for. Finally released by David Geismar and Colossus Productions.
Index Hunter will automatically parse your ruby code, find your active record queries, analyse them, find the best indexes for your tables and benchmark all your queries.
All of that magic in a single sweet gem. 
You already love index hunter

#GETTING STARTED 
`IndexHunter::IndexHunter.new(options).chase`

#WHAT CAN YOU PASS AS OPTIONS ?
This is a list of options you can pass to the IndexHunter class :
- `table_name` : the name of the table on which you wish to work
- `discover_queries` (default true) wether you want IndexHunter to automatically find queries for the table you passed from your project (index_hunter only supports search on active_record methods)
- `search_path`: Rails.root.join("app") : defaults to your rails app root path, you can pass a different path if you wish.
- `queries` default [], give IndexHunter your own set of queries as lambdas 
- `discover_indexes` (default to true) if you want to let IndexHunter automatically compute the best indexes for you. If not you can provide indexHunter with your own set of indexes
- `indexes` default: [] give IndexHunter your own set of indexes to run a benchmark on
- `benchmark` default: true, wether you wish to run benchmark test on every single one of your queries


