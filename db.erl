-module(db).
-export([new/0, put/3, delete/2, get/2, find/2]).

new() -> [].

delete(DK, L) -> [{K, V} || {K, V} <- L, K =/= DK].

put(K, V, L) -> 
    L1 = delete(K, L),
    [{K, V}|L1].

get(_, []) -> {error, no_found};
get(K, [{K, V}|_]) -> V;
get(FK, [{_, _}|T]) -> get(FK, T).

find(FV, L) -> [K || {K, V} <- L, V == FV].        

%Использовать (где можно) модуль Lists