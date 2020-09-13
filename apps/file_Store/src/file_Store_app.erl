%%%-------------------------------------------------------------------
%% @doc file_Store public API
%% @end
%%%-------------------------------------------------------------------

-module(file_Store_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
                {'_', [
                        {"/upload", upload_handler, []}
                ]}
        ]),
        {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
                env => #{dispatch => Dispatch}
        }),

    file_Store_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
