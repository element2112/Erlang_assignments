-module(barrier).
-export([start/1, loop/2]).

% Worked on with Daniel Lam

start(Processes) ->
    spawn(?MODULE, loop, [Processes, []]).

loop(Processes, Lst) ->
    receive
        {Pid, done} ->
            Pid ! {self(), ok},
            if
                Processes =:= 1 ->
                    [L ! {self(), continue} || L <- (Lst ++ [Pid])],
                    loop(0, []);
                true -> loop((Processes - 1), (Lst ++ [Pid]))
            end;
        {Pid, how_many_running} ->
            Running = Processes,
            Pid ! {self(), number_running_is, Running},
            loop(Processes, Lst)
    end.





