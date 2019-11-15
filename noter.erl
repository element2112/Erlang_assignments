-module(noter).
-export([start/0, loop/1]).

% Worked on with Daniel Lam. Referenced Dr. Leavens code examples on his website.


start() -> 

  spawn(?MODULE, loop, [[]]).

loop(Lst) -> 
    receive 
        {Pid, log, Entry} ->
          SPid = self(),
          Pid ! {SPid, logged},
          loop(Lst ++ [Entry]);
        {Pid, fetch} ->
          SPid = self(),
          Entries = Lst,
          Pid ! {SPid, log_is, Entries},
          loop(Lst)
    end.
