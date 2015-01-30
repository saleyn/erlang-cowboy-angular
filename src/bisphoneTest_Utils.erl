%%%-------------------------------------------------------------------
%%% @author mohammad
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Jan 2015 11:55 PM
%%%-------------------------------------------------------------------
-module(bisphoneTest_Utils).
-author("mohammad").

%% API
-export([convert/1]).

convert(Liste) -> convert(Liste, [], length(Liste)).

convert(_, Acc, 0) ->
  Acc;

convert(Liste, FormatedList, Length) ->
  convert(Liste, [format(lists:nth(Length, Liste))| FormatedList], Length -1).


format({_, Id, FName, LName, MobileNo, Age}) ->
  {Id, [Id, FName, LName, MobileNo, Age]}.
%%   jiffy:encode({[{firstname, FName}, {lastname, LName}, {mobileNo, MobileNo}, {age, Age}]}).

