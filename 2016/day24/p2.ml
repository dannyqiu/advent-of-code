type loc = int * int
type state = { grid: (loc, char) Hashtbl.t;
               locations: (char, loc) Hashtbl.t;
               distances: ((char * char), int) Hashtbl.t;
               answer: int;
             }
let starting_state = { grid = Hashtbl.create 1;
                       locations = Hashtbl.create 1;
                       distances = Hashtbl.create 1;
                       answer = -1;
                     }

let handle_line state line =
  let line_len = String.length line in
  let y = (Hashtbl.length state.grid) / (line_len) in
  for x = 0 to (line_len - 1); do
    let c = String.get line x in
    if '0' <= c && c <= '9' then Hashtbl.add state.locations c (x, y);
    Hashtbl.add state.grid (x, y) c
  done;
  state

let get_distance state (sx, sy) (ex, ey) =
  let to_visit = Queue.create () in
  let () = Queue.add ((sx, sy), 0) to_visit in
  let add_to_queue (x, y) dist frontier =
    try
      let c = Hashtbl.find state.grid (x, y) in
      if c <> '#' then Queue.add ((x, y), dist) frontier;
      frontier
    with
    | _ -> frontier
  in
  let visited = Hashtbl.create 1 in
  let rec path frontier =
    let ((cx, cy), dist) = Queue.pop frontier in
    if Hashtbl.mem visited (cx, cy)
    then path frontier
    else begin
      Hashtbl.add visited (cx, cy) true;
      if (cx, cy) = (ex, ey)
      then dist
      else begin
        let new_frontier = frontier
                           |> add_to_queue (cx + 1, cy) (dist + 1)
                           |> add_to_queue (cx, cy - 1) (dist + 1)
                           |> add_to_queue (cx, cy + 1) (dist + 1)
                           |> add_to_queue (cx - 1, cy) (dist + 1)
        in
        path new_frontier
      end
    end
  in
  path to_visit

let fill_distances state =
  Hashtbl.iter (fun c1 loc1 ->
      Hashtbl.iter (fun c2 loc2 ->
          if c1 <> c2 then begin
            let dist = get_distance state loc1 loc2 in
            Hashtbl.add state.distances (c1, c2) dist;
            Hashtbl.add state.distances (c2, c1) dist
          end
        ) state.locations
    ) state.locations

let rec calculate_distance state path =
  match path with
  | h1::h2::t -> Hashtbl.find state.distances (h1, h2)
                 + (calculate_distance state (h2::t))
  | _ -> 0

let best_interest_path state =
  (* https://codereview.stackexchange.com/questions/125173/generating-permutations-in-ocaml/125258 *)
  let rec permutations result other = function
  | [] -> [result]
  | hd :: tl ->
    let r = permutations (hd :: result) [] (other @ tl) in
    if tl <> [] then r @ permutations result (hd :: other) tl
    else r
  in
  let elements = Hashtbl.fold (fun k _ l -> k::l) state.locations [] in
  let p = permutations [] [] elements |> List.rev_map (fun l -> ('0'::l) @ ['0']) in
  let d = List.rev_map (calculate_distance state) p in
  List.fold_left min max_int d

let get_steps state =
  fill_distances state;
  (* remove the starting state from permuting, since we cached distances *)
  Hashtbl.remove state.locations '0';
  { state with answer = best_interest_path state }

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> get_steps state

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
  print_string "Fewest number of steps (and going back to 0): ";
  print_int @@ end_state.answer;
  print_endline ""
