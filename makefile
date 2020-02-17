
SHELL:=/bin/bash

RAW = ../raw/

SRC = src/
LIB = lib/
EXE = eatraw

CCC = g++ -std=c++11
OPT = -O3 -Wall -mavx -mno-tbm -mf16c -mno-f16c

# build executable 
$(EXE) : $(SRC)main.cpp $(LIB)raweat.hpp
	$(CCC) $(OPT) $< -o $@

# build target for conversion set of .raw files
eatall : $(SRC)eatall.cpp $(LIB)raweat.hpp
	$(CCC) $(OPT) $< -o $@

# remove executable
clean :
	rm -f $(EXE)

# check existence of name of executable globally
chexe:=$(shell command -v $(EXE))

# install executable if name does not exist yet
install : $(EXE)
ifeq ($(chexe),)
	cp $(EXE) /usr/local/bin/
else
	@echo "executable with same name already exists! choose different name!"
	@exit 1
endif

# uninstall
uninstall :
	rm /usr/local/bin/$(EXE)

# build python module
build : setup.py raw_eater.pyx raw_eater.pxd $(SRC)raweat.hpp
	python3 setup.py build_ext --inplace

install_py : setup.py raw_eater.pyx raw_eater.pxd $(SRC)raweat.hpp
	python3 setup.py install

clean_py :
	rm -f raw_eater.cpython-36m-x86_64-linux-gnu.so
	rm -f raw_eater.cpp

