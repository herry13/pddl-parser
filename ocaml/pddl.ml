type term         = string
and  predicate    = Predicate of string
and  proposition  = predicate * term list
and  facts        = proposition list
and  _proposition = predicate * termVariable list
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
and	 _type        = Type of string
;;

let _proposition_to_buffer ?bracket:(br=true) _proposition buffer =
	match _proposition with
	| Predicate p, params ->
		if br then Buffer.add_char buffer '(';
		Buffer.add_string buffer p;
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
	| Predicate p, terms ->
		if br then Buffer.add_char buffer '(';
		Buffer.add_string buffer p;
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

let string_of_facts facts =
	let buffer = Buffer.create 42 in
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
	Buffer.add_char buffer ')';
	Buffer.contents buffer
;;

let formula_to_buffer formula buffer =
	Buffer.add_char buffer '(';
	(
		match formula with
		| True -> Buffer.add_string buffer "true"
		| False -> Buffer.add_string buffer "false"
		| Proposition p -> proposition_to_buffer ~bracket:false p buffer
		| P_Proposition p -> _proposition_to_buffer ~bracket:false p buffer
		| Imply (f1, f2) -> Buffer.add_string buffer "imply"
		| And fs -> Buffer.add_string buffer "and"
		| Or fs -> Buffer.add_string buffer "or"
		| Exists (v, t, f) -> Buffer.add_string buffer "exists"
		| Forall (v, t, f) -> Buffer.add_string buffer "forall"
	);
	Buffer.add_char buffer ')'
;;

let string_of_formula formula =
	let buffer = Buffer.create 42 in
	formula_to_buffer formula buffer;
	Buffer.contents buffer
;;

let p1 = (Predicate "parent", []) ;;
let p2 = (Predicate "parent", ["ramli"; "herry"]) ;;
let p3 = (Predicate "parent", [Variable "p"; Term "herry"]) ;;

let f1 = True ;;
let f2 = False ;;
let f3 = Proposition p1 ;;
let f4 = P_Proposition p3 ;;
let f5 = Imply (f1, f4) ;;
let f6 = And [f1; f2; f3; f4; f5] ;;
let f7 = Or  [f1; f2; f3; f4; f5; f6] ;;
let f8 = Exists ("p", Type "person", P_Proposition p3) ;;
let f9 = Forall ("p", Type "person", P_Proposition p3) ;;

let () =
	print_endline (string_of_proposition p1);
	print_endline (string_of_proposition p2);
	print_endline (string_of_facts [p1; p2]);
	print_endline (string_of_formula f1);
	print_endline (string_of_formula f2);
	print_endline (string_of_formula f3);
	print_endline (string_of_formula f4);
	print_endline (string_of_formula f5);
	print_endline (string_of_formula f6);
	print_endline (string_of_formula f7);
	print_endline (string_of_formula f8);
	print_endline (string_of_formula f9)
;;