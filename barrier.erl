-module(barrier).
-export([start/1, loop/2]).


start(Processes) ->
    spawn(?MODULE, loop, [Processes, []]).

loop(Processes, Lst) ->
    receive
        {Pid, done} ->
            Spid = self(),
            Pid ! {Spid, ok}
            if
                Processes =:= 0 ->
                    {Spid, continue}
                true ->
                    loop((Processes - 1), (Pid ++ Lst)),
        {Pid, how_many_running} ->
            Running = Processes,
            Spid = self(),
            Pid ! {Spid, number_running_is, Running}
            loop(Processes, Lst)
    end.





