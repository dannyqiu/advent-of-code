type state = { data: string;
               size: int;
             }
let starting_state = { data = "";
                       size = 35651584;
                     }

let handle_line state line =
  { state with data = line }

let reverse_string s =
  let len = String.length s in
  let get_reversed_char i = String.get s (len - i - 1) in
  String.init len get_reversed_char

let swap_1_0_string s =
  let len = String.length s in
  let swap_1_0 i = if String.get s i = '0' then '1' else '0' in
  String.init len swap_1_0

let rec fill_disk state =
  if String.length state.data > state.size
  then { state with data = String.sub state.data 0 state.size }
  else begin
    let a = state.data in
    let b = a |> reverse_string |> swap_1_0_string in
    let generated_data = a ^ "0" ^ b in
    fill_disk { state with data = generated_data }
  end

let rec get_checksum state =
  let len = String.length state.data in
  if len mod 2 = 1
  then state
  else begin
    let checksum_len = len / 2 in
    let compare_pair i =
      if String.get state.data (2 * i) = String.get state.data (2 * i + 1)
      then '1'
      else '0'
    in
    let checksum = String.init checksum_len compare_pair in
    get_checksum { state with data = checksum }
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> state |> fill_disk |> get_checksum

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
  print_string @@ "Correct checksum for disk of length "
                  ^ (string_of_int end_state.size) ^ ": ";
  print_string end_state.data;
  print_endline ""
