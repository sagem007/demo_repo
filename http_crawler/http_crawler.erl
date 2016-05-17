%%% cd("C:/Users/Александр/Documents/GitHub/demo_repo/http_crawler").
%%% c(http_crawler).
%%% http_crawler:start().


%%% {ok, {{_, RetCode, _}, _, Result}} = httpc:request("http://airwar.ru/image").
%%% Tree = mochiweb_html:parse(Result).
%%% Imgs = mochiweb_xpath:execute("//img/@src", Tree).
%%% Links = mochiweb_xpath:execute("//a/@href", Tree).


-module(http_crawler).
-compile(export_all).

%%% Modified code
print_page(Page) ->
   mochiweb_html:parse(Page).

process_page(W, Url) ->
    MyPid = self(),
    case get_url_contents(Url) of
        {ok, Data} ->
            Tree = mochiweb_html:parse(Data),
            Links = lists:flatten(mochiweb_xpath:execute("//a/@href", Tree)),
            Pids = [spawn(fun() -> 
                            process_link(W, MyPid, Url, binary_to_list(Str))
                          end) || Str <- Links],
            collect(length(Pids));
        _ -> ok
    end.

process_link(W, Parent, Dir, Url) ->
    case get_link_type(Url) of
        image -> process_image(W, Dir ++ Url);
        page  -> process_page(W, Dir ++ Url);
        _    -> process_other(W, Dir ++ Url)
    end,
    done(Parent).











%%% Base code
get_start_base() -> "http://airwar.ru/".
get_start_url() -> get_start_base() ++ "image/".
out_file_name() -> "pictures.txt".

start() ->
    inets:start(),
    Writer = start_write(),
    process_page(Writer, get_start_url()),
    stop_write(Writer).
    
start_write() -> spawn(fun write_proc/0).
stop_write(W) -> W ! stop.
write(W, String) -> W ! {write, String}.
write_proc() -> write_loop([], 0).

write_loop(Data, DataLen) ->
    receive
        stop ->
            io:format("Saving ~b entries~n", [DataLen]),
            {ok, F} = file:open(out_file_name(), write),
            [io:format(F, "~s~n", [S])   ||  S <- Data],
            file:close(F),
            io:format("Done~n");
        {write, String} ->
            %io:format("Adding: ~s~n", [String]),
            case DataLen rem 1000 of
                0 -> io:format("Downloaded: ~p~n", [DataLen]);
                _ -> ok
            end,
            write_loop([String|Data], 1 + DataLen)
    after 10000 ->
            io:format("Stop on timeout~n"),
            stop_write(self()),
            write_loop(Data, DataLen)
    end.

get_url_contents(Url) -> get_url_contents(Url, 5).
get_url_contents(_Url, 0) -> failed;
get_url_contents(Url, MaxFailures) ->
  case httpc:request(Url) of
    {ok, {{_, RetCode, _}, _, Result}} -> 
        if
            RetCode == 200; RetCode == 201 ->
                {ok, Result};
            RetCode >= 500 ->
                timer:sleep(1000),
                get_url_contents(Url, MaxFailures-1);
            true ->
                failed
        end;
    {error, _Why} ->
        timer:sleep(1000),
        get_url_contents(Url, MaxFailures-1)
  end.

get_link_type(Url) ->
    {ok, ReImg} = re:compile("\\.(gif|jpg|jpeg|png)",
                             [extended, caseless]),
    {ok, RePage} = re:compile("^[^/]+/$"),
    case re:run(Url, ReImg) of
        {match, _} -> image;
        _          -> case re:run(Url, RePage) of
                           {match, _} -> page;
                           _          -> strange
                      end
    end.

collect(0) -> ok;
collect(N) ->
  receive
    done -> collect(N - 1)
  end.
  
done(Parent) ->
    Parent ! done.

process_image(W, Url) ->
    write(W, Url).

process_other(_W, _Url) ->
    ok.