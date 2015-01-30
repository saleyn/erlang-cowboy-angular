%% Feel free to use, reuse and abuse the code in this file.

%% @doc POST echo handler.
-module(bisphoneTest_handler).
-export([init/2]).
-include_lib("stdlib/include/qlc.hrl").
-include("../include/tbuser.hrl").

init(Req, Opts) ->
  Method = cowboy_req:method(Req),
  HasBody = cowboy_req:has_body(Req),
  URLBinding = cowboy_req:binding(v1, Req),
  Req2 = dispatch(Method, HasBody, URLBinding, Req),
  {ok, Req2, Opts}.


%% @doc crerate New User
dispatch(<<"POST">>, true, undefined, Req) ->
  {ok, Body, Req2} = cowboy_req:body(Req),
  Json = jiffy:decode(Body, [return_maps]),
  Firstname = maps:get(<<"firstname">>, Json),
  Lastname = maps:get(<<"lastname">>, Json),
  MobileNo = maps:get(<<"mobileNo">>, Json),
  Age = maps:get(<<"age">>, Json),
  createUser(Firstname, Lastname, MobileNo, Age, Req2);

%% find All Users
dispatch(<<"GET">>, false, undefined, Req) ->
  Query = fun() ->
    qlc:e(
      qlc:q([X || X <- mnesia:table(tbuser)])
    )
  end,
  {atomic, Record} = mnesia:transaction(Query),
  Json = bisphoneTest_Utils:convert(Record),
  cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], jiffy:encode({Json}), Req);

%% @doc find a User
dispatch(<<"GET">>, false, Binding, Req) ->

  Query = fun() ->
    mnesia:read(tbuser, Binding)
  end,
  {atomic, Record} = mnesia:transaction(Query),
  Json = bisphoneTest_Utils:convert(Record),
  cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], jiffy:encode({Json}), Req);


%% @doc Update a User Info
dispatch(<<"PUT">>, true, Id, Req) ->

  {ok, Body, Req2} = cowboy_req:body(Req),
  Json = jiffy:decode(Body, [return_maps]),
  Firstname = maps:get(<<"firstname">>, Json),
  Lastname = maps:get(<<"lastname">>, Json),
  MobileNo = maps:get(<<"mobileNo">>, Json),
  Age = maps:get(<<"age">>, Json),
  Write = fun() ->
    User = #tbuser{
      id = Id,
      firstname = Firstname,
      lastname = Lastname,
      mobileNo = MobileNo,
      age = Age
    },
    mnesia:write(User)
  end,
  mnesia:transaction(Write),

  cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], jiffy:encode({[{result, ok}]}), Req2);


%% @doc delete a user
dispatch(<<"DELETE">>, false, Id, Req) ->
  Delete = fun() ->
    mnesia:delete({tbuser, Id})
  end,
  mnesia:transaction(Delete),

  cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], jiffy:encode({[{result, ok}]}), Req);


dispatch(<<"POST">>, false, undefined, Req) ->
  cowboy_req:reply(400, [], <<"Missing body.">>, Req);

dispatch(_, _, undefined, Req) ->
  %% Method not allowed.
  cowboy_req:reply(405, Req).

createUser(Firstname, Lastname, MobileNo, Age, Req) ->
  {Mega, Sec, Micro} = erlang:now(),
  Id = list_to_binary(integer_to_list((Mega*1000000 + Sec)*1000 + Micro)),
  Write = fun() ->
    User = #tbuser{
      id = Id,
      firstname = Firstname,
      lastname = Lastname,
      mobileNo = MobileNo,
      age = Age
    },
    mnesia:write(User)
  end,
  mnesia:transaction(Write),

  cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json; charset=utf-8">>}
  ], jiffy:encode({[{result, ok}]}), Req).
