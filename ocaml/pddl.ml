type term         = string
and  proposition  = string * term list
and  state        = proposition list
and  _proposition = string * termVariable list
and  termVariable = Term of term
                  | Variable of string
and  formula      = True
                  | False
                  | Proposition of proposition
                  | P_Proposition of _proposition
                  | Imply of formula * formula
                  | And of formula list
                  | Or of formula list
                  | Exists of string * _type * formula
                  | Forall of string * _type * formula
and	 _type        = Type of string * _type
                  | NullType
and  context      = string * contextItem list
and  contextItem  = Context of context
                  | Formula of formula
				  | State of state
                  | Objects of _object list
                  | Types of _type list
                  | Predicates of predicate list
and  _object      = Object of string * _type
and  parameter    = Parameter of string * _type
and  predicate    = Predicate of string * parameter list
;;

let type_to_buffer _type buffer =
	match _type with
	| Type (t, _) -> (
			Buffer.add_string buffer " - ";
			Buffer.add_string buffer t
		)
	| NullType -> raise (Failure "NullType")
;;

let parameter_to_buffer parameter buffer =
	match parameter with
	| Parameter (name, t) -> (
			Buffer.add_char buffer '?';
			Buffer.add_string buffer name;
			type_to_buffer t buffer
		)
;;

let predicate_to_buffer predicate buffer =
	match predicate with
	| Predicate (name, parameters) -> (
			Buffer.add_char buffer '(';
			Buffer.add_string buffer name;
			List.iter (fun p ->
				Buffer.add_char buffer ' ';
				parameter_to_buffer p buffer
			) parameters;
			Buffer.add_char buffer ')'
		)
;;

let object_to_buffer _object buffer =
	match _object with
	| Object (name, t) -> (
			Buffer.add_string buffer name;
			type_to_buffer t buffer
		)
;;

let objects_to_buffer objects buffer =
	Buffer.add_char buffer '(';
	List.iter (fun obj ->
		Buffer.add_char buffer ' ';
		object_to_buffer obj buffer
	) objects;
	Buffer.add_char buffer ')'
;;

let string_of_objects objects =
	let buffer = Buffer.create 42 in
	objects_to_buffer objects buffer;
	Buffer.contents buffer
;;

let _proposition_to_buffer ?bracket:(br=true) _proposition buffer =
	match _proposition with
	| relation, params ->
		if br then Buffer.add_char buffer '(';
		Buffer.add_string buffer relation;
		List.iter (fun param ->
			Buffer.add_string buffer " ";
			match param with
			| Term t -> Buffer.add_string buffer t
			| Variable v -> (
					Buffer.add_char buffer '?';
					Buffer.add_string buffer v
				)
		) params;
		if br then Buffer.add_char buffer ')'
;;		

let proposition_to_buffer ?bracket:(br=true) proposition buffer =
	match proposition with
	| relation, terms ->
		if br then Buffer.add_char buffer '(';
		Buffer.add_string buffer relation;
		List.iter (fun t ->
			Buffer.add_string buffer " ";
			Buffer.add_string buffer t
		) terms;
		if br then Buffer.add_char buffer ')'
;;	

let string_of_proposition proposition =
	let buffer = Buffer.create 42 in
	proposition_to_buffer proposition buffer;
	Buffer.contents buffer
;;

let state_to_buffer facts buffer =
	Buffer.add_char buffer '(';
	let rec iter fs =
		match fs with
		| [] -> ()
		| p :: [] -> proposition_to_buffer p buffer
		| p :: ps -> (
				proposition_to_buffer p buffer;
				Buffer.add_char buffer ' ';
				iter ps
			)
	in
	iter facts;
	Buffer.add_char buffer ')'
;;
	
	
let string_of_state (facts : state) =
	let buffer = Buffer.create 42 in
	state_to_buffer facts buffer;
	Buffer.contents buffer
;;

let rec formula_to_buffer formula buffer =
	Buffer.add_char buffer '(';
	(
		match formula with
		| True -> Buffer.add_string buffer "true"
		| False -> Buffer.add_string buffer "false"
		| Proposition p -> proposition_to_buffer ~bracket:false p buffer
		| P_Proposition p -> _proposition_to_buffer ~bracket:false p buffer
		| Imply (f1, f2) -> (
				Buffer.add_string buffer "imply ";
				formula_to_buffer f1 buffer;
				Buffer.add_char buffer ' ';
				formula_to_buffer f2 buffer
			)
		| And fs -> (
				Buffer.add_string buffer "and";
				List.iter (fun f ->
					Buffer.add_char buffer ' ';
					formula_to_buffer f buffer
				) fs
			)
		| Or fs -> (
				Buffer.add_string buffer "or";
				List.iter (fun f ->
					Buffer.add_char buffer ' ';
					formula_to_buffer f buffer
				) fs
			)
		| Exists (v, t, f) -> (
				Buffer.add_string buffer "exists (?";
				Buffer.add_string buffer v;
				type_to_buffer t buffer;
				Buffer.add_string buffer ") ";
				formula_to_buffer f buffer
			)
		| Forall (v, t, f) -> (
				Buffer.add_string buffer "forall (?";
				Buffer.add_string buffer v;
				type_to_buffer t buffer;
				Buffer.add_string buffer ") ";
				formula_to_buffer f buffer
			)
	);
	Buffer.add_char buffer ')'
;;

let string_of_formula formula =
	let buffer = Buffer.create 42 in
	formula_to_buffer formula buffer;
	Buffer.contents buffer
;;

let rec context_to_buffer context buffer =
	let context_item item =
		match item with
		| Context ctx -> context_to_buffer ctx buffer
		| Formula f -> formula_to_buffer f buffer
		| State s -> state_to_buffer s buffer
		| Objects objects -> objects_to_buffer objects buffer
		| Types types -> (
				Buffer.add_string buffer "(:types";
				List.iter (fun t ->
					Buffer.add_char buffer ' ';
					type_to_buffer t buffer
				) types;
				Buffer.add_char buffer ')'
			)
		| Predicates predicates -> (
				Buffer.add_string buffer "(:predicates";
				List.iter (fun p ->
					Buffer.add_char buffer ' ';
					predicate_to_buffer p buffer
				) predicates;
				Buffer.add_char buffer ')'
			)
	in
	match context with
	| label, items -> (
			Buffer.add_string buffer "(:";
			Buffer.add_string buffer label;
			List.iter (fun item ->
				Buffer.add_char buffer ' ';
				context_item item
			) items;
			Buffer.add_char buffer ')'
		)
;;

let string_of_context context =
	let buffer = Buffer.create 42 in
	context_to_buffer context buffer;
	Buffer.contents buffer
;;

let p1 = ("parent", []) ;;
let p2 : proposition = ("parent", ["ramli"; "herry"]) ;;
let p3 = ("parent", [Variable "p"; Term "herry"]) ;;

let f1 = True ;;
let f2 = False ;;
let f3 = Proposition p1 ;;
let f4 = P_Proposition p3 ;;
let f5 = Imply (f1, f4) ;;
let f6 = And [f1; f2; f3; f4; f5] ;;
let f7 = Or  [f1; f2; f3; f4; f5; f6] ;;
let f8 = Exists ("p", Type ("person", NullType), P_Proposition p3) ;;
let f9 = Forall ("p", Type ("person", NullType), P_Proposition p3) ;;

let goalFormula1 = Formula f9 ;;
let goal1 = ("goal", [goalFormula1]) ;;
let state1 = State [p2] ;;
let init1 = ("init", [state1]) ;;
let pddl1 = ("pddl", [Context init1; Context goal1]) ;;

let () =
	print_endline (string_of_proposition p1);
	print_endline (string_of_proposition p2);
	print_endline (string_of_state [p1; p2]);
	print_endline (string_of_formula f1);
	print_endline (string_of_formula f2);
	print_endline (string_of_formula f3);
	print_endline (string_of_formula f4);
	print_endline (string_of_formula f5);
	print_endline (string_of_formula f6);
	print_endline (string_of_formula f7);
	print_endline (string_of_formula f8);
	print_endline (string_of_formula f9);
	
	print_endline (string_of_context goal1);
	print_endline (string_of_context pddl1)
;;
