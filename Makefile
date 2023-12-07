.PHONY: test

build:
	dune build
test:
	OCAMLRUNPARAM=b dune exec test/main.exe 
doc:
	dune build @doc
run:
	OCAMLRUNPARAM=b dune exec bin/main.exe
opendoc: doc
	@bash opendoc.sh
loc:
	cloc --by-file --include-lang=OCaml .