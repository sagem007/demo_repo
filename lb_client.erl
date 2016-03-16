-module(lb_client).
-export([connect/2, disconnect/1, send/2, start_client/0, loop/0]).

start_client() ->
    spawn(lb_client, loop, []).
    
loop() ->
    receive
        {msg, User, MSG} ->
            io:format("(~p) ~s: ~s~n", [self(), User, MSG]),
            loop();
        {info_msg, MSG} ->
            io:format("~s~n", [MSG]),
            loop();
        {close, Reason} ->
            io:format("Client stopped: ~s~n", [Reason]),
            disconnect(self())
    end.
    
connect(User, Pid) ->
    global:send(chat_server, {connect, Pid, User}).

disconnect(Pid) ->
    global:send(chat_server, {disconnect, Pid}).
    
send(MSG, Pid) ->
    global:send(chat_server, {msg, Pid, MSG}).

%c(lb_client).
%Client1 = lb_client:start_client().
%Client2 = lb_client:start_client(). 
%lb_client:connect("vasya", Client2).
%lb_client:connect("petya", Client1).
%lb_client:send("hello from Client", Client).