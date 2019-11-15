-module(concat).

-export([concat/1]).

-spec concat(Lists :: [[t]]) -> [t].

concat([]) -> [];
concat([[]]) -> [];
concat([L | Lst]) -> L ++ concat(Lst).