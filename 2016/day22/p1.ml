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
               answer: int;
             }
let starting_state = { grid = Hashtbl.create 1;
                       nodes = [ ];
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
        { state with nodes = node::state.nodes }
      end
    | _ -> state

let rec get_pairs state =
  let sort_used = List.sort (fun n1 n2 -> n1.used - n2.used) state.nodes in
  let sort_avail = List.sort (fun n1 n2 -> n1.avail - n2.avail) state.nodes in
  let rec run cur_used cur_avail count =
    match cur_used, cur_avail with
    | hu::tu, ha::ta -> begin
        if hu.used = 0 then
          run tu cur_avail count
        else if hu.used < ha.avail then
          run tu cur_avail (count
                            + (List.length cur_avail)
                            - (if hu.used < hu.avail then 1 else 0))
        else run cur_used ta count
      end
    | [], _ -> count
    | _, [] -> count
  in
  { state with answer = run sort_used sort_avail 0 }

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> get_pairs state

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
  print_string "Number of viable pairs: ";
  print_int @@ end_state.answer;
  print_endline ""
