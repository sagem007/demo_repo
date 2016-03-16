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