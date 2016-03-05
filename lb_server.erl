-module(lb_server).
-export([loop/1, to_users/4, start_server/0]).

start_server() ->
    Pid = spawn(lb_server, loop, [db:new()]),
    register(chat_server, Pid).
    
loop(Users) ->
    receive
        {msg, Pid, MSG} ->
            case is_process_alive(Pid) of
                true ->
                    User = db:get(Pid, Users),
                    to_users(Users, Pid, User, MSG),
                    loop(Users);
                false ->
                    io:format("~s~n", ["Pid is not alive"]),
                    loop(Users)
            end;
        {connect, Pid, User} ->
            case is_process_alive(Pid) of
                true ->
                    Users1 = db:put(Pid, User, Users),
                    %io:format("~p: ~s~n", [Pid, User]),
                    Pid ! {info_msg, "Success connection"},
                    loop(Users1);
                false ->
                    io:format("~s~n", ["Pid is not alive"]),
                    loop(Users)
            end;
        {disconnect, Pid} ->
            case is_process_alive(Pid) of
                true ->
                    Users1 = db:delete(Pid, Users),
                    Pid ! {info_msg, "Success disconnection"},
                    exit(Pid, kill),
                    loop(Users1);
                false ->
                    io:format("~s~n", ["Pid is not alive"]),
                    loop(Users)
           end;
        {close, Reason} ->
            io:format("Server stopped: ~s~n", [Reason])
    end.

to_users([], _, __, ___) -> 
    io:format("~s~n", ["Message send"]);
to_users([{K, _}|T], Pid, User, MSG) ->
    if K == Pid -> 
        to_users(T, Pid, User, MSG);
        true ->
            K ! {msg, User, MSG},
            to_users(T, Pid, User, MSG)
    end.
    
%c(lb_server). 
%lb_server:start_server().                     