let is_valid_triangle sides =
  let side_lengths = List.rev_map int_of_string sides in
  let sorted_lengths = List.sort Pervasives.compare side_lengths in
  match sorted_lengths with
  | [a; b; c] -> if a + b > c then 1 else 0
  | _ -> 0

let handle_lines3 line1 line2 line3 =
  match line1 with
  | [a1; b1; c1] -> begin
      match line2 with
      | [a2; b2; c2] -> begin
          match line3 with
          | [a3; b3; c3] -> begin
              is_valid_triangle [a1; a2; a3]
              + is_valid_triangle [b1; b2; b3]
              + is_valid_triangle [c1; c2; c3]
            end
          | _ -> 0
        end
      | _ -> 0
    end
  | _ -> 0


let rec handle_input num lines =
  match lines with
  | h1::h2::h3::t -> begin
      let sides1 = Str.(split (regexp " +") h1) in
      let sides2 = Str.(split (regexp " +") h2) in
      let sides3 = Str.(split (regexp " +") h3) in
      let valid_triangles = handle_lines3 sides1 sides2 sides3 in
      handle_input (num + valid_triangles) t
    end
  | _ -> num

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
