DC=dmd

all: ctfe traits_compiles auto_string safe

ctfe: ctfe.d
	$(DC) $<

traits_compiles: traits_compiles.d
	$(DC) $<

auto_string: auto_string.d
	$(DC) $<

safe: safe.d
	$(DC) $<

clean:
	rm -f *.o
	find . -type f ! -name '*.*' ! -name 'Makefile' -exec rm -f {} +
