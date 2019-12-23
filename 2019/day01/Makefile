CXXFLAGS=-std=c++11

all: run

p1.exe: p1.cpp
	$(CXX) $(CXXFLAGS) $^ -o $@

p1run: p1.exe
	./$< < input.txt

p2.exe: p2.cpp
	$(CXX) $(CXXFLAGS) $^ -o $@

p2run: p2.exe
	./$< < input.txt

run: p1run divider p2run

divider:
	@printf "\n= = = = = = = = = =\n"

clean:
	rm -f p1.exe p2.exe

.PHONY: all build run clean p1run p2run
