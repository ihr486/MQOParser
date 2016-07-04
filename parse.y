%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *msg)
{
    fprintf(stderr, "Error: %s.\n", msg);
    exit(-1);
}

int yylex(void);
%}

%union {
    long lval;
    double fval;
    char *sval;
}

%token TOKEN_EOF
%token TOKEN_SCENE TOKEN_BACKIMAGE TOKEN_MATERIAL TOKEN_OBJECT
%token TOKEN_POS TOKEN_LOOKAT TOKEN_HEAD TOKEN_PITCH TOKEN_BANK TOKEN_ORTHO TOKEN_ZOOM2 TOKEN_ZOOM_PERS TOKEN_AMB TOKEN_DIRLIGHTS TOKEN_LIGHT
%token TOKEN_DIR TOKEN_COLOR TOKEN_COL TOKEN_DIF TOKEN_EMI TOKEN_SPC TOKEN_POWER
%token TOKEN_VISIBLE TOKEN_LOCKING TOKEN_SHADING TOKEN_FACET TOKEN_COLOR_TYPE TOKEN_MIRROR TOKEN_MIRROR_AXIS
%token TOKEN_VERTEX TOKEN_FACE TOKEN_V TOKEN_M TOKEN_UV TOKEN_PERS
%token LEFTPAR RIGHTPAR LEFTBR RIGHTBR
%token VAL_LONG VAL_FLOAT VAL_STRING
%token EOL

%%

val_real : VAL_LONG
        | VAL_FLOAT
        ;
input   : blocks TOKEN_EOF
        ;
blocks  :
        | blocks block
        ;
block   : scene_block
        | backimage_block
        | material_block
        | object_block
        ;
scene_block : TOKEN_SCENE LEFTBR scene_body RIGHTBR
        ;
backimage_block : TOKEN_BACKIMAGE LEFTBR backimage_body RIGHTBR
        ;
material_block : TOKEN_MATERIAL VAL_LONG LEFTBR material_body RIGHTBR
        ;
object_block : TOKEN_OBJECT VAL_STRING LEFTBR object_body RIGHTBR
        ;
scene_body :
        | scene_body scene_item
        ;
backimage_body :
        | backimage_body backimage_item
        ;
material_body :
        | material_body material_item
        ;
object_body :
        | object_body object_item
        ;
scene_item : pos_record
        | lookat_record
        | head_record
        | pitch_record
        | bank_record
        | ortho_record
        | zoom2_record
        | zoom_pers_record
        | amb_record
        | dirlights_block
        ;
backimage_item : backimage_record
        ;
material_item : material_record
        ;
object_item : visible_record
        | locking_record
        | shading_record
        | facet_record
        | color_record
        | color_type_record
        | mirror_record
        | mirror_axis_record
        | vertex_block
        | face_block
        ;
pos_record : TOKEN_POS val_real val_real val_real EOL
        ;
lookat_record : TOKEN_LOOKAT val_real val_real val_real EOL
        ;
head_record : TOKEN_HEAD val_real EOL
        ;
pitch_record : TOKEN_PITCH val_real EOL
        ;
bank_record : TOKEN_BANK val_real EOL
        ;
ortho_record : TOKEN_ORTHO val_real EOL
        ;
zoom2_record : TOKEN_ZOOM2 val_real EOL
        ;
zoom_pers_record : TOKEN_ZOOM_PERS val_real EOL
        ;
amb_record : TOKEN_AMB val_real val_real val_real EOL
        ;
dirlights_block : TOKEN_DIRLIGHTS VAL_LONG LEFTBR dirlights_body RIGHTBR
        ;
dirlights_body :
        | dirlights_body light_block
        ;
light_block : TOKEN_LIGHT LEFTBR light_body RIGHTBR
        ;
light_body :
        | light_body light_item
        ;
light_item : dir_record
        | color_record
        ;
dir_record : TOKEN_DIR val_real val_real val_real EOL
        ;
backimage_record : TOKEN_PERS VAL_STRING val_real val_real val_real val_real EOL
        ;
material_record : VAL_STRING material_fields EOL
        ;
material_fields :
        | col_field
        | dif_field
        | amb_field
        | emi_field
        | spc_field
        | power_field
        | material_fields material_fields
        ;
col_field : TOKEN_COL LEFTPAR val_real val_real val_real val_real RIGHTPAR
        ;
dif_field : TOKEN_DIF LEFTPAR val_real RIGHTPAR
        ;
amb_field : TOKEN_AMB LEFTPAR val_real RIGHTPAR
        ;
emi_field : TOKEN_EMI LEFTPAR val_real RIGHTPAR
        ;
spc_field : TOKEN_SPC LEFTPAR val_real RIGHTPAR
        ;
power_field : TOKEN_POWER LEFTPAR val_real RIGHTPAR
        ;
visible_record : TOKEN_VISIBLE VAL_LONG EOL
        ;
locking_record : TOKEN_LOCKING VAL_LONG EOL
        ;
shading_record : TOKEN_SHADING VAL_LONG EOL
        ;
facet_record : TOKEN_FACET val_real EOL
        ;
color_record : TOKEN_COLOR val_real val_real val_real EOL
        ;
color_type_record : TOKEN_COLOR_TYPE VAL_LONG EOL
        ;
mirror_record : TOKEN_MIRROR VAL_LONG EOL
        ;
mirror_axis_record : TOKEN_MIRROR_AXIS VAL_LONG EOL
        ;
vertex_block : TOKEN_VERTEX VAL_LONG LEFTBR vertex_body RIGHTBR
        ;
vertex_body :
        | vertex_body vertex_record
        ;
vertex_record : val_real val_real val_real EOL
        ;
face_block : TOKEN_FACE VAL_LONG LEFTBR face_body RIGHTBR
        ;
face_body :
        | face_body face_record
        ;
face_record : VAL_LONG index4_field mat_field
        | VAL_LONG index3_field mat_field
        | VAL_LONG index4_field mat_field uv4_field
        | VAL_LONG index3_field mat_field uv3_field
        ;
index4_field : TOKEN_V LEFTPAR VAL_LONG VAL_LONG VAL_LONG VAL_LONG RIGHTPAR
        ;
index3_field : TOKEN_V LEFTPAR VAL_LONG VAL_LONG VAL_LONG RIGHTPAR
        ;
mat_field : TOKEN_M LEFTPAR VAL_LONG RIGHTPAR
        ;
uv4_field : TOKEN_UV LEFTPAR val_real val_real val_real val_real val_real val_real val_real val_real RIGHTPAR
        ;
uv3_field : TOKEN_UV LEFTPAR val_real val_real val_real val_real val_real val_real RIGHTPAR
        ;
%%
int main(int argc, const char *argv[])
{
    yyparse();
    return 0;
}
