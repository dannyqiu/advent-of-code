CXXFLAGS=-std=c++17 -Wall -Wextra -Werror

all: run

p1.exe: p1.cpp utils.cpp
	$(CXX) $(CXXFLAGS) $^ -o $@

p1run: p1.exe
	./$< < input.txt

p1test: p1.exe
	./$< < test.txt

p2.exe: p2.cpp utils.cpp
	$(CXX) $(CXXFLAGS) $^ -o $@

p2run: p2.exe
	./$< < input.txt

p2test: p2.exe
	./$< < test.txt

run: p1run divider p2run

divider:
	@printf "\n= = = = = = = = = =\n"

clean:
	rm -f p1.exe p2.exe

.PHONY: all build run clean p1run p2run p1 p2
