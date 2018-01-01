OCAMLPKGS=str,core

all: run

p1: p1.ml
	ocamlbuild -pkgs $(OCAMLPKGS) p1.byte
	@printf "\n"
	./p1.byte < input.txt

p2: p2.ml
	ocamlbuild -pkgs $(OCAMLPKGS) p2.native
	@printf "\n"
	./p2.native < input.txt

run: p1 divider p2

divider:
	@printf "\n= = = = = = = = = =\n"

clean:
	ocamlbuild -clean
	rm -f p1.byte p2.native

.PHONY: all build run clean
