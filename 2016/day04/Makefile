OCAMLPKGS=str

all: build run

build: p1.ml p2.ml
	ocamlbuild -pkgs $(OCAMLPKGS) p1.byte
	ocamlbuild -pkgs $(OCAMLPKGS) p2.byte
	@echo ""

run: build
	./p1.byte < input.txt
	@printf "\n= = = = = = = = = =\n"
	./p2.byte < input.txt
	@printf "\n"

clean:
	ocamlbuild -clean

.PHONY: all build run clean
