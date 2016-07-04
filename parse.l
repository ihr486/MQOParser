%{
#include <stdio.h>
#include <stdlib.h>

#include "parse.tab.h"

int yywrap(void)
{
    return 1;
}
%}
INTEGER "0"|(-?[1-9][0-9]*)
FLOAT -?("0."|([1-9][0-9]*\.))[0-9]*
STRING \"[A-Za-z0-9]*\"
%%
"Metasequoia"|"Document"|"Format"|"Text"|"Ver1.0" {
    //Read skip the header string
}

"Eof" return TOKEN_EOF;
"Scene" return TOKEN_SCENE;
"BackImage" return TOKEN_BACKIMAGE;
"Material" return TOKEN_MATERIAL;
"Object" return TOKEN_OBJECT;
"pos" return TOKEN_POS;
"lookat" return TOKEN_LOOKAT;
"head" return TOKEN_HEAD;
"pich" return TOKEN_PITCH;
"bank" return TOKEN_BANK;
"ortho" return TOKEN_ORTHO;
"zoom2" return TOKEN_ZOOM2;
"zoom_pers" return TOKEN_ZOOM_PERS;
"amb" return TOKEN_AMB;
"dirlights" return TOKEN_DIRLIGHTS;
"light" return TOKEN_LIGHT;
"dir" return TOKEN_DIR;
"color" return TOKEN_COLOR;
"col" return TOKEN_COL;
"dif" return TOKEN_DIF;
"emi" return TOKEN_EMI;
"spc" return TOKEN_SPC;
"power" return TOKEN_POWER;
"visible" return TOKEN_VISIBLE;
"locking" return TOKEN_LOCKING;
"shading" return TOKEN_SHADING;
"facet" return TOKEN_FACET;
"color_type" return TOKEN_COLOR_TYPE;
"mirror" return TOKEN_MIRROR;
"mirror_axis" return TOKEN_MIRROR_AXIS;
"vertex" return TOKEN_VERTEX;
"face" return TOKEN_FACE;
"V" return TOKEN_V;
"M" return TOKEN_M;
"UV" return TOKEN_UV;
"pers" return TOKEN_PERS;

"(" return LEFTPAR;
")" return RIGHTPAR;
"{" return LEFTBR;
"}" return RIGHTBR;

{INTEGER} {
    yylval.lval = atol(yytext);
    return VAL_LONG;
}
{FLOAT} {
    yylval.fval = atof(yytext);
    return VAL_FLOAT;
}
{STRING} {
    yylval.sval = malloc(yyleng - 1);
    strncpy(yylval.sval, &yytext[1], yyleng - 2);
    yylval.sval[yyleng - 2] = '\0';
    return VAL_STRING;
}

[ \t] {
}
\n {
    return EOL;
}
%%
