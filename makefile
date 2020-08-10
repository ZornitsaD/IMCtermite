#-----------------------------------------------------------------------------#

# choose shell
SHELL:=/bin/bash

RAW = ../raw/

# directory names
SRC = src/
LIB = lib/

# name of executable
EXE = eatraw

# compiler and its options
CCC = g++ -std=c++11
OPT = -O3 -Wall -mavx -mno-tbm -mf16c -mno-f16c

#-----------------------------------------------------------------------------#
# C++

# build executable
$(EXE) : $(SRC)main.cpp $(LIB)raweat.hpp $(LIB)hexshow.hpp $(LIB)rawmerge.hpp
	$(CCC) $(OPT) $< -o $@

# development version
eatdev : $(SRC)main_dev.cpp $(LIB)raweat.hpp
	$(CCC) $(OPT) $< -o $@

# build target for conversion set of .raw files
eatall : $(SRC)eatall.cpp $(LIB)raweat.hpp
	$(CCC) $(OPT) $< -o $@

# remove executable
clean :
	rm -f $(EXE)
	rm -f eatall
	rm -f eatdev

# check existence of name of executable globally
chexe:=$(shell command -v $(EXE))

# install executable if name does not exist yet
install : $(EXE)
ifeq ($(chexe),)
	cp $(EXE) /usr/local/bin/
else
	@echo "executable with name already exists! choose different name!"
	@exit 1
endif

# uninstall
uninstall :
	rm /usr/local/bin/$(EXE)

#-----------------------------------------------------------------------------#
# Python

# build python module
build : setup_raw_eater.py cyt/raw_eater.pyx cyt/raw_eater.pxd $(LIB)raweat.hpp \
        setup_raw_meat.py cyt/raw_meat.pyx cyt/raw_meat.pxd $(LIB)rawmerge.hpp
	python3 setup_raw_eater.py build_ext --inplace
	python3 setup_raw_meat.py build_ext --inplace
	cp raw_eater.cpython-*.so pyt/
	cp raw_meat.cpython-*.so pyt/

py_install: setup_raw_eater.py cyt/raw_eater.pyx cyt/raw_eater.pxd $(LIB)raweat.hpp \
            setup_raw_meat.py cyt/raw_meat.pyx cyt/raw_meat.pxd $(LIB)rawmerge.hpp
	python3 setup_raw_eater.py install --record files_raw_eater.txt
	python3 setup_raw_meat.py install --record files_raw_meat.txt

py_clean :
	rm -f raw_eater.cpython-*.so
	rm -f pyt/raw_eater.cpython-*.so
	rm -f cyt/raw_eater.cpp
	rm -f raw_meat.cpython-*.so
	rm -f pyt/raw_meat.cpython-*.so
	rm -f cyt/raw_meat.cpp
	rm -rf build/
	rm -f *.txt

#-----------------------------------------------------------------------------#
