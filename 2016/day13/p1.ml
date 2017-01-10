type state = { steps: int;
               x: int;
               y: int;
               key: int;
             }
let starting_state = { steps = 0;
                       x = 1;
                       y = 1;
                       key = 0;
                     }

let map = Hashtbl.create 1
let frontier = Queue.create ()
let target_x = 31
let target_y = 39

let handle_line state line =
  let favorite_number = int_of_string line in
  { state with key = favorite_number }

let count_ones_bits num =
  let rec count bits num =
    if num > 0
    then count (bits + (num land 1)) (num lsr 1)
    else bits
  in
  count 0 num

let is_open_space state x y =
  let magic = x*x + 3*x + 2*x*y + y + y*y in
  let magic = magic + state.key in
  (count_ones_bits magic) mod 2 = 0

let find_neighbors state cur_x cur_y =
  let deltas = [(0, -1); (-1, 0); (1, 0); (0, 1)] in
  let neighbors = List.rev_map (fun (x, y) -> (cur_x + x, cur_y + y)) deltas in
  let is_valid (x, y) = x >= 0
                        && y >= 0
                        && is_open_space state x y
                        && not (Hashtbl.mem map (x, y)) in
  List.filter is_valid neighbors

let convert state (x, y) =
  { state with steps = state.steps + 1; x = x; y = y }

let rec find_target () =
  if Queue.is_empty frontier
  then failwith @@ "Cannot reach (" ^ (string_of_int target_x) ^ ", "
                                    ^ (string_of_int target_y) ^ ")"
  else begin
    let state = Queue.pop frontier in
    if state.x = target_x && state.y = target_y
    then state
    else begin
      let neighbors = find_neighbors state state.x state.y in
      let frontier_states = List.rev_map (convert state) neighbors in
      List.fold_left (fun () e -> Queue.add e frontier) () frontier_states;
      List.fold_left (fun () (x, y) -> Hashtbl.add map (x, y) 1) () neighbors;
      find_target ()
    end
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> begin
      Queue.push state frontier;
      Hashtbl.add map (state.x, state.y) 1;
      find_target ()
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
  print_string @@ "Steps required to reach ("
                  ^ (string_of_int target_x) ^ ", "
                  ^ (string_of_int target_y) ^ "): ";
  print_int end_state.steps;
  print_endline ""
