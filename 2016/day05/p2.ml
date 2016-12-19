type state = { password: string
             }
let starting_state = { password = "";
                     }

let zero_regex = Str.regexp "00000"

let handle_line state line =
  let pass = [| ""; ""; ""; ""; ""; ""; ""; "" |] in
  let index = ref 0 in
  let char_found = ref 0 in
  while !char_found < 8 do
    let to_hash = line ^ (string_of_int !index) in
    let md5 = to_hash |> Digest.string |> Digest.to_hex in
    if Str.string_match zero_regex md5 0
    then begin
      let pos = Char.code (String.get md5 5) - Char.code '0' in
      if pos >= 0 && pos <= 7 && pass.(pos) = ""
      then begin
        pass.(pos) <- (String.sub md5 6 1);
        incr char_found
      end
      else ()
    end
    else ();
    incr index
  done;
  { state with password = Array.fold_right (^) pass "" }

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> state

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
  print_string "Password: ";
  print_string end_state.password;
  print_endline ""
