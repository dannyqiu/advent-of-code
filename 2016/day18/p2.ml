type state = { row: string;
               row_no: int;
               safe_tiles: int;
             }
let starting_state = { row = "";
                       row_no = 0;
                       safe_tiles = 0;
                     }
let end_row = 400000

let count_safe_tiles r =
  let count = ref 0 in
  String.iter (fun c -> if c = '.' then incr count) r;
  !count

let handle_line state line =
  { row = line;
    row_no = 1;
    safe_tiles = count_safe_tiles line;
  }

let generate_next_row r =
  let generate_trap i c =
    let left = if i - 1 >= 0 then String.get r (i - 1) else '.' in
    let right = if i + 1 < String.length r then String.get r (i + 1) else '.' in
    match left, c, right with
    | '^', '^', '.' -> '^'
    | '.', '^', '^' -> '^'
    | '^', '.', '.' -> '^'
    | '.', '.', '^' -> '^'
    | _ -> '.'
  in
  String.mapi generate_trap r

let rec generate_map state =
  if state.row_no = end_row then state
  else begin
    let next_row = generate_next_row state.row in
    let next_state = {
      row = next_row;
      row_no = state.row_no + 1;
      safe_tiles = state.safe_tiles + count_safe_tiles next_row
    } in
    generate_map next_state
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> generate_map state

let rec get_all_input buffer =
  try
    let line = input_line stdin in
    if String.length line = 0
    then buffer
    else get_all_input (line::buffer)
  with
  | End_of_file -> List.rev buffer

let _ =
  let end_state = get_all_input [] |> handle_input starting_state in
  print_string @@ "Safe tiles in "
                  ^ (string_of_int end_row) ^ " rows: ";
  print_int end_state.safe_tiles;
  print_endline ""
