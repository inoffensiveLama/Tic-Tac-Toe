-module(tic_tac_toe).
-export([start/0, play/2]).

% Start the game
start() ->
    io:format("Welcome to Tic Tac Toe!~n"),
    play(init_board(), x).

% Initialize the board
init_board() ->
    [{empty, empty, empty},
     {empty, empty, empty},
     {empty, empty, empty}].

% Print the board
print_board(Board) ->
    io:format("~n"),
    lists:foreach(fun(Row) ->
        print_row(Row)
    end, Board),
    io:format("~n").

% Helper function to print each row
print_row(Row) ->
    lists:foreach(fun(Cell) ->
        case Cell of
            empty -> io:write(". ");
            x -> io:write("X ");
            o -> io:write("O ")
        end
    end, tuple_to_list(Row)), % Convert tuple to list
    io:format("~n").

% Play the game
play(Board, Player) ->
    io:format("Current Board: ~p~n", [Board]), % Debugging line
    print_board(Board),
    case check_winner(Board) of
        {winner, Winner} ->
            io:format("Player ~p wins!~n", [Winner]);
        {draw} ->
            io:format("It's a draw!~n");
        continue ->
            io:format("Player ~p, enter your move (row and column): ", [Player]),
            {Row, Col} = get_move(),
            case make_move(Board, Player, Row, Col) of
                {error, Msg} ->
                    io:format("~s~n", [Msg]),
                    play(Board, Player);
                NewBoard ->
                    io:format("Making move: Player ~p at {~p, ~p}~n", [Player, Row, Col]), % Debugging line
                    play(NewBoard, switch_player(Player))
            end
    end.

% Get the player's move
get_move() ->
    Input = io:get_line(""),
    {Row, Col} = parse_move(string:trim(Input)),
    {Row, Col}.

parse_move(Input) ->
    [RowStr, ColStr] = string:tokens(Input, " "),
    {list_to_integer(RowStr), list_to_integer(ColStr)}.

% Make a move on the board
make_move(Board, Player, Row, Col) ->
    case lists:nth(Row + 1, Board) of
        RowList when Row >= 0, Row < 3 ->
            case lists:nth(Col + 1, RowList) of
                empty ->
                    NewRowList = lists:replace_element(Col + 1, Player, RowList),
                    NewBoard = lists:replace_element(Row + 1, NewRowList, Board),
                    NewBoard;
                _ ->
                    {error, "Cell already taken!"}
            end;
        _ ->
            {error, "Invalid move! Row and column must be 0, 1, or 2."}
    end.

% Custom transpose function
transpose([]) -> [];
transpose(List) ->
    lists:map(fun(X) -> tuple_to_list(X) end, List).

% Check for a winner
check_winner(Board) ->
    Rows = Board,
    Cols = transpose(Board),
    Diags = [
        [lists:nth(1, tuple_to_list(lists:nth(1, Board))), lists:nth(2, tuple_to_list(lists:nth(1, Board))), lists:nth(3, tuple_to_list(lists:nth(1, Board)))],
        [lists:nth(1, tuple_to_list(lists:nth(3, Board))), lists:nth(2, tuple_to_list(lists:nth(2, Board))), lists:nth(3, tuple_to_list(lists:nth(2, Board)))]
    ],
    case check_lines(Rows) orelse check_lines(Cols) orelse check_lines(Diags) of
        {winner, Winner} -> {winner, Winner}; % If there is a winner, return it
        _ ->
            % Check for a draw
            case all_cells_filled(Rows) of
                true -> {draw};
                false -> continue
            end
    end.

% Check if all cells are filled
all_cells_filled(Rows) ->
    lists:all(fun(Row) -> 
        lists:all(fun(Cell) -> Cell =/= empty end, tuple_to_list(Row)) 
    end, Rows).

check_lines(Lines) ->
    lists:foldl(fun(Line, Acc) ->
        case Acc of
            {winner, _} -> Acc;
            _ ->
                % Convert the tuple to a list before checking uniqueness
                LineList = tuple_to_list(Line),
                case lists:uniq(LineList) of
                    [Player] when Player =/= empty -> {winner, Player};
                    _ -> Acc
                end
        end
    end, continue, Lines).

% Switch players
switch_player(x) -> o;
switch_player(o) -> x.