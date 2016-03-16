-behaviour(gen_server);
-compile(export_all);
init([]) ->
    {ok, #state{}}.
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.
handle_cast(_Msg, State) ->
    {noreply, State}.
terminate(_Reason, State) ->
    ok.
code_change(_OldVsn, State, Extra) ->
    {ok, State}.

/////////////////////

-recor(atom, {}).

/////////////////////

gen_server_call()

werl -name erl1@10.105.104.174 -setcookie class1
net_adm:ping('erl1@10.105.104.173').

Server1 = spawn('erl1@10.105.104.173', lb_server, loop, [db:new()]).
Client1 = spawn('erl1@10.105.104.173', lb_client, loop, []).
Client2 = spawn('erl1@10.105.104.173', lb_client, loop, []).
global:register_name(chat_server, Server1).
global:send(chat_server,{connect, Client1, "vasya"}).
global:send(chat_server,{connect, Client2, "petya"}).
global:send(chat_server,{msg, Client1, "hello"}).

{chat_server, 'erl1@10.105.104.173'}!{connect, Client1, "vasya"}.
{chat_server, 'erl1@10.105.104.173'}!{connect, Client2, "petya"}.
{chat_server, 'erl1@10.105.104.173'}!{msg, Client1, "Hello"}.

global:whereis_name(chat_server).

