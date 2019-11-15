% $Id: electionserver_tests.erl,v 1.3 2019/10/31 04:37:03 leavens Exp leavens $
-module(electionserver_tests).
-import(electionserver,[start/0, vote/2, results/1]).
-import(testing,[dotests/2,eqTest/3]).
-export([main/0]).
main() ->
       compile:file(electionserver),
       dotests("electionserver_tests $Revision: 1.3 $", tests()).
tests() ->
    ES = start(), E2 = start(),
    [eqTest(results(ES),"==",[]),
     begin vote(ES, clinton), vote(ES, clinton), vote(ES, christy), 
	   eqTest(results(ES),"==",[{christy,1},{clinton,2}])
     end,
     begin vote(ES, christy), vote(ES, christy), vote(ES, christy),
	   vote(ES, abel), vote(ES, baker), vote(ES,clinton),
	   eqTest(results(ES),"==",[{abel,1},{baker,1},{christy,4},{clinton,3}])
     end,
     eqTest(results(E2),"==",[]),
     begin vote(E2, ucf), vote(E2, usf), vote(E2, fiu), vote(E2, uf),
	   vote(E2, ucf), vote(E2, ucf), vote(E2, fsu),
	   eqTest(results(E2),"==",[{fiu,1},{fsu,1},{ucf,3},{uf,1},{usf,1}])
     end
    ].
