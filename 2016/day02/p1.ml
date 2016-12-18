type state = { x: int;
               y: int;
             }
let starting_state = { x = 0;
                       y = 0;
                     }

let grid = [| [| "1"; "2"; "3" |];
              [| "4"; "5"; "6" |];
              [| "7"; "8"; "9" |];
           |]

let move_direction state dir =
  match dir with
  | 'U' -> { state with y = max 0 (state.y - 1) }
  | 'R' -> { state with x = min 2 (state.x + 1) }
  | 'D' -> { state with y = min 2 (state.y + 1) }
  | 'L' -> { state with x = max 0 (state.x - 1) }
  | _ -> failwith @@ "Invalid direction: " ^ (String.make 1 dir)

let handle_cmd state cmd =
  if String.length cmd = 0
  then state
  else begin
    let dir = String.get cmd 0 in
    move_direction state dir
  end

let rec handle_input state lines =
  match lines with
  | [] -> ""
  | h::t -> begin
      let cmds = Str.(split (regexp "") h) in
      let new_state = List.fold_left handle_cmd state cmds in
      let code = grid.(new_state.y).(new_state.x) in
      code ^ (handle_input new_state t)
    end

let rec get_all_input buffer =
  try
    get_all_input ((input_line stdin)::buffer)
  with
  | End_of_file -> List.rev buffer

let _ =
  let result = get_all_input [] |> handle_input starting_state in
  print_string "Bathroom Code: ";
  print_string result;
  print_endline ""
