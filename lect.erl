%cd("C:/Users/Александр/Documents/GitHub/demo_repo").

-module(t1).
-export([proc1/0]).

proc1() ->
    receive
        {msg, MSG} ->
            io:format('~s~n', [MSS]),
            MSG
            %after time_ms
        end.

loop(State) ->
    receive
        % State -> State1
    end,
    loop(State1).

loop(State) ->
    MyPid = self(),
    Pid1 = spawn_link(mod1, dn1, []),
    {Pid, Ref} -> spawn_monitor(Mod, Fn, []),
    receive
        {connect, User} ->
            State1 = add_user(User, State),
            loop(State1);
        {disconnect, User} ->
            State1 = remove_user(User, State),
            loop(State1);
        {close, Reason} ->
            io:format("Server stopped");
        {'EXIT', Pid, Why} -> ...
        {'DOWN', Ref, process, Pid, Why} -> ...
    end.
    
Pid = spawn(fun() -> 
                receive
                end)
                
% Server
register(my_server, Pid).

my_server ! {msg}.

unregister(my_server).

% Linking
Pid1 = spawn_link(Mod, Fn, Args). % -> Pid
Pid2 = spawn_link(Fn).

% Stop processing
exit(Why).
exit(Pid, Why).