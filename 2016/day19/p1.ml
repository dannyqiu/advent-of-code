type state = { elves: int list;
               num_elves: int;
             }
let starting_state = { elves = [];
                       num_elves = 0;
                     }

let rec generate_elves num =
  let rec gen n acc =
    if n = 0 then acc else gen (n - 1) (n::acc)
  in
  gen num []

let handle_line state line =
  let num = int_of_string line in
  { elves = generate_elves num;
    num_elves = num;
  }

let rec run_party state =
  if state.num_elves = 1 then state
  else begin
    let rec run l acc =
      match l with
      | []       -> (0, List.rev acc)
      | [last]   -> (1, last::(List.rev acc))
      | e1::_::t -> run t (e1::acc)
    in
    let (extra, elves_left) = run state.elves [] in
    let num_elves_left = (state.num_elves / 2) + extra in
    run_party { elves = elves_left;
                num_elves = num_elves_left }
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> run_party state

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
  print_string @@ "Elf that gets all the presents: ";
  print_int @@ List.hd end_state.elves;
  print_endline ""
