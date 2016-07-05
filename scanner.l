%option 8bit batch noyywrap nounput noinput nodefault
%option outfile="scanner.cc"
%{
#include <string>
#include <cstdlib>

#include "driver.hh"
#include "parser.hh"

#undef yyterminate
#define yyterminate() return yy::mqo_parser::token::yytokentype::END
%}
INTEGER "0"|(-?[1-9][0-9]*)
FLOAT -?("0."|([1-9][0-9]*\.))[0-9]*
STRING \"[^\"]*\"
%%
"Metasequoia Document"|"Format Text Ver 1.0" {
    //Read skip the header string
}

"Eof" return yy::mqo_parser::make_TOKEN_EOF();
"Scene" return yy::mqo_parser::make_TOKEN_SCENE();
"BackImage" return yy::mqo_parser::make_TOKEN_BACKIMAGE();
"Material" return yy::mqo_parser::make_TOKEN_MATERIAL();
"Object" return yy::mqo_parser::make_TOKEN_OBJECT();
"pos" return yy::mqo_parser::make_TOKEN_POS();
"lookat" return yy::mqo_parser::make_TOKEN_LOOKAT();
"head" return yy::mqo_parser::make_TOKEN_HEAD();
"pich" return yy::mqo_parser::make_TOKEN_PITCH();
"bank" return yy::mqo_parser::make_TOKEN_BANK();
"ortho" return yy::mqo_parser::make_TOKEN_ORTHO();
"zoom2" return yy::mqo_parser::make_TOKEN_ZOOM2();
"zoom_pers" return yy::mqo_parser::make_TOKEN_ZOOM_PERS();
"amb" return yy::mqo_parser::make_TOKEN_AMB();
"dirlights" return yy::mqo_parser::make_TOKEN_DIRLIGHTS();
"light" return yy::mqo_parser::make_TOKEN_LIGHT();
"dir" return yy::mqo_parser::make_TOKEN_DIR();
"color" return yy::mqo_parser::make_TOKEN_COLOR();
"col" return yy::mqo_parser::make_TOKEN_COL();
"dif" return yy::mqo_parser::make_TOKEN_DIF();
"emi" return yy::mqo_parser::make_TOKEN_EMI();
"spc" return yy::mqo_parser::make_TOKEN_SPC();
"power" return yy::mqo_parser::make_TOKEN_POWER();
"visible" return yy::mqo_parser::make_TOKEN_VISIBLE();
"locking" return yy::mqo_parser::make_TOKEN_LOCKING();
"shading" return yy::mqo_parser::make_TOKEN_SHADING();
"facet" return yy::mqo_parser::make_TOKEN_FACET();
"color_type" return yy::mqo_parser::make_TOKEN_COLOR_TYPE();
"mirror" return yy::mqo_parser::make_TOKEN_MIRROR();
"mirror_axis" return yy::mqo_parser::make_TOKEN_MIRROR_AXIS();
"vertex" return yy::mqo_parser::make_TOKEN_VERTEX();
"face" return yy::mqo_parser::make_TOKEN_FACE();
"V" return yy::mqo_parser::make_TOKEN_V();
"M" return yy::mqo_parser::make_TOKEN_M();
"UV" return yy::mqo_parser::make_TOKEN_UV();
"pers" return yy::mqo_parser::make_TOKEN_PERS();

"(" return yy::mqo_parser::make_LEFTPAR();
")" return yy::mqo_parser::make_RIGHTPAR();
"{" return yy::mqo_parser::make_LEFTBR();
"}" return yy::mqo_parser::make_RIGHTBR();

{INTEGER} {
    return yy::mqo_parser::make_VAL_INT(std::atoi(yytext));
}
{FLOAT} {
    return yy::mqo_parser::make_VAL_FLOAT(std::atof(yytext));
}
{STRING} {
    return yy::mqo_parser::make_VAL_STRING(std::string(yytext, yyleng - 2));
}

[ \t\n] {}
%%
int mqo_driver::parse(const std::string& filename)
{
    yyin = fopen(filename.c_str(), "r");
    yy::mqo_parser parser(*this);
    int result = parser.parse();
    fclose(yyin);
    return result;
}
int mqo_driver::parse()
{
    yyin = stdin;
    yy::mqo_parser parser(*this);
    return parser.parse();
}
