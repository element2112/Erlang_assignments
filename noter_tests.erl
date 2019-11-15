% $Id: noter_tests.erl,v 1.1 2019/11/09 02:57:05 leavens Exp leavens $
-module(noter_tests).
-import(noter,[start/0]).
-import(testing,[dotests/2,eqTest/3]).
-export([main/0,logThenFetch/2,log/2,fetch/1]).
main() -> 
    compile:file(noter),
    dotests("noter_tests $Revision: 1.1 $", tests()).
tests() ->
    L1 = noter:start(),
    L2 = noter:start(),
    [eqTest(fetch(L1),"==",[]),
     eqTest(fetch(L2),"==",[]),
     eqTest(logThenFetch(L1,[starting,middle,ending]),"==",[starting,middle,ending]),
     eqTest(logThenFetch(L2,[start,between,last]),"==",[start,between,last]),
     eqTest(logThenFetch(L1,[final]),"==",[starting,middle,ending,final]),
     eqTest(logThenFetch(L1,[really]),"==",[starting,middle,ending,final,really]),
     eqTest(logThenFetch(L2,[ultimate]),"==",[start,between,last,ultimate]),
     eqTest(fetch(L1),"==",[starting,middle,ending,final,really])
    ].
% helpers for testing (client functions), NOT for you to implement
logThenFetch(Noter, []) ->
    fetch(Noter);
logThenFetch(Noter, [Entry|Entries]) ->
    log(Noter, Entry),
    logThenFetch(Noter, Entries).
log(Noter, Entry) ->
    Noter ! {self(), log, Entry},
    receive {Noter, logged} -> logged;
	    _ -> 'wrong message format received in response to log message'
    end.
fetch(Noter) ->
    Noter ! {self(), fetch},
    receive {Noter, log_is, Entries} -> Entries;
	    _ -> 'wrong message format received in response to log_is message'
    end.
