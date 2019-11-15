-module(var).
-export([start/1, server/1]).

% Worked on with Daniel Lam. Referenced Dr. Leavens Code examples from his website

start(Val) ->
    spawn(?MODULE, server, [Val]).

server(Val) ->
    receive
        {assign, NewVal} -> server(NewVal);
        {Pid, fetch} -> 
            Value = Val,
            Pid ! {value, Value},
            server(Val)
    end.
            
