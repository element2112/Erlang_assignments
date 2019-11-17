-module(electionserver).
-export([start/0, server/1, vote/2, results/1]).
-import(lists, [sort/1]).

-spec start() -> pid().
start() ->
    spawn(?MODULE, server, [[]]).

server(List) ->
  receive
    {Pid, vote, Candidate} ->
      Pid!{self(), ok},
    server(addVote(List, Candidate));
  {Pid, results} ->
    Pid!{self(), results_are, List},
    server(List)
  end.

addVote([], Candidate) -> [{Candidate, 1}];
addVote([{Name, Val}|Rest], Candidate) ->
  if Name == Candidate -> [{Name, Val+1}]++Rest;
     true -> [{Name, Val}] ++ addVote(Rest, Candidate)
  end.

-spec vote(ES::pid(), Candidate::atom()) -> ok.
vote(ES, Candidate) ->
  ES ! {self(), vote, Candidate},
  receive {Pid, ok} -> ok end.

-spec results(ES::pid()) -> [{atom(), non_neg_integer()}].
results(ES) ->
  ES ! {self(), results},
  receive {Pid, results_are, Results} -> sort(Results) end.