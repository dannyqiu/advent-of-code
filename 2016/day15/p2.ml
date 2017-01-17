type disc = { disc_no: int;
              start: int;
              positions: int;
            }
type state = { discs: disc list;
               time: int;
             }
let starting_state = { discs = [];
                       time = 0;
                     }

let disc_regex = Str.regexp
    "Disc #\\([0-9]+\\) has \\([0-9]+\\) positions; at time=0, it is at position \\([0-9]+\\)."

let handle_line state line =
  if Str.string_match disc_regex line 0
  then begin
    let disc = {
      disc_no = Str.matched_group 1 line |> int_of_string;
      positions = Str.matched_group 2 line |> int_of_string;
      start = Str.matched_group 3 line |> int_of_string;
    } in
    { state with discs = disc::state.discs }
  end
  else failwith @@ "Invalid disc: " ^ line

(* from http://rosettacode.org/wiki/Least_common_multiple#OCaml *)
let rec gcd u v =
  if v <> 0 then (gcd v (u mod v))
  else (abs u)

let lcm m n =
  match m, n with
  | 0, _ | _, 0 -> 0
  | m, n -> abs (m * n) / (gcd m n)

let normalize_discs discs =
  let norm disc =
    { disc with start = (disc.start + disc.disc_no) mod disc.positions }
  in
  List.map norm discs

let get_first_time state =
  let state = { state with discs = normalize_discs state.discs } in
  let rec solve discs mult t =
    match discs with
    | x::xs -> begin
        let i = ref 0 in
        while ((t + !i * mult + x.start) mod x.positions <> 0) do
          incr i
        done;
        solve xs (lcm mult x.positions) (t + !i * mult)
      end
    | [] -> t
  in
  let t = solve state.discs 1 0 in
  { state with time = t }

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> get_first_time state

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
  print_string "First time to press the button: ";
  print_int end_state.time;
  print_endline ""
