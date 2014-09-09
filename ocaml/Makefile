.PHONY: build clean clean-all dist

LIB=str.cma

build: pddl

pddl: pddl.ml
	ocamlc -o pddl pddl.ml

clean:
	@rm -f *.{cmo,mli,cmi} pddlparser.ml pddllexer.ml

clean-all: clean
	@rm -f pddl

dist: build clean

clean-build: clean-all build

test: clean-all build
	@./pddl
