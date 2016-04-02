-module(tttGenServer).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2,
         handle_info/2, terminate/2, code_change/3, start/1]).
-export([start_client/0, loop_main/0, enter_room/3, exit_room/2, turn/3]).

%----------------SERVER----------------
start(Name) ->
   gen_server:start_link({global, Name}, ?MODULE, [], []).

init([]) ->
  State = {db:new(), db:new(), -1},
  {ok, State}.

handle_call({enterRoom, Pid, Player}, _From, {Players, Field, Curr_Player_Pid}) ->
  NewState = ticTacToeServer:do_enter(Players, Field, Curr_Player_Pid, Pid, Player),
  {reply, ok, NewState};

handle_call({exitRoom, Pid}, _From, {Players, _Field, _Curr_Player_Pid}) ->
  NewState = ticTacToeServer:do_exit(Players, Pid),
  {reply, ok, NewState};

handle_call({turn, Pid, [{K, V}|_]}, _From, {Players, Field, Curr_Player_Pid}) ->
  NewState = ticTacToeServer:do_turn(Players, Field, Curr_Player_Pid, Pid, K, V),
  {reply, ok, NewState}.
  
handle_cast(_Message, State) -> { noreply, State }.
handle_info(_Message, State) -> { noreply, State }.
terminate(_Reason, _State) -> ok.
code_change(_OldVersion, State, _Extra) -> { ok, State }.
  
%----------------CLIENT----------------
start_client() ->
    spawn(tttGenServer, loop_main, []).

loop_main() ->
    receive
        {info_msg, MSG} ->
            io:format("~s~n", [MSG]),
            loop_main();
        {field, Field} ->
            ticTacToeClient:print_field(Field),
            loop_main()
    end.
    
enter_room(Name, Pid, Player) ->
    gen_server:call({global, Name}, {enterRoom, Pid, Player}).
    
exit_room(Name, Pid) ->
    gen_server:call({global, Name}, {exitRoom, Pid}).
    
turn(Name, Pid, Turn) ->
    gen_server:call({global, Name}, {turn, Pid, Turn}).
