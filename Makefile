# just a dummy makefile to call shake

all :
	cabal v2-build && cabal run build -- # --lint --progress

clean :
	cabal v2-build && cabal run build -- clean
