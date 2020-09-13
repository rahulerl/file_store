-module(upload_handler).
-export([init/2]).

init(Req0, State) ->
   multipart(Req0),
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        <<"Hello Erlang!">>,
        Req0),
    {ok, Req, State}.

multipart(Req0) ->
    case cowboy_req:read_part(Req0) of
        {ok, Headers, Req1} ->
            Req = case cow_multipart:form_data(Headers) of
                {data, _FieldName} ->
                    {ok, _Body, Req2} = cowboy_req:read_part_body(Req1),
                    Req2;
                {file, _FieldName, _Filename, _CType} ->
                io:format("The value is: ~p. ~p ~p", [_FieldName,_Filename, _CType]),
                    stream_file(Req1)
            end,
            multipart(Req);
        {done, Req} ->
            Req
    end.

stream_file(Req0) ->
    case cowboy_req:read_part_body(Req0) of
        {ok, _LastBodyChunk, Req} ->
            Req;
        {more, _BodyChunk, Req} ->
            stream_file(Req)
    end.

