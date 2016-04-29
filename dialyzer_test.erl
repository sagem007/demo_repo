%% dialyzer --build_plt --apps kernel stdlib crypto mnesia sasl common_test
%% dialyzer "имя модуля".erl

-module(dialyzer_test).
-export([do_work/0, find_path/4]).

-record(user, { name = "" :: string(), 
                age = 0 :: non_neg_integer(), 
                friends = [] :: [usr()]}).

-type usr() :: #user{}.

%% TODO: Найти расстояние между юзерами через friends
do_work() ->
        U1 = #user{ name = "David", age = 25, friends = []},
        U2 = #user{ name = "Duchovny", age = 25, friends = [U1]},
        U3 = #user{ name = "Hank", age = 55, friends = [U2]},
        U4 = #user{ name = "Moody", age = 55, friends = [U3]},
        find_path(U4, U1, [], []).

find_path([], _, __, ___) -> false;
find_path(User, User, Checked, Result) ->
    Checked1 = Checked ++ [User], 
    Result1 = Checked1 ++ Result,
    Result1;
find_path(User1, User2, Checked, Result) ->
    case lists:member(User1, Checked) of
		false ->
            Checked1 = Checked ++ [User1],
            lists:foreach(fun(X) -> 
                            find_path(X, User2, Checked1, Result)
                          end, User1#user.friends)
	end.
    
    
    