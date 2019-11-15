-module(count_matching).

-export([count_matching/2]).

-spec count_matching (Pred::fun((T) -> boolean()), Lst::list(T)) -> non_neg_integer().


count_matching(P, Lst) -> count_matching_helper(P, Lst, 0).


count_matching_helper(P, [], Acc) -> Acc;
count_matching_helper(P, [L | Lst], Acc) ->
    case P(L) of
        true -> count_matching_helper(P, Lst, (Acc + 1));
        false -> count_matching_helper(P, Lst, Acc)
    end.
