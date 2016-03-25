-module(ticTacToeServer).
-export([start_server/0, start_room/1, loop_main/1, loop_room/3, check_field/1]).

start_server() ->
    Pid = spawn(ticTacToeServer, loop_main, [db:new()]),
    global:register_name(ticTacToeServer, Pid),
    Pid.

start_room(Name) ->
    Pid = spawn(ticTacToeServer, loop_room, [db:new(), db:new(), -1]),
    global:register_name(Name, Pid),
    Pid.
    
loop_main(Rooms) ->
    receive
        {openRoom, Name} -> 
            Room_Pid = start_room(Name),
            Rooms1 = db:put(Room_Pid, Name, Rooms),
            Room_Pid,
            loop_main(Rooms1);
        {closeRoom, Name} ->
            Room_Pid = global:whereis_name(Name),
            Rooms1 = db:delete(Room_Pid, Rooms),
            exit(Room_Pid, kill),
            loop_main(Rooms1)
    end.

loop_room(Players, Field, Curr_Player_Pid) ->
    receive
        {enterRoom, Pid, Player} ->
            if length(Players) < 2 ->
                   Players1 = db:put(Pid, Player, Players),
                   Pid ! {info_msg, "Entered"},
                   Field1 = db:new(),
                   Curr_Player_Pid1 = Pid,
                   loop_room(Players1, Field1, Curr_Player_Pid1);
               true ->
                   Pid ! {info_msg, "Room is full"},
                   loop_room(Players, Field, Curr_Player_Pid)
            end;     
        {exitRoom, Pid} ->
            Players1 = db:delete(Pid, Players),
            Pid ! {info_msg, "Success exit"},
            Curr_Player_Pid1 = db:first(Players),
            Field1 = db:new(),
            loop_room(Players1, Field1, Curr_Player_Pid1);
        {turn, Pid, [{K, V}|_]} ->
            if Pid == Curr_Player_Pid ->
                   Field1 = db:put(K, V, Field),
                   Curr_Player_Pid ! {info_msg, "Success turn"},   
                   Curr_Player_Pid1 = db:different(Curr_Player_Pid, Players),
                   Curr_Player_Pid1 ! {field, Field1},
                   case check_field(Field1) of
                       true -> 
                           Curr_Player_Pid ! {field, Field1},
                           Curr_Player_Pid ! {info_msg, "You won"},
                           Curr_Player_Pid1 ! {field, Field1},
                           Curr_Player_Pid1 ! {info_msg, "You lose"},
                           Field2 = db:new(),
                           Curr_Player_Pid1 ! {field, Field2},
                           Curr_Player_Pid1 ! {info_msg, "Your turn"},
                           loop_room(Players, Field2, Curr_Player_Pid1);
                       false ->
                           Curr_Player_Pid1 ! {info_msg, "Your turn"},
                           loop_room(Players, Field1, Curr_Player_Pid1)
                   end;              
               true ->
                   Pid ! {info_msg, "Now is not your turn"},
                   loop_room(Players, Field, Curr_Player_Pid)
            end
    end.
    
check_field(Field) ->
    One = db:get(1, Field),
    Two = db:get(2, Field),
    Three = db:get(3, Field),
    Four = db:get(4, Field),
    Five = db:get(5, Field),
    Six = db:get(6, Field),
    Seven = db:get(7, Field),
    Eight = db:get(8, Field),
    Nine = db:get(9, Field),
    if ((One == Two) and (Two == Three) 
           and (One =/= " ") and (Two =/= " ") and (Three =/= " ")) or
       ((Four == Five) and (Five == Six)
           and (Four =/= " ") and (Five =/= " ") and (Six =/= " ")) or
       ((Seven == Eight) and (Eight == Nine)
           and (Seven =/= " ") and (Eight =/= " ") and (Nine =/= " ")) or
       ((One == Four) and (Four == Seven)
           and (One =/= " ") and (Four =/= " ") and (Seven =/= " ")) or
       ((Two == Five) and (Five == Eight)
           and (Two =/= " ") and (Five =/= " ") and (Eight =/= " ")) or
       ((Three == Six) and (Six == Nine)
           and (Three =/= " ") and (Six =/= " ") and (Nine =/= " ")) or
       ((One == Five) and (Five == Nine)
           and (One =/= " ") and (Five =/= " ") and (Nine =/= " ")) or
       ((Three == Five) and (Five == Seven)
           and (Three =/= " ") and (Five =/= " ") and (Seven =/= " ")) ->
           true;
       true -> false
   end.

%% Ход - {номер_клетки: 1-9, "X/O"}.
%% cd("C:/Users/Александр/Documents/GitHub/demo_repo").
%% c(ticTacToeServer).
%% ticTacToeServer:start_server().
%% c(ticTacToeClient).
%% Client1 = ticTacToeClient:start_client().
%% Client2 = ticTacToeClient:start_client().
%% ticTacToeClient:open_room(komnata1).
%% ticTacToeClient:enter_room(komnata1, Client1, "vasya").
%% ticTacToeClient:enter_room(komnata1, Client2, "petya").
%% ticTacToeClient:turn(komnata1, Client1, [{1, "X"}]).

