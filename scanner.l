%option 8bit batch noyywrap nounput noinput
%option outfile="scanner.cc"
%{
#include <string>
#include <cstdlib>

#include "parser.hh"

#undef yyterminate
#define yyterminate() return yy::MQOParser::token::yytokentype::END
%}
INTEGER "0"|(-?[1-9][0-9]*)
FLOAT -?("0."|([1-9][0-9]*\.))[0-9]*
STRING \"[^\"]*\"
%%
"Metasequoia Document"|"Format Text Ver 1.0" {
    //Read skip the header string
}

"Eof" return yy::MQOParser::make_TOKEN_EOF();
"Scene" return yy::MQOParser::make_TOKEN_SCENE();
"BackImage" return yy::MQOParser::make_TOKEN_BACKIMAGE();
"Material" return yy::MQOParser::make_TOKEN_MATERIAL();
"Object" return yy::MQOParser::make_TOKEN_OBJECT();
"pos" return yy::MQOParser::make_TOKEN_POS();
"lookat" return yy::MQOParser::make_TOKEN_LOOKAT();
"head" return yy::MQOParser::make_TOKEN_HEAD();
"pich" return yy::MQOParser::make_TOKEN_PITCH();
"bank" return yy::MQOParser::make_TOKEN_BANK();
"ortho" return yy::MQOParser::make_TOKEN_ORTHO();
"zoom2" return yy::MQOParser::make_TOKEN_ZOOM2();
"zoom_pers" return yy::MQOParser::make_TOKEN_ZOOM_PERS();
"amb" return yy::MQOParser::make_TOKEN_AMB();
"dirlights" return yy::MQOParser::make_TOKEN_DIRLIGHTS();
"light" return yy::MQOParser::make_TOKEN_LIGHT();
"dir" return yy::MQOParser::make_TOKEN_DIR();
"color" return yy::MQOParser::make_TOKEN_COLOR();
"col" return yy::MQOParser::make_TOKEN_COL();
"dif" return yy::MQOParser::make_TOKEN_DIF();
"emi" return yy::MQOParser::make_TOKEN_EMI();
"spc" return yy::MQOParser::make_TOKEN_SPC();
"power" return yy::MQOParser::make_TOKEN_POWER();
"visible" return yy::MQOParser::make_TOKEN_VISIBLE();
"locking" return yy::MQOParser::make_TOKEN_LOCKING();
"shading" return yy::MQOParser::make_TOKEN_SHADING();
"facet" return yy::MQOParser::make_TOKEN_FACET();
"color_type" return yy::MQOParser::make_TOKEN_COLOR_TYPE();
"mirror" return yy::MQOParser::make_TOKEN_MIRROR();
"mirror_axis" return yy::MQOParser::make_TOKEN_MIRROR_AXIS();
"vertex" return yy::MQOParser::make_TOKEN_VERTEX();
"face" return yy::MQOParser::make_TOKEN_FACE();
"V" return yy::MQOParser::make_TOKEN_V();
"M" return yy::MQOParser::make_TOKEN_M();
"UV" return yy::MQOParser::make_TOKEN_UV();
"pers" return yy::MQOParser::make_TOKEN_PERS();

"(" return yy::MQOParser::make_LEFTPAR();
")" return yy::MQOParser::make_RIGHTPAR();
"{" return yy::MQOParser::make_LEFTBR();
"}" return yy::MQOParser::make_RIGHTBR();

{INTEGER} {
    return yy::MQOParser::make_VAL_INT(std::atoi(yytext));
}
{FLOAT} {
    return yy::MQOParser::make_VAL_FLOAT(std::atof(yytext));
}
{STRING} {
    return yy::MQOParser::make_VAL_STRING(std::string(yytext, yyleng - 2));
}

[ \t\n] {}
%%
