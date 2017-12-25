OCAMLPKGS=str,core

all: run

p1: p1.ml
	ocamlbuild -pkgs $(OCAMLPKGS) $@.byte
	@printf "\n"
	./p1.byte < input.txt

p2: p2.ml
	ocamlbuild -pkgs $(OCAMLPKGS) $@.byte
	@printf "\n"
	./p2.byte < input.txt

run: p1 divider p2

divider:
	@printf "\n= = = = = = = = = =\n"

clean:
	ocamlbuild -clean

.PHONY: all build run clean
