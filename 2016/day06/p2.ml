type state = { setup: bool;
               mutable frequencies: int array array;
               message: string;
             }
let starting_state = { setup = false;
                       frequencies = [||];
                       message = "";
                     }

let explode_letters = Str.split (Str.regexp "")

let setup_state state len =
  if state.setup = true
  then state
  else begin
    state.frequencies <- Array.make len [||];
    for i = 0 to (len - 1) do
      state.frequencies.(i) <- Array.make 26 0
    done;
    { state with setup = true }
  end

let handle_line state line =
  let state = setup_state state (String.length line) in
  let letters = explode_letters line in
  let accumulate_frequencies index l =
    let c = Char.code (String.get l 0) - Char.code 'a' in
    state.frequencies.(index).(c) <- state.frequencies.(index).(c) + 1
  in
  List.iteri accumulate_frequencies letters;
  state

let get_best_char index frequencies =
  let best_char = ref 0 in
  for i = 1 to 25 do
    if frequencies.(i) < frequencies.(!best_char)
    then best_char := i
    else ()
  done;
  Char.chr (!best_char + Char.code 'a') |> Char.escaped

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> begin
      let msg_array = Array.mapi get_best_char state.frequencies in
      let msg = Array.fold_right (^) msg_array "" in
      { state with message = msg }
    end

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
  print_string "Error-corrected message: ";
  print_string end_state.message;
  print_endline ""
