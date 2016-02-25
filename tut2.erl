-module(tut2).
-export([hi/0, fac/1, fib/1, member/2, price/1, cost/1]).

hi() ->
	io:format("Hello world!~n").

%fac(0) -> 1;
%fac(1) -> 1;
%fac(N) -> N * fac(N-1).

fac(N) ->
	if  N == 0 -> 1;
		N == 1 -> 1;
		true -> N * fac(N-1)
	end.

%fib(0) -> 1;
%fib(1) -> 1;
%fib(N) -> fib(N-1) + fib(N-2).

fib(N) -> 
	if N == 0 -> 1;
	   N == 1 -> 1;
	   true -> fib(N-1) + fib(N-2)
	end.

%member([], _) -> false;
%member([H|_], H) -> true;
%member([_|T], E) -> member(T, E).

member([], _) -> false;
member([H|T], E) ->
	if H == E -> true;
	   true -> member(T, E)
	end.

price(apple) -> 100;
price(pear) -> 150;
price(milk) -> 70;
price(beef) -> 400;
price(pork) -> 300.

%cost([]) -> 0;
%cost([{H1, H2}| T]) -> price(H1) * H2 + cost(T).

cost(N) -> 
	case N of
		[] -> 0;
		[{H1, H2}| T] -> price(H1) * H2 + cost(T)
	end.
