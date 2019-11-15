% $Id: count_matching_tests.erl,v 1.4 2019/10/31 04:37:03 leavens Exp leavens $
-module(count_matching_tests).
-import(count_matching,[count_matching/2]).
-import(testing,[dotests/2,eqTest/3]).
-export([main/0]).
main() -> 
    compile:file(count_matching),
    dotests("count_matching_tests $Revision: 1.4 $", tests()).
tests() ->
    [eqTest(count_matching(fun (X) -> X == 3 end, [3,2,1]), "==", 1),
     eqTest(count_matching(fun (X) -> X == 3 end, [2,1]), "==", 0),
     eqTest(count_matching(fun (X) -> X == 3 end, []), "==", 0),
     eqTest(count_matching(fun (X) -> X > 4 end, [5,5,1,2,7,9,8,4,20]), "==", 6),
     eqTest(count_matching(fun ({X,Y}) -> X == Y end, 
                           [{3,3},{7,5},{4,3},{4,4}]), "==", 2),
     eqTest(count_matching(fun ({X,Y}) -> 3*X+1 == Y end, 
                           [{3,3},{3,10},{4,13},{4,4},{27,82}]), "==", 3),
     eqTest(count_matching(fun ({X,Y}) -> X*2 == Y end, 
                           [{3,6},{7,15},{7,14},{7,13},{92,184},{1,2}]), "==", 4)
    ].
