type state = { index: int;
               data: string;
             }
let starting_state = { index = 0;
                       data = "";
                     }
let (completed_condition_one : int list array) = Array.make 26 []

let keys_needed = 64

let handle_line state line =
  { state with data = line }

let rec md5_recursive s iter =
  if iter = 0
  then s
  else begin
    let hashed = s |> Digest.string |> Digest.to_hex in
    md5_recursive hashed (iter - 1)
  end

let md5_cache = Hashtbl.create 1
let md5 s =
  if Hashtbl.mem md5_cache s
  then Hashtbl.find md5_cache s
  else begin
    let hashed = md5_recursive s 2017 in
    Hashtbl.add md5_cache s hashed;
    hashed
  end

let three_in_a_row s =
  let rec check start =
    if start + 2 >= String.length s
    then None
    else begin
      if String.get s start = String.get s (start + 1)
        && String.get s start = String.get s (start + 2)
      then Some (String.get s start)
      else check (start + 1)
    end
  in
  check 0

let five_in_a_row s c =
  let rec check start =
    if start + 4 >= String.length s
    then false
    else begin
      if String.get s start = c
        && String.get s (start + 1) = c
        && String.get s (start + 2) = c
        && String.get s (start + 3) = c
        && String.get s (start + 4) = c
      then true
      else check (start + 1)
    end
  in
  check 0

let rec generate_keys state keys_found =
  if keys_found = keys_needed
  then { state with index = state.index - 1} (* found in previous iteration *)
  else begin
    let next_state = { state with index = state.index + 1} in
    let key = md5 @@ state.data ^ (string_of_int state.index) in
    match three_in_a_row key with
    | Some c -> begin
        let i = ref (state.index + 1) in
        let second_condition_check = ref false in
        while not (!second_condition_check) && !i <= (state.index + 1000) do
          let next_check = md5 @@ state.data ^ (string_of_int !i) in
          if five_in_a_row next_check c then second_condition_check := true;
          incr i
        done;
        if !second_condition_check
        then generate_keys next_state (keys_found + 1)
        else generate_keys next_state keys_found
      end
    | None -> generate_keys next_state keys_found
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> generate_keys state 0

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
  print_string @@ "Index that produces "
                  ^ (string_of_int keys_needed) ^ "th key: ";
  print_int end_state.index;
  print_endline ""
