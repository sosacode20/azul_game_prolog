:-[board].
:-[players].

% predicado para crear los boards de cada uno de los jugadores
create_new_boards(New_boards):-
    get_player_list(Players),
    findall(
        New_board, 
        (member(Player_id:_, Players), new_board(Player_id, New_board)),
        New_boards
    ).
    
% -------------------------------------------------------------------------

new_game(_):-
    get_players_count(Count),
    Count < 2,
    write("Actualmente solo tienes "),
    print(Count),
    write(" jugadores, el minimo es 2 jugadores"), nl,
    write("Porfavor crea mas jugadores (el maximo es 4 jugadores)"), !, fail.

new_game(Game):-
    get_players_count(Count),
    Count inside (2:4), % Verificar que la cantidad de jugadores creados sea valido
    new_bag(Bag),
    create_new_boards(Boards),
    Game = [
        bag:Bag,
        tape:[],
        collections:[],
        boards:Boards
    ],!.

% ---------------------------------------------------------------------------

unpack_game(Game, Bag, Tape, Collections, Boards):-
    Game = [
        bag:Bag,
        tape:Tape,
        collections:Collections,
        boards:Boards
    ].

% Realmente este predicado y el de arriba hacen las mismas cosas
% solo lo repeti para tener un nombre claro para cuando se lea el proyecto
pack_game(Bag, Tape, Collections, Boards, Game):-
    Game = [
        bag:Bag,
        tape:Tape,
        collections:Collections,
        boards:Boards
    ].

% ---------------------------------------------------------------------------

is_game_over(Game, Boards_completed):-
    unpack_game(Game, _, _, _, Boards),
    findall(Board, (member(Board, Boards), board_has_a_complete_wall_row(Board, _)), Boards_completed).
