let is_valid_triangle sorted_lengths =
  match sorted_lengths with
  | [a; b; c] -> a + b > c
  | _ -> false

let handle_line line =
  if List.length line < 3
  then false
  else begin
    let side_lengths = List.rev_map int_of_string line in
    let sorted_lengths = List.sort Pervasives.compare side_lengths in
    is_valid_triangle sorted_lengths
  end

let rec handle_input num lines =
  match lines with
  | [] -> num
  | h::t -> begin
      let sides = Str.(split (regexp " +") h) in
      let valid = handle_line sides in
      handle_input (if valid then num + 1 else num) t
    end

let rec get_all_input buffer =
  try
    get_all_input ((input_line stdin)::buffer)
  with
  | End_of_file -> List.rev buffer

let _ =
  let result = get_all_input [] |> handle_input 0 in
  print_string "Number of valid triangles: ";
  print_int result;
  print_endline ""
