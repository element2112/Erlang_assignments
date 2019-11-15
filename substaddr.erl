-module(substaddr). 
-include("salesdata.hrl"). 
-import(salesdata, [store/2, group/2]).
-export([substaddr/3]).

% Worked on with Daniel Lam

-spec substaddr(SD :: salesdata:salesdata(), New :: string(), Old :: string()) -> salesdata:salesdata().

substaddr(SD, New, Old) -> substaddr_helper(SD, New, Old).

substaddr_helper(S, New, Old) when S#store.address =:= Old -> S#store{address = New, amounts = S#store.amounts};
substaddr_helper(S, _, Old) when S#store.address =/= Old -> S;
substaddr_helper(G, _, _) when G#group.members =:= [] -> G;
substaddr_helper(G, New, Old) -> #group{gname = G#group.gname, members = substaddr_helper2(G#group.members, New, Old)}.

substaddr_helper2([], _, _) -> [];
substaddr_helper2([L | Lst], New, Old) -> [substaddr_helper(L, New, Old) | substaddr_helper2(Lst, New, Old)].

