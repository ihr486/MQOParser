#include "parser.hh"

int main(int argc, const char *argv[])
{
    extern FILE *yyin;

    Model model;
    if(argc >= 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yy::MQOParser parser(model);

    return parser.parse();
}
