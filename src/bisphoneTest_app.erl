-module(bisphoneTest_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, findAll/0, time/1]).
-include("../include/tbuser.hrl").
-include_lib("stdlib/include/qlc.hrl").
-define(C_ACCEPTORS,  100).

%% ===================================================================
%% Application callbacks
%% ===================================================================

%% ===================================================================
%% Safe to delete ...Just for Test
findAll() ->
  Query = fun() ->
    qlc:e(
      qlc:q([X || X <- mnesia:table(tbuser)])
    )
  end,
  mnesia:transaction(Query).

get_timestamp() ->
  io:format("~p~n : ",[erlang:now()]),
  {Mega, Sec, Micro} = erlang:now(),
  list_to_binary(integer_to_list((Mega*1000000 + Sec)*1000 + Micro)).

time(0) ->
  io:format("~p~n", ["Finito..."]);

time(L) ->
  io:format("~p~n", [get_timestamp()]),
  time(L-1).

%% ===================================================================


start(_StartType, _StartArgs) ->
  mnesia:create_schema([node()]),
  mnesia:start(),

  mnesia:create_table(tbuser, [
    {attributes, record_info(fields, tbuser)},
    {disc_copies, [node()]} %% disc_copies means persistent
  ]),

  Routes    = routes(),
  Dispatch  = cowboy_router:compile(Routes),
  Port      = port(),
  TransOpts = [{port, Port}],
  ProtoOpts = [{env, [{dispatch, Dispatch}]}],
  {ok, _}   = cowboy:start_http(http, ?C_ACCEPTORS, TransOpts, ProtoOpts),
  bisphoneTest_sup:start_link().

stop(_State) ->
  ok.

%% ===================================================================
%% Internal functions
%% ===================================================================
routes() ->
  [
    {'_', [
      {"/users/[:v1]", bisphoneTest_handler, []},
      {"/[...]", cowboy_static, {dir, "priv"}}
    ]}
  ].

port() ->
  case os:getenv("PORT") of
    false ->
      {ok, Port} = application:get_env(http_port),
      Port;
    Other ->
      list_to_integer(Other)
  end.
