-module(electionserver).
-export([start/0, server/1, vote/2, results/1]).
-import(lists, [sort/1]).

% Worked with Daniel Lam and Dr. Leaveans code examples

start() ->
    spawn(?MODULE, server, [[]]).

server(Lst) ->
    receive
        {Pid, vote, Candidate} ->
            Pid ! {self(), ok},
            server(count(Lst, Candidate));
        {Pid, results} ->
            Pid ! {self(), results, Lst},
            server(sort(Lst))
    end.

count([], Candidate) -> [{Candidate, 1}];

count([{Name, Vote} | Tail], Candidate) ->
    if 
        Name == Candidate -> [{Name, (Vote + 1)}] ++ Tail;
        true -> [{Name, Vote}] ++ count(Tail, Candidate)
    end.
    
vote(ES, Candidate) ->
    ES ! {self(), vote, Candidate},
    receive
        {Pid, ok} -> ok
    end.


results(ES) ->
    ES ! {self(), results},
    receive
        {Pid, results, Results} -> sort(Results)
    end.




