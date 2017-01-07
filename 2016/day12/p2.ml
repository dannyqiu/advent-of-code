type register = int
type value = int
type instruction = CPYR of register * register
                 | CPYV of value * register
                 | INC of register
                 | DEC of register
                 | JNZR of register * int
                 | JNZV of value * int
type run_state = { registers: int array;
                   run_program: instruction array;
                 }
type setup_state = { setup_program: instruction list; }
let starting_state = { setup_program = []; }

let parse_copy args =
  let space = String.index args ' ' in
  let dest = Char.code (String.get args (space + 1)) - Char.code 'a' in
  match String.get args 0 with
  | r when r >= 'a' && r <= 'd' -> let r = (Char.code r) - (Char.code 'a') in
                                   CPYR(r, dest)
  | _ -> CPYV(String.sub args 0 space |> int_of_string, dest)

let parse_inc args =
  let r = String.get args 0 in
  INC(Char.code r - Char.code 'a')

let parse_dec args =
  let r = String.get args 0 in
  DEC(Char.code r - Char.code 'a')

let parse_jnz args =
  let space = String.index args ' ' in
  let target = String.sub args (space + 1) (String.length args - space - 1) |>
               int_of_string in
  match String.get args 0 with
  | r when r >= 'a' && r <= 'd' -> let r = (Char.code r) - (Char.code 'a') in
                                   JNZR(r, target)
  | _ -> JNZV(String.sub args 0 space |> int_of_string, target)

let parse_instruction instr args =
  match instr with
  | "cpy" -> parse_copy args
  | "inc" -> parse_inc args
  | "dec" -> parse_dec args
  | "jnz" -> parse_jnz args
  | _ -> failwith @@ "Invalid instruction: " ^ instr

let handle_line state line =
  let space = String.index line ' ' in
  let instr = String.sub line 0 space in
  let tokens = String.sub line (space + 1) (String.length line - space - 1) in
  { setup_program = (parse_instruction instr tokens)::state.setup_program }

let rec run_program lineno run_state =
  if lineno >= Array.length run_state.run_program
  then run_state
  else begin
    let nextlineno = ref (lineno + 1) in
    let () = (
      match run_state.run_program.(lineno) with
      | CPYR (r1, r2) -> run_state.registers.(r2) <- run_state.registers.(r1)
      | CPYV (v, r)   -> run_state.registers.(r) <- v
      | INC r         -> run_state.registers.(r) <- run_state.registers.(r) + 1
      | DEC r         -> run_state.registers.(r) <- run_state.registers.(r) - 1
      | JNZR (r, t) -> begin
          if run_state.registers.(r) <> 0
          then nextlineno := lineno + t
          else ()
        end
      | JNZV (v, t) -> begin
          if v <> 0
          then nextlineno := lineno + t
          else ()
        end
    ) in
    run_program !nextlineno run_state
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> begin
      let run_state = {
        registers = [| 0; 0; 1; 0 |];
        run_program = state.setup_program |> List.rev |> Array.of_list;
      } in
      run_program 0 run_state
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
  print_string "Value in register a: ";
  print_int end_state.registers.(0);
  print_endline ""
