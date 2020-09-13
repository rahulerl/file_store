-module(file_store_mysql).
-export([connect/1]).

connect(Options) ->
     io:format("~p",[Options]),
    mysql:start_link(Options).
