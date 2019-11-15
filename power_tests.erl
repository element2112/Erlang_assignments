% $Id: power_tests.erl,v 1.4 2019/10/31 04:37:03 leavens Exp leavens $
-module(power_tests).
-export([main/0]).
-import(power,[start/0]).
-import(testing,[dotests/2,eqTest/3]).
main() -> 
    compile:file(power),
    dotests("power_tests $Revision: 1.4 $", tests()).
tests() ->
    PS = start(),
    [eqTest(compute_power(PS, 0,0),"==",1.0),
     eqTest(compute_power(PS, 22,0),"==",1.0),
     eqTest(compute_power(PS, 1,1),"==",1.0),
     eqTest(compute_power(PS, 6,1),"==",6.0),
     eqTest(compute_power(PS, 2,3),"==",8.0),
     eqTest(compute_power(PS, 3,8),"==",6561.0),
     eqTest(compute_power(PS, 3,4),"==",81.0),
     eqTest(compute_power(PS, 3,3),"==",27.0),
     eqTest(compute_power(PS, 3,2),"==",9.0),
     eqTest(compute_power(PS, 5,10),"==",9765625.0),
     eqTest(compute_power(PS, 5,2),"==",25.0)].
%% helper for testing, NOT for you to implement.
compute_power(PS, N, M) ->
    PS ! {self(), power, N, M},
    receive {answer, Res} -> Res end.
   
