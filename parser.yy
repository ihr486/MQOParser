%skeleton "lalr1.cc"
%defines "parser.hh"
%output "parser.cc"
%define parser_class_name {mqo_parser}
%define api.value.type variant
%define api.token.constructor
%param {mqo_driver& driver}
%printer {yyoutput << $$;} <*>;
%code requires
{
#define YY_NULLPTR nullptr
#include <string>
class mqo_driver;

struct vector3 {
    float x, y, z;
};
struct color3 {
    float r, g, b;
};
}
%code
{
#include "driver.hh"
}

//Symbolic tokens
%token END 0
%token TOKEN_EOF
%token LEFTPAR RIGHTPAR LEFTBR RIGHTBR

//Block/Field/Record markers
%token TOKEN_SCENE TOKEN_BACKIMAGE TOKEN_MATERIAL TOKEN_OBJECT
%token TOKEN_POS TOKEN_LOOKAT TOKEN_HEAD TOKEN_PITCH TOKEN_BANK TOKEN_ORTHO TOKEN_ZOOM2 TOKEN_ZOOM_PERS TOKEN_AMB TOKEN_DIRLIGHTS TOKEN_LIGHT
%token TOKEN_DIR TOKEN_COLOR TOKEN_COL TOKEN_DIF TOKEN_EMI TOKEN_SPC TOKEN_POWER
%token TOKEN_VISIBLE TOKEN_LOCKING TOKEN_SHADING TOKEN_FACET TOKEN_COLOR_TYPE TOKEN_MIRROR TOKEN_MIRROR_AXIS
%token TOKEN_VERTEX TOKEN_FACE TOKEN_V TOKEN_M TOKEN_UV TOKEN_PERS

//Literal values
%token <int> VAL_INT
%token <float> VAL_FLOAT
%token <std::string> VAL_STRING

//Aggregate values
%type <float> val_real
%type <float> head_record pitch_record bank_record ortho_record zoom2_record zoom_pers_record dif_field amb_field emi_field spc_field power_field facet_record
%type <int> visible_record locking_record shading_record color_type_record mirror_record mirror_axis_record mat_field
%type <vector3> pos_record lookat_record dir_record vertex_record
%type <color3> amb_record color_record

%%
%start input;

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
material_block : TOKEN_MATERIAL VAL_INT LEFTBR material_body RIGHTBR
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

pos_record : TOKEN_POS val_real val_real val_real {$$ = vector3{$2, $3, $4};}
        ;
lookat_record : TOKEN_LOOKAT val_real val_real val_real {$$ = vector3{$2, $3, $4};}
        ;
head_record : TOKEN_HEAD val_real {$$ = $2;}
        ;
pitch_record : TOKEN_PITCH val_real {$$ = $2;}
        ;
bank_record : TOKEN_BANK val_real {$$ = $2;}
        ;
ortho_record : TOKEN_ORTHO val_real {$$ = $2;}
        ;
zoom2_record : TOKEN_ZOOM2 val_real {$$ = $2;}
        ;
zoom_pers_record : TOKEN_ZOOM_PERS val_real {$$ = $2;}
        ;
amb_record : TOKEN_AMB val_real val_real val_real {$$ = color3{$2, $3, $4};}
        ;
dirlights_block : TOKEN_DIRLIGHTS VAL_INT LEFTBR dirlights_body RIGHTBR
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
dir_record : TOKEN_DIR val_real val_real val_real {$$ = vector3{$2, $3, $4};}
        ;
backimage_record : TOKEN_PERS VAL_STRING val_real val_real val_real val_real
        ;
material_record : VAL_STRING material_fields
        ;
material_fields :
        | material_fields material_field_item
        ;
material_field_item : col_field
        | dif_field
        | amb_field
        | emi_field
        | spc_field
        | power_field
        ;
col_field : TOKEN_COL LEFTPAR val_real val_real val_real val_real RIGHTPAR
        ;
dif_field : TOKEN_DIF LEFTPAR val_real RIGHTPAR {$$ = $3;}
        ;
amb_field : TOKEN_AMB LEFTPAR val_real RIGHTPAR {$$ = $3;}
        ;
emi_field : TOKEN_EMI LEFTPAR val_real RIGHTPAR {$$ = $3;}
        ;
spc_field : TOKEN_SPC LEFTPAR val_real RIGHTPAR {$$ = $3;}
        ;
power_field : TOKEN_POWER LEFTPAR val_real RIGHTPAR {$$ = $3;}
        ;
visible_record : TOKEN_VISIBLE VAL_INT {$$ = $2;}
        ;
locking_record : TOKEN_LOCKING VAL_INT {$$ = $2;}
        ;
shading_record : TOKEN_SHADING VAL_INT {$$ = $2;}
        ;
facet_record : TOKEN_FACET val_real {$$ = $2;}
        ;
color_record : TOKEN_COLOR val_real val_real val_real {$$ = color3{$2, $3, $4};}
        ;
color_type_record : TOKEN_COLOR_TYPE VAL_INT {$$ = $2;}
        ;
mirror_record : TOKEN_MIRROR VAL_INT {$$ = $2;}
        ;
mirror_axis_record : TOKEN_MIRROR_AXIS VAL_INT {$$ = $2;}
        ;
vertex_block : TOKEN_VERTEX VAL_INT LEFTBR vertex_body RIGHTBR
        ;
vertex_body :
        | vertex_body vertex_record
        ;
vertex_record : val_real val_real val_real {$$ = vector3{$1, $2, $3};}
        ;
face_block : TOKEN_FACE VAL_INT LEFTBR face_body RIGHTBR
        ;
face_body :
        | face_body face_record
        ;
face_record : VAL_INT index4_field mat_field
        | VAL_INT index3_field mat_field
        | VAL_INT index4_field mat_field uv4_field
        | VAL_INT index3_field mat_field uv3_field
        ;
index4_field : TOKEN_V LEFTPAR VAL_INT VAL_INT VAL_INT VAL_INT RIGHTPAR
        ;
index3_field : TOKEN_V LEFTPAR VAL_INT VAL_INT VAL_INT RIGHTPAR
        ;
mat_field : TOKEN_M LEFTPAR VAL_INT RIGHTPAR {$$ = $3;}
        ;
uv4_field : TOKEN_UV LEFTPAR val_real val_real val_real val_real val_real val_real val_real val_real RIGHTPAR
        ;
uv3_field : TOKEN_UV LEFTPAR val_real val_real val_real val_real val_real val_real RIGHTPAR
        ;
val_real : VAL_INT { $$ = $1; }
        | VAL_FLOAT { $$ = $1; }
        ;
%%
void yy::mqo_parser::error(const std::string& msg)
{
    std::cerr << msg << std::endl;
}
int main(int argc, const char *argv[])
{
    mqo_driver driver;
    if(argc >= 2) {
        driver.parse(std::string(argv[1]));
    } else {
        driver.parse();
    }
    return 0;
}
