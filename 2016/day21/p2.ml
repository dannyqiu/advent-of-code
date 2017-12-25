type op =
  | SWAP_POSITION of (int * int)
  | SWAP_LETTER of (char * char)
  | ROTATE_LEFT of (int)
  | ROTATE_RIGHT of (int)
  | ROTATE_POSITION of (char)
  | REVERSE_POSITIONS of (int * int)
  | MOVE of (int * int)
type state = { operations: op list;
               password: string;
             }
let starting_state = { operations = [ ];
                       password = "fbgdceah";
                     }

let swap_position_regex = "swap position \\([0-9]+\\) with position \\([0-9]+\\)" |> Str.regexp
let swap_letter_regex = "swap letter \\([a-z]\\) with letter \\([a-z]\\)" |> Str.regexp
let rotate_left_regex = "rotate left \\([0-9]+\\) steps?" |> Str.regexp
let rotate_right_regex = "rotate right \\([0-9]+\\) steps?" |> Str.regexp
let rotate_position_regex = "rotate based on position of letter \\([a-z]\\)" |> Str.regexp
let reverse_positions_regex = "reverse positions \\([0-9]+\\) through \\([0-9]+\\)" |> Str.regexp
let move_regex = "move position \\([0-9]+\\) to position \\([0-9]+\\)" |> Str.regexp

(* builds the inverse mapping for amount to rotate back, based on the index *)
let password_len = String.length starting_state.password
let rotate_position_mapping:((int, int) Hashtbl.t) = Hashtbl.create password_len
let () = for i = 0 to (password_len - 1) do
    let rot = i + 1 + (if i >= 4 then 1 else 0) in
    let new_pos = (i + rot) mod password_len in
    Hashtbl.add rotate_position_mapping new_pos rot
  done

let handle_line state line =
  let op = match line with
    | s when Str.string_match swap_position_regex s 0 -> begin
        let x = Str.matched_group 1 s |> int_of_string in
        let y = Str.matched_group 2 s |> int_of_string in
        SWAP_POSITION (x, y)
      end
    | s when Str.string_match swap_letter_regex s 0 -> begin
        let x = String.get (Str.matched_group 1 s) 0 in
        let y = String.get (Str.matched_group 2 s) 0 in
        SWAP_LETTER (x, y)
      end
    | s when Str.string_match rotate_left_regex s 0 -> begin
        let x = Str.matched_group 1 s |> int_of_string in
        ROTATE_LEFT (x)
      end
    | s when Str.string_match rotate_right_regex s 0 -> begin
        let x = Str.matched_group 1 s |> int_of_string in
        ROTATE_RIGHT (x)
      end
    | s when Str.string_match rotate_position_regex s 0 -> begin
        let x = String.get (Str.matched_group 1 s) 0 in
        ROTATE_POSITION (x)
      end
    | s when Str.string_match reverse_positions_regex s 0 -> begin
        let x = Str.matched_group 1 s |> int_of_string in
        let y = Str.matched_group 2 s |> int_of_string in
        REVERSE_POSITIONS (x, y)
      end
    | s when Str.string_match move_regex s 0 -> begin
        let x = Str.matched_group 1 s |> int_of_string in
        let y = Str.matched_group 2 s |> int_of_string in
        MOVE (x, y)
      end
    | _ -> failwith @@ "Unknown operation: " ^ line
  in
  { state with operations = op::state.operations }

let rotate password delta =
  let len = String.length password in
  let r i _ =
    String.get password ((i - delta + len * 10) mod len)
  in
  String.mapi r password

let apply_op op password =
  match op with
  | SWAP_POSITION (xm, ym) -> begin
      let x = min xm ym in
      let y = max xm ym in
      let first = Str.string_before password x in
      let sx = String.sub password x 1 in
      let mid = if y - x - 1 > 0 then String.sub password (x + 1) (y - x - 1) else "" in
      let sy = String.sub password y 1 in
      let last = Str.string_after password (y + 1) in
      first ^ sy ^ mid ^ sx ^ last
    end
  | SWAP_LETTER (x, y) -> begin
      let swap c =
        if c = x then y
        else if c = y then x
        else c
      in
      String.map swap password
    end
  | ROTATE_LEFT (x) -> rotate password x
  | ROTATE_RIGHT (x) -> rotate password (-x)
  | ROTATE_POSITION (x) -> begin
      let i = String.index password x in
      let rot = Hashtbl.find rotate_position_mapping i in
      rotate password (-rot)
    end
  | REVERSE_POSITIONS (x, y) -> begin
      let reverse i c =
        if x <= i && i <= y
        then String.get password (y - (i - x))
        else c
      in
      String.mapi reverse password
    end
  | MOVE (x, y) -> begin
      let first_temp = Str.string_before password y in
      let sy = String.sub password y 1 in
      let last_temp = Str.string_after password (y + 1) in
      let temp = first_temp ^ last_temp in
      let first = Str.string_before temp x in
      let last = Str.string_after temp x in
      first ^ sy ^ last
    end

let rec unscramble_password state =
  match state.operations with
  | op::t -> unscramble_password { operations = t;
                                   password = apply_op op state.password }
  | [] -> state

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> unscramble_password { state with operations = state.operations }

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
  print_string "The unscrambled password is: ";
  print_string @@ end_state.password;
  print_endline ""
