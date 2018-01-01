type register = int ref
type value = int
type instruction = CPYR of register * register
                 | CPYV of value * register
                 | INC of register
                 | DEC of register
                 | JNZRR of register * register
                 | JNZRV of register * value
                 | JNZVR of value * register
                 | JNZVV of value * value
                 | TGLR of register
                 | TGLV of value
                 | TGL of instruction
type run_state = { registers: (int ref) array;
                   program: instruction array;
                 }
type setup_state = { setup_program: instruction list; }
let starting_state = { setup_program = []; }

let run_registers = [| ref 12; ref 0; ref 0; ref 0 |]
let is_reg r = (String.get r 0) >= 'a' && (String.get r 0) <= 'd'
let get_reg r = run_registers.(Char.code (String.get r 0) - Char.code 'a')

let parse_copy args =
  let space = String.index args ' ' in
  let from = String.sub args 0 space in
  let dest = String.sub args (space + 1) (String.length args - space - 1) in
  match from with
  | f when is_reg f -> CPYR(get_reg f, get_reg dest)
  | _ -> CPYV(from |> int_of_string, get_reg dest)

let parse_inc args = INC(get_reg args)

let parse_dec args = DEC(get_reg args)

let parse_jnz args =
  let space = String.index args ' ' in
  let check = String.sub args 0 space in
  let target = String.sub args (space + 1) (String.length args - space - 1) in
  match check, target with
  | c, t when is_reg c && is_reg t -> JNZRR(get_reg c, get_reg t)
  | c, t when is_reg c -> JNZRV(get_reg c, t |> int_of_string)
  | c, t when is_reg t -> JNZVR(c |> int_of_string, get_reg t)
  | c, t -> JNZVV(c |> int_of_string, t |> int_of_string)

let parse_tgl args =
  match args with
  | r when is_reg r -> TGLR(get_reg r)
  | _ -> TGLV(args |> int_of_string)

let parse_instruction instr args =
  match instr with
  | "cpy" -> parse_copy args
  | "inc" -> parse_inc args
  | "dec" -> parse_dec args
  | "jnz" -> parse_jnz args
  | "tgl" -> parse_tgl args
  | _ -> failwith @@ "Invalid instruction: " ^ instr

let handle_line state line =
  let space = String.index line ' ' in
  let instr = String.sub line 0 space in
  let tokens = String.sub line (space + 1) (String.length line - space - 1) in
  { setup_program = (parse_instruction instr tokens)::state.setup_program }

let handle_jnz check nextlineno nextlineno_ref =
  if check <> 0 then nextlineno_ref := nextlineno

let handle_tgl program lineno =
  if lineno >= Array.length program
  then ()
  else begin
    let instr = (
      match program.(lineno) with
      | TGL instr -> instr
      | instr -> TGL(instr)
    ) in
    program.(lineno) <- instr
  end

let rec program lineno run_state =
  if lineno >= Array.length run_state.program
  then run_state
  else begin
    let nextlineno = ref (lineno + 1) in
    let () = (
      match run_state.program.(lineno) with
      | CPYR (r1, r2)  -> r2 := !r1
      | CPYV (v, r)    -> r := v
      | INC r          -> incr r
      | DEC r          -> decr r
      | JNZRR (r1, r2) -> handle_jnz !r1 (lineno + !r2) nextlineno
      | JNZRV (r, v)   -> handle_jnz !r (lineno + v) nextlineno
      | JNZVR (v, r)   -> handle_jnz v (lineno + !r) nextlineno
      | JNZVV (v1, v2) -> handle_jnz v1 (lineno + v2) nextlineno
      | TGLR r         -> handle_tgl run_state.program (lineno + !r)
      | TGLV v         -> handle_tgl run_state.program (lineno + v)
      | TGL instr -> begin
          match instr with
          | CPYR (r1, r2)  -> handle_jnz !r1 (lineno + !r2) nextlineno
          | CPYV (v, r)    -> handle_jnz v (lineno + !r) nextlineno
          | INC r          -> decr r
          | DEC r          -> incr r
          | JNZRR (r1, r2) -> r2 := !r1
          | JNZRV (r, v)   -> ()
          | JNZVR (v, r)   -> r := v
          | JNZVV (v1, v2) -> ()
          | TGLR r         -> incr r
          | TGLV v         -> ()
          | _ -> failwith "TGL cannot be encapsulated by itself!"
        end
    ) in
    program !nextlineno run_state
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> begin
      let run_state = {
        registers = run_registers;
        program = state.setup_program |> List.rev |> Array.of_list;
      } in
      program 0 run_state
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
  print_string "Value in register a (to send to the safe): ";
  print_int @@ !(end_state.registers.(0));
  print_endline ""
