% $Id: barrier_tests.erl,v 1.4 2019/10/31 04:37:03 leavens Exp leavens $
-module(barrier_tests).
-export([main/0]).
-import(barrier,[start/1]).
-import(testing,[dotests/2,eqTest/3]).
-import(lists,[map/2,foreach/2]).
main() -> 
    compile:file(barrier),
    dotests("barrier_tests $Revision: 1.4 $", tests()).
tests() ->
    Br = barrier:start(4),
    Workers = map(workerCreator(Br),[1,2,3,4]),  %% start the workers
    [eqTest(num_running(Br), "==", 4),
     begin 
	 send_finish(hd(Workers)),
	 eqTest(num_running(Br), "==", 3)
     end,
     eqTest(num_released(), "==", 0),
     begin 
	 send_finish(hd(tl(Workers))),
	 eqTest(num_running(Br), "==", 2)
     end,
     eqTest(num_released(), "==", 0),
     begin 
	 foreach(fun(W) -> send_finish(W) end, tl(tl(Workers))),
	 eqTest(num_running(Br), "==", 0)
     end,
     eqTest(num_released(), "==", 4)
    ].
%% helpers for testing (client functions), NOT for you to implement
workerCreator(Barrier) -> fun(_Num) -> 
			     TPid = self(),
			     spawn(fun() -> worker_fun(Barrier, TPid) end)
			  end.
%% worker_fun acts under control of the testing code's finish message, telling
%% it when the barrier acknowledges its done message and when it's released.
worker_fun(Barrier, TestingPid) ->
    receive {TestingPid, finish} -> ok end,
    Barrier ! {self(), done},
    receive {Barrier, ok} -> TestingPid ! {self(), ok} end,
    receive {Barrier, continue} -> ok end,
    TestingPid ! {self(), released}.
%% send finish to the worker process and get an ack (for testing purposes).
send_finish(Pid) ->
    Pid ! {self(), finish},
    receive {Pid, ok} -> ok end.
%% How many processes are not finished (still running)?
num_running(Barrier) ->
    Barrier ! {self(), how_many_running},
    receive {Barrier, number_running_is, Num} -> Num end.
%% How many released messages have been received by the testing process?
num_released() -> num_released(0).
num_released(N) -> receive {_Pid, released} -> num_released(N+1)
		   after 0 -> N
		   end.
