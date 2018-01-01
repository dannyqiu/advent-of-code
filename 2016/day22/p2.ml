type loc = int * int
type node = { x: int;
              y: int;
              size: int;
              used: int;
              avail: int;
              used_percent: int;
            }
type state = { grid: (loc, node) Hashtbl.t;
               nodes: node list;
               zero_loc: loc;
               answer: int;
             }
let starting_state = { grid = Hashtbl.create 1;
                       nodes = [ ];
                       zero_loc = (-1, -1);
                       answer = -1;
                     }

let node_regex = Str.regexp "/dev/grid/node-x\\([0-9]+\\)-y\\([0-9]+\\) +\\([0-9]+\\)T +\\([0-9]+\\)T +\\([0-9]+\\)T +\\([0-9]+\\)%"

let handle_line state line =
  match line with
    | s when Str.string_match node_regex s 0 -> begin
        let node = { x = Str.matched_group 1 s |> int_of_string;
                     y = Str.matched_group 2 s |> int_of_string;
                     size = Str.matched_group 3 s |> int_of_string;
                     used = Str.matched_group 4 s |> int_of_string;
                     avail = Str.matched_group 5 s |> int_of_string;
                     used_percent = Str.matched_group 6 s |> int_of_string;
                   } in
        Hashtbl.add state.grid (node.x, node.y) node;
        let new_state = { state with nodes = node::state.nodes } in
        if node.used = 0
        then { new_state with zero_loc = (node.x, node.y) }
        else new_state
      end
    | _ -> state

let path_length state (sx, sy) (ex, ey) =
  let to_visit = Queue.create () in
  let () = Queue.add ((sx, sy), 0) to_visit in
  let add_to_queue (x, y) cur len frontier =
    try
      let node = Hashtbl.find state.grid (x, y) in
      if cur.size > node.used then Queue.add ((node.x, node.y), len) frontier;
      frontier
    with
    | _ -> frontier
  in
  let visited = Hashtbl.create 1 in
  let rec path frontier =
    let ((cx, cy), len) = Queue.pop frontier in
    if Hashtbl.mem visited (cx, cy)
    then path frontier
    else begin
      Hashtbl.add visited (cx, cy) true;
      let node = Hashtbl.find state.grid (cx, cy) in
      if cx = ex && cy = ey
      then len
      else begin
        let new_frontier = frontier
                           |> add_to_queue (cx - 1, cy) node (len + 1)
                           |> add_to_queue (cx + 1, cy) node (len + 1)
                           |> add_to_queue (cx, cy - 1) node (len + 1)
                           |> add_to_queue (cx, cy + 1) node (len + 1)
        in
        path new_frontier
      end
    end
  in
  path to_visit

let rec get_steps state =
  let max_x = Hashtbl.fold (fun (x, _) _ mx -> max x mx) state.grid (-1) in
  let empty_adj_to_goal = (path_length state state.zero_loc (max_x, 0)) - 1 in
  (* The cycle of moving from goal with empty space next to it, to (0, 0):
   *   . _ G   ->   _ G .
   *   . . .        . . .
   * Each cycle takes 5 moves
   *)
  let goal_adj_to_access = (max_x - 1) * 5 in
  { state with answer = empty_adj_to_goal + goal_adj_to_access + 1 }

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
  print_string "Fewest number of steps: ";
  print_int @@ end_state.answer;
  print_endline ""
