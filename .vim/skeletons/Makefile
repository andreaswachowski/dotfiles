HOST=$(shell hostname)
ifeq ($(HOST),macbook.spices.hh)
	GCC=g++-4.9
else
	GCC=g++
endif

a.out: prg.cc
	$(GCC) -g -std=c++11 prg.cc

clean:
	rm -f a.out
