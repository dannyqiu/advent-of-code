type state = { intervals: (int * int) list;
               answer: int
             }
let starting_state = { intervals = [ ];
                       answer = -1;
                     }

let handle_line state line =
  match Str.split (Str.regexp "-") line |> List.map int_of_string with
  | [low; high] -> { state with intervals = (low, high)::state.intervals }
  | _ -> failwith @@ "Invalid input, needs to be <low>-<high>"

let rec find_lowest state =
  let sorted = List.sort (fun a b -> (fst a) - (fst b)) state.intervals in
  let rec run l lowest =
    match l with
    | (low, high)::t -> begin
        if low > lowest
        then lowest
        else run t (max lowest (high + 1))
      end
    | [] -> lowest + 1
  in
  { state with answer = run sorted 0 }

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> find_lowest state

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
  print_string @@ "Lowest-value IP that is not blacklisted: ";
  print_int @@ end_state.answer;
  print_endline ""
