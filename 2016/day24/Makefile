OCAMLPKGS=str,core

all: run

p1: p1.ml
	ocamlbuild -pkgs $(OCAMLPKGS) p1.byte
	@printf "\n"
	./p1.byte < input.txt

p2: p2.ml
	ocamlbuild -pkgs $(OCAMLPKGS) p2.byte
	@printf "\n"
	./p2.byte < input.txt

run: p1 divider p2

divider:
	@printf "\n= = = = = = = = = =\n"

clean:
	ocamlbuild -clean
	rm -f p1.byte p2.byte

.PHONY: all build run clean
