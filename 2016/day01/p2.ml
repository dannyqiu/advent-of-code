module PairCompare = struct
  type t = int * int
  let compare a b =
    if fst a <> fst b
    then fst a - fst b
    else snd a - snd b
end
module PairSet = Set.Make(PairCompare)

type direction = North | East | South | West
type state = { visited: PairSet.t;
               dir: direction;
               x: int;
               y: int;
             }
let starting_state = { visited = PairSet.empty;
                       dir = North;
                       x = 0;
                       y = 0;
                     }
type completed = No of state | Yes of (int * int)

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

let handle_turn state turn =
  match turn with
  | 'R' -> { state with dir = turn_right state.dir }
  | 'L' -> { state with dir = turn_left state.dir }
  | _ -> failwith @@ "Invalid turn direction: " ^ (String.make 1 turn)

let rec handle_movement state_opt fwd =
  if fwd = 0
  then state_opt
  else begin
    match state_opt with
    | No state -> begin
        let new_state = move_forward state 1 in
        let new_state_loc = (new_state.x, new_state.y) in
        if PairSet.mem new_state_loc new_state.visited
        then Yes new_state_loc
        else begin
          let new_state_opt =
            No { new_state with
                 visited = PairSet.add new_state_loc new_state.visited
               } in
          handle_movement new_state_opt (fwd - 1)
        end
      end
    | Yes loc -> Yes loc
  end

let handle_cmd state_opt cmd =
  if String.length cmd = 0
  then state_opt
  else begin
    match state_opt with
    | No state -> begin
        let turn = String.get cmd 0 in
        let turned_state = handle_turn state turn in
        let fwd = String.sub cmd 1 (String.length cmd - 1) |> int_of_string in
        handle_movement (No turned_state) fwd
      end
    | Yes loc -> Yes loc
  end

let handle_input line =
  let cmds = Str.(split (regexp "[, ]") line) in
  List.fold_left handle_cmd (No starting_state) cmds

let get_final_dist state_opt =
  match state_opt with
  | Yes (x, y) -> x + y
  | No _ -> failwith "There is not location that is visited twice"

let _ =
  let result = input_line stdin |> handle_input |> get_final_dist |> abs in
  print_string "Distance to Easter Bunny HQ: ";
  print_int result;
  print_endline ""
