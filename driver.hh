#ifndef MQODRIVER_HH
#define MQODRIVER_HH

#include "parser.hh"

#define YY_DECL yy::mqo_parser::symbol_type yylex(mqo_driver& driver)
YY_DECL;

class mqo_driver
{
public:
    mqo_driver() {}
    virtual ~mqo_driver() {}
    int parse(const std::string& filename);
    int parse();
};

#endif
