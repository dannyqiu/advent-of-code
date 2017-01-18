type room = int * int
type state = { passcode: string;
               path: string;
               current_room: room;
             }
let starting_state = { passcode = "";
                       path = "";
                       current_room = (0, 0);
                     }
let answer_state = ref starting_state
let end_room = (3, 3)

let frontier = Queue.create ()

let handle_line state line =
  { state with passcode = line }

let is_valid_room (x, y) = x >= 0 && x <= 3 && y >= 0 && y <= 3

let is_open_door c = c >= 'b' && c <= 'f'

let add_if_open hash index dir acc =
  if String.get hash index |> is_open_door
  then dir::acc
  else acc

let get_open_doors state =
  let hash = (state.passcode ^ state.path) |> Digest.string |> Digest.to_hex in
  [] |> add_if_open hash 0 ("U", (0, -1))
     |> add_if_open hash 1 ("D", (0, 1))
     |> add_if_open hash 2 ("L", (-1, 0))
     |> add_if_open hash 3 ("R", (1, 0))

let rec find_path () =
  if Queue.is_empty frontier then !answer_state
  else begin
    let cur_state = Queue.take frontier in
    if cur_state.current_room = end_room then begin
      answer_state := cur_state;
      find_path ()
    end
    else begin
      let open_doors = get_open_doors cur_state in
      let add_move_to_frontier (dir, (dx, dy)) =
        let (x, y) = cur_state.current_room in
        let new_room = (x + dx, y + dy) in
        let new_state = { cur_state with path = cur_state.path ^ dir;
                                         current_room = new_room }
        in
        if is_valid_room new_room then Queue.add new_state frontier
      in
      List.iter add_move_to_frontier open_doors;
      find_path ()
    end
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> begin
      Queue.add state frontier;
      find_path ()
    end

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
  print_string @@ "Length of longest path to reach the vault: ";
  print_int @@ String.length end_state.path;
  print_endline ""
