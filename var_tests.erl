% $Id: var_tests.erl,v 1.4 2019/10/31 04:37:03 leavens Exp leavens $
-module(var_tests).
-import(var, [start/1]).
-import(testing,[eqTest/3,dotests/2]).
-export([main/0,vfetch/1,bassign/2]).

main() ->
    compile:file(var),
    dotests("var_tests $Revision: 1.4 $", tests()).

-spec tests() -> [testing:testCase(integer())].
tests() ->
    B1 = var:start(1),
    B2 = var:start(2),
    [eqTest(vfetch(B1),"==",1),
     eqTest(vfetch(B2),"==",2),
     eqTest(bassign(B1,99),"==",99),
     eqTest(vfetch(B1),"==",99),
     eqTest(vfetch(B2),"==",2),
     eqTest(bassign(B2,3),"==",3),
     eqTest(bassign(B2,5),"==",5),
     eqTest(bassign(B2,5),"==",5),
     eqTest(vfetch(B2),"==",5),
     eqTest(vfetch(B1),"==",99),
     eqTest(vfetch(B2),"==",5)
     ].

% The following functions are used for testing purposes.
% You don't have to implement them again.
vfetch(Pid) ->
    Pid!{self(), fetch},
    receive
	{value, Value} ->
	    Value
    after 3000 ->
	    io:format("timeout waiting for {value, Value} message~n"),
	    exit(wrong_message)
    end.

bassign(Pid, Value) ->
    Pid!{assign, Value},
    Value.
