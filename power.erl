-module(power).
-export([start/0]).

% Worked on with Daniel Lam. Reference Dr. Leaven's Code examples from his website

start() ->
    spawn(fun server/0).

server() ->
    receive
        {Pid, power, N, M} ->
            Res = math:pow(N,M),
            Pid ! {answer, Res},
            server()
    end. 