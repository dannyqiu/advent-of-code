type direction = North | East | South | West
type state = { dir: direction;
               x: int;
               y: int;
             }
let starting_state = { dir = North;
                       x = 0;
                       y = 0;
                     }

let turn_left = function
  | North -> West
  | East -> North
  | South -> East
  | West -> South

let turn_right = function
  | North -> East
  | East -> South
  | South -> West
  | West -> North

let move_forward state dist =
  match state.dir with
  | North -> { state with y = state.y + dist }
  | East -> { state with x = state.x + dist }
  | South -> { state with y = state.y - dist }
  | West -> { state with x = state.x - dist }

let handle_cmd state cmd =
  if String.length cmd = 0
  then state
  else begin
    let turn = String.get cmd 0 in
    let fwd = String.sub cmd 1 (String.length cmd - 1) |> int_of_string in
    match turn with
    | 'R' -> begin
        let new_state = { state with dir = turn_right state.dir } in
        move_forward new_state fwd
      end
    | 'L' -> begin
        let new_state = { state with dir = turn_left state.dir } in
        move_forward new_state fwd
      end
    | _ -> failwith @@ "Invalid command: " ^ (String.make 1 turn)
  end

let handle_input line =
  let cmds = Str.(split (regexp "[, ]") line) in
  List.fold_left handle_cmd starting_state cmds

let get_final_dist state = state.x + state.y

let _ =
  let result = input_line stdin |> handle_input |> get_final_dist |> abs in
  print_string "Distance to Easter Bunny HQ: ";
  print_int result;
  print_endline ""
