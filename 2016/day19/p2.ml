open Core_kernel

(* Left side is a stack, right side is queue *)

type state = { left_elves: int Dequeue.t;
               right_elves: int Dequeue.t;
               num_elves: int;
             }
let starting_state = { left_elves = Dequeue.create ();
                       right_elves = Dequeue.create ();
                       num_elves = 0;
                     }

let rec print_list = function
  | [] -> print_endline ""
  | e::l -> print_int e ; print_string " " ; print_list l

let rec generate_elves num start (f:(int -> unit)) =
  f start;
  if num = start
  then ()
  else generate_elves num (start + 1) f

let handle_line state line =
  let num = int_of_string line in
  generate_elves ((num + 1) / 2) 1 (fun n -> Dequeue.enqueue_front state.left_elves n);
  generate_elves num ((num + 1) / 2 + 1) (fun n -> Dequeue.enqueue_front state.right_elves n);
  { state with num_elves = num }

let rec run_party state =
  if state.num_elves = 1 then state
  else begin
    let () = if Dequeue.length state.left_elves > Dequeue.length state.right_elves
      then Dequeue.drop_front state.left_elves
      else Dequeue.drop_back state.right_elves in
    if state.num_elves = 2 then state
    else begin
      let current_elf = Dequeue.dequeue_back_exn state.left_elves in
      let opposite_elf = Dequeue.dequeue_back_exn state.right_elves in
      (* rotation *)
      Dequeue.enqueue_front state.right_elves current_elf;
      Dequeue.enqueue_front state.left_elves opposite_elf;
      run_party { state with num_elves = state.num_elves - 1 }
    end
  end

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> run_party state

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
  print_string @@ "Elf that gets all the presents: ";
  print_int @@ Dequeue.peek_front_exn end_state.left_elves;
  print_endline ""
