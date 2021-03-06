%aksenov364@gmail.com

-module(tut1).
-export([hi/0, fac/1, fib/1, member/2, price/1, cost/1, reduce/3, filter/2]).

hi() ->
	io:format("Hello world!~n").

fac(0) -> 1;
fac(1) -> 1;
fac(N) -> N * fac(N-1).

fib(0) -> 1;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

member([], _) -> false;
member([H|_], H) -> true;
member([_|T], E) -> member(T, E).

price(apple) -> 100;
price(pear) -> 150;
price(milk) -> 70;
price(beef) -> 400;
price(pork) -> 300.

cost([]) -> 0;
cost([{H1, H2}| T]) -> price(H1) * H2 + cost(T).

reduce(_, Start, []) -> Start;
reduce(F, Start, [H|T]) -> reduce(F, F(Start, H), T).

filter(_, []) -> [];
filter(F, [H|T]) ->
    case F(H) of
        true -> [H|filter(F, T)];
        false -> filter(F, T)
    end.
    
