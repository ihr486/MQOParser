CSRCS := lex.yy.c parse.tab.c
COBJS := $(CSRCS:%.c=%.o)
OBJS := $(COBJS)

CC := gcc
CFLAGS := -Wall -Wextra -std=c99 -O2 -DYYERROR_VERBOSE
LDFLAGS :=
FLEX := flex
BISON := bison

BIN := parser

.PHONY: all check clean

all: $(BIN)

check: $(CSRCS)
	$(CC) -fsyntax-only $(CFLAGS) $^

clean:
	-@rm -vf lex.yy.c parse.tab.c parse.tab.h $(BIN) $(OBJS)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

lex.yy.c: parse.l parse.tab.h
	$(FLEX) $<

parse.tab.c: parse.y
	$(BISON) -d $<

parse.tab.h: parse.tab.c
