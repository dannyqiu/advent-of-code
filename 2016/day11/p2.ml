let item_counter = ref 1
let item_table = Hashtbl.create 1
type state = { first: (int * int);
               second: (int * int);
               third: (int * int);
               fourth: (int * int);
               cur_floor: int;
               elevator: (int * int);
             }
let starting_state = { first = (0, 0);
                       second = (0, 0);
                       third = (0, 0);
                       fourth = (0, 0);
                       cur_floor = 1;
                       elevator = (0, 0);
                     }
let visited : (state, int) Hashtbl.t = Hashtbl.create 1
let frontier : (int * state) Queue.t = Queue.create ()
type results_state = { steps: int }

let floor_regex = Str.regexp "The \\([a-z]+\\) floor contains"
let item_regex = Str.regexp "an? \\([a-z]+\\)\\( generator\\|-compatible microchip\\)"

let get_item_id name =
  if Hashtbl.mem item_table name
  then Hashtbl.find item_table name
  else begin
    let item_id = !item_counter in
    item_counter := !item_counter lsl 1;
    Hashtbl.add item_table name item_id;
    item_id
  end

let rec parse_items l start (gen_rep, chip_rep) =
  try
    let _ = Str.search_forward item_regex l start in
    let item_id = Str.matched_group 1 l |> get_item_id in
    let item_rep = (
      match Str.matched_group 2 l with
      | " generator" -> (gen_rep lor item_id, chip_rep)
      | "-compatible microchip" -> (gen_rep, chip_rep lor item_id)
      | i -> failwith @@ "Invalid item type: " ^ i
    ) in
    parse_items l (Str.match_end ()) item_rep
  with
  | Not_found -> (gen_rep, chip_rep)

let handle_line state line =
  if Str.string_match floor_regex line 0 then
    let floor = Str.matched_group 1 line in
    let item_rep = parse_items line (Str.match_end ()) (0, 0) in
    match floor with
    | "first"  -> { state with first = item_rep }
    | "second" -> { state with second = item_rep }
    | "third"  -> { state with third = item_rep }
    | "fourth" -> { state with fourth = item_rep }
    | f -> failwith @@ "Invalid floor: " ^ f
  else failwith @@ "Invalid description: " ^ line

let is_valid_floor (gen_rep, chip_rep) =
  gen_rep = 0 || gen_rep land chip_rep = chip_rep

let is_valid_state state =
  let (elev_gen_rep, elev_chip_rep) = state.elevator in
  let (floor_gen_rep, floor_chip_rep) = (
    match state.cur_floor with
    | 1 -> state.first
    | 2 -> state.second
    | 3 -> state.third
    | 4 -> state.fourth
    | x -> failwith @@ "Invalid current floor: " ^ (string_of_int x)
  ) in
  let gen_rep = elev_gen_rep lor floor_gen_rep in
  let chip_rep = elev_chip_rep lor floor_chip_rep in
  is_valid_floor (gen_rep, chip_rep)

let is_finish_state state =
  state.cur_floor = 4
  && state.third = (0, 0)
  && state.second = (0, 0)
  && state.first = (0, 0)
  && is_valid_state state

let push_state state cur_step =
  if is_valid_state state && not (Hashtbl.mem visited state) then begin
    Queue.push (cur_step, state) frontier;
    Hashtbl.add visited state cur_step
  end

let run_combinations state (floor_gen_rep, floor_chip_rep)
    (func : (int * int) -> (int * int) -> unit) =
  let (elev_gen_rep, elev_chip_rep) = state.elevator in
  let gen_rep = elev_gen_rep lor floor_gen_rep in
  let chip_rep = elev_chip_rep lor floor_chip_rep in
  (* get one/two chips in elevator *)
  let chip_acc_1 = ref 1 in
  while !chip_acc_1 <= chip_rep do
    if !chip_acc_1 land chip_rep <> 0 then begin
      let without_chip_1 = chip_rep lxor !chip_acc_1 in
      func (0, !chip_acc_1) (gen_rep, without_chip_1);
      let chip_acc_2 = ref (!chip_acc_1 lsl 1) in
      while !chip_acc_2 <= chip_rep do
        if !chip_acc_2 land chip_rep <> 0 then begin
          let without_chip_1_2 = without_chip_1 lxor !chip_acc_2 in
          func (0, (!chip_acc_1 lor !chip_acc_2)) (gen_rep, without_chip_1_2)
        end;
        chip_acc_2 := !chip_acc_2 lsl 1
      done;
    end;
    chip_acc_1 := !chip_acc_1 lsl 1
  done;
  (* get one/two generator(s) or one of each in elevator *)
  let gen_acc_1 = ref 1 in
  while !gen_acc_1 <= gen_rep do
    if !gen_acc_1 land gen_rep <> 0 then begin
      let without_gen_1 = gen_rep lxor !gen_acc_1 in
      func (!gen_acc_1, 0) (without_gen_1, chip_rep);
      let gen_acc_2 = ref (!gen_acc_1 lsl 1) in
      while !gen_acc_2 <= gen_rep do
        if !gen_acc_2 land gen_rep <> 0 then begin
          let without_gen_1_2 = without_gen_1 lxor !gen_acc_2 in
          func ((!gen_acc_1 lor !gen_acc_2), 0) (without_gen_1_2, chip_rep)
        end;
        gen_acc_2 := !gen_acc_2 lsl 1
      done;
      let chip_acc_1 = ref 1 in
      while !chip_acc_1 <= chip_rep do
        if !chip_acc_1 land chip_rep <> 0 then begin
          let without_chip_1 = chip_rep lxor !chip_acc_1 in
          func (!gen_acc_1, !chip_acc_1) (without_gen_1, without_chip_1)
        end;
        chip_acc_1 := !chip_acc_1 lsl 1
      done
    end;
    gen_acc_1 := !gen_acc_1 lsl 1
  done

let run_floor_one state cur_step =
  let next_step = cur_step + 1 in
  run_combinations state state.first
    (fun elevator_items floor_items ->
       if is_valid_floor floor_items then begin
         let temp_state = { state with elevator = elevator_items;
                                       first = floor_items } in
         push_state { temp_state with cur_floor = 2 } next_step
       end
    )

let run_floor_two state cur_step =
  let next_step = cur_step + 1 in
  run_combinations state state.second
    (fun elevator_items floor_items ->
       if is_valid_floor floor_items then begin
         let temp_state = { state with elevator = elevator_items;
                                       second = floor_items } in
         push_state { temp_state with cur_floor = 1 } next_step;
         push_state { temp_state with cur_floor = 3 } next_step
       end
    )

let run_floor_three state cur_step =
  let next_step = cur_step + 1 in
  run_combinations state state.third
    (fun elevator_items floor_items ->
       if is_valid_floor floor_items then begin
         let temp_state = { state with elevator = elevator_items;
                                       third = floor_items } in
         push_state { temp_state with cur_floor = 2 } next_step;
         push_state { temp_state with cur_floor = 4 } next_step
       end
    )

let run_floor_four state cur_step =
  let next_step = cur_step + 1 in
  run_combinations state state.fourth
    (fun elevator_items floor_items ->
       if is_valid_floor floor_items then begin
         let temp_state = { state with elevator = elevator_items;
                                       fourth = floor_items } in
         push_state { temp_state with cur_floor = 3 } next_step
       end
    )

let rec run_simulation () =
  if Queue.is_empty frontier then failwith "No valid solution"
  else begin
    let (cur_step, state) = Queue.pop frontier in
    if is_finish_state state then { steps = cur_step }
    else begin
      let () =
        match state.cur_floor with
        | 1 -> run_floor_one state cur_step
        | 2 -> run_floor_two state cur_step
        | 3 -> run_floor_three state cur_step
        | 4 -> run_floor_four state cur_step
        | x -> failwith @@ "Invalid current floor: " ^ (string_of_int x)
      in
      run_simulation ()
    end
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> begin
      push_state state 0;
      run_simulation ()
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
  print_string "Minimum number of steps to bring objects to fourth floor: ";
  print_int end_state.steps;
  print_endline ""
