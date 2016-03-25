-module(ticTacToeClient).
-export([start_client/0, loop_main/0, open_room/1, close_room/1, enter_room/3, exit_room/2, turn/3, print_field/1]).

start_client() ->
    spawn(ticTacToeClient, loop_main, []).

loop_main() ->
    receive
        {info_msg, MSG} ->
            io:format("~s~n", [MSG]),
            loop_main();
        {field, Field} ->
            print_field(Field),
            loop_main()
    end.

open_room(Name) ->
    global:send(ticTacToeServer, {openRoom, Name}).

close_room(Name) ->
    global:send(ticTacToeServer, {closeRoom, Name}).
    
enter_room(Name, Pid, Player) ->
    global:send(Name, {enterRoom, Pid, Player}).
    
exit_room(Name, Pid) ->
    global:send(Name, {exitRoom, Pid}).
    
turn(Name, Pid, Turn) ->
    global:send(Name, {turn, Pid, Turn}).

print_field(Field) -> 
    io:format("-------------~n", []),
    io:format("| ~s | ~s | ~s |~n", [db:get(1, Field), db:get(2, Field), db:get(3, Field)]),
    io:format("| ~s | ~s | ~s |~n", [db:get(4, Field), db:get(5, Field), db:get(6, Field)]),
    io:format("| ~s | ~s | ~s |~n", [db:get(7, Field), db:get(8, Field), db:get(9, Field)]),
    io:format("-------------~n", []).
