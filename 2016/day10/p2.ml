type target = Undefined | Bot of int | Output of int
type state = { bots: (int, ((int option * target) * (int option * target))) Hashtbl.t;
               outputs: (int, int list) Hashtbl.t;
               mutable bots_to_analyze: int list;
               mutable answer_bot: int;
             }
let starting_state = { bots = Hashtbl.create 1;
                       outputs = Hashtbl.create 1;
                       bots_to_analyze = [];
                       answer_bot = -1;
                     }

let value_regex = Str.regexp "value \\([0-9]+\\) goes to bot \\([0-9]+\\)"
let bot_regex = Str.regexp "bot \\([0-9]+\\) gives low to \\(bot\\|output\\) \\([0-9]+\\) and high to \\(bot\\|output\\) \\([0-9]+\\)"

let add_value_to_bot state value bot =
  try
    let values_held = Hashtbl.find state.bots bot in
    let new_values_held = (
      match values_held with
      | ((None, t1), (None, t2)) -> ((Some value, t1), (None, t2))
      | ((None, t1), (Some v2, t2)) -> begin
          state.bots_to_analyze <- bot::state.bots_to_analyze;
          if value < v2 then
            ((Some value, t1), (Some v2, t2))
          else
            ((Some v2, t1), (Some value, t2))
        end
      | ((Some v1, t1), (None, t2)) -> begin
          state.bots_to_analyze <- bot::state.bots_to_analyze;
          if v1 < value then
            ((Some v1, t1), (Some value, t2))
          else
            ((Some value, t1), (Some v1, t2))
        end
      | _ -> failwith "Bot cannot start with more than 2 chips"
    ) in
    Hashtbl.remove state.bots bot;
    Hashtbl.add state.bots bot new_values_held
  with
  | Not_found -> begin
      Hashtbl.add state.bots bot ((Some value, Undefined), (None, Undefined))
    end

let add_targets_to_bot state lowt hight bot =
  try
    let targets_held = Hashtbl.find state.bots bot in
    let new_targets_held = (
      match targets_held with
      | ((v1, _), (v2, _)) -> ((v1, lowt), (v2, hight))
    ) in
    Hashtbl.remove state.bots bot;
    Hashtbl.add state.bots bot new_targets_held
  with
  | Not_found -> begin
      Hashtbl.add state.bots bot ((None, lowt), (None, hight))
    end

let handle_line state line =
  if Str.string_match value_regex line 0 then begin
    let value = Str.matched_group 1 line |> int_of_string in
    let bot = Str.matched_group 2 line |> int_of_string in
    add_value_to_bot state value bot;
  end
  else if Str.string_match bot_regex line 0 then begin
    let bot = Str.matched_group 1 line |> int_of_string in
    let lowt = (
      match Str.matched_group 2 line with
      | "bot" -> Bot (Str.matched_group 3 line |> int_of_string)
      | "output" -> Output (Str.matched_group 3 line |> int_of_string)
      | _ -> failwith "Unknown target for low"
    ) in
    let hight = (
      match Str.matched_group 4 line with
      | "bot" -> Bot (Str.matched_group 5 line |> int_of_string)
      | "output" -> Output (Str.matched_group 5 line |> int_of_string)
      | _ -> failwith "Unknown target for high"
    ) in
    add_targets_to_bot state lowt hight bot
  end;
  state

let rec give_value_to_target state v t =
  match t with
  | Output o -> begin
      let old_output_values = (
        try
          Hashtbl.find state.outputs o
        with
        | Not_found -> []
      ) in
      Hashtbl.remove state.outputs o;
      Hashtbl.add state.outputs o (v::old_output_values)
    end
  | Bot b -> begin
      let values_held = Hashtbl.find state.bots b in
      match values_held with
      | ((Some v1, t1), (Some v2, t2)) -> begin
          state.bots_to_analyze <-
            List.filter (fun x -> x = b) state.bots_to_analyze;
          Hashtbl.remove state.bots b;
          Hashtbl.add state.bots b ((None, t1), (None, t2));
          give_value_to_target state v1 t1;
          give_value_to_target state v2 t2
        end
      | _ -> add_value_to_bot state v b
    end
  | Undefined -> failwith "Undefined target"

let rec run_simulation state =
  match state.bots_to_analyze with
  | bot::t -> begin
      let values_held = Hashtbl.find state.bots bot in
      match values_held with
      | ((Some v1, t1), (Some v2, t2)) -> begin
          state.bots_to_analyze <- t;
          give_value_to_target state v1 t1;
          give_value_to_target state v2 t2;
          run_simulation state
        end;
      | _ -> failwith "Inconsistent state for bots to analyze"
    end
  | [] -> state

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> run_simulation state

let rec get_all_input buffer =
  try
    let line = input_line stdin in
    if String.length line = 0
    then buffer
    else get_all_input (line::buffer)
  with
  | End_of_file -> List.rev buffer

let analyze_output state =
  try
    let o0 = Hashtbl.find state.outputs 0 in
    let o1 = Hashtbl.find state.outputs 1 in
    let o2 = Hashtbl.find state.outputs 2 in
    (List.hd o0) * (List.hd o1) * (List.hd o2)
  with
  | Not_found -> failwith "Inconsistent output state"

let _ =
  let end_state = get_all_input [] |> handle_input starting_state in
  print_string "Multiplying the values of the chips in outputs 0, 1, 2: ";
  print_int @@ analyze_output end_state;
  print_endline ""
