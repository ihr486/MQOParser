CXXSRCS := scanner.cc parser.cc
CXXOBJS := $(CXXSRCS:%.cc=%.o)
OBJS := $(CXXOBJS)

CXX := g++
CXXFLAGS := -Wall -Wextra -std=c++11 -O2
LDFLAGS :=
FLEX := flex
BISON := bison

BIN := parser

.PHONY: all check clean

all: $(BIN)

check: $(CXXSRCS)
	$(CXX) -fsyntax-only $(CXXFLAGS) $^

clean:
	-@rm -vf scanner.cc parser.cc parser.hh stack.hh $(BIN) $(OBJS)

$(BIN): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

scanner.o: parser.hh

parser.hh: parser.cc

scanner.cc: scanner.l
	$(FLEX) $<

parser.cc: parser.yy
	$(BISON) $<
