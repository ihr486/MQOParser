%skeleton "lalr1.cc"
%defines "parser.hh"
%output "parser.cc"
%define parser_class_name {MQOParser}
%define api.value.type variant
%define api.token.constructor
%parse-param {Model &model}
%code requires
{
#define YY_NULLPTR nullptr
#include <string>
#include <array>
#include <vector>
struct Vector2 {
    float x, y;
};
struct Vector3 {
    float x, y, z;
};
struct Color3 {
    float r, g, b;
};
struct Color4 {
    float r, g, b, a;
};
typedef std::array<int, 3> Index3;
typedef std::array<int, 4> Index4;
typedef std::array<Vector2, 3> TexCoord3;
typedef std::array<Vector2, 4> TexCoord4;
struct Light {
    Vector3 dir;
    Color3 color;
};
typedef std::vector<Light> DirLights;
struct Material {
    Color4 col;
    float dif, amb, emi, spc, power;
};
typedef std::vector<Material> Materials;
typedef std::vector<Vector3> Vertices;
struct Scene {
    Vector3 pos, lookat;
    float head, pitch, bank, ortho, zoom2, zoom_pers;
    Color3 amb;
    DirLights dirlights;
};
struct Face3 {
    Index3 indices;
    int material;
    TexCoord3 texcoords;
};
struct Face4 {
    Index4 indices;
    int material;
    TexCoord4 texcoords;
};
struct Faces {
    std::vector<Face3> triangles;
    std::vector<Face4> quads;
};
struct Object {
    int visible, locking, shading;
    float facet;
    Color3 color;
    int color_type;
    int mirror;
    int mirror_axis;
    Vertices vertices;
    Faces faces;
};
typedef std::vector<Object> Objects;
struct Model {
    Scene scene;
    Materials materials;
    Objects objects;
};
}
%code provides
{
#define YY_DECL yy::MQOParser::symbol_type yylex()
YY_DECL;
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
%type <Vector3> pos_record lookat_record dir_record vertex_record
%type <Color3> amb_record color_record
%type <Color4> col_field
%type <Index3> index3_field
%type <Index4> index4_field
%type <TexCoord3> uv3_field
%type <TexCoord4> uv4_field
%type <DirLights> dirlights_block dirlights_body
%type <Light> light_block light_body
%type <Material> material_record
%type <Object> object_block object_body
%type <Materials> material_block material_body
%type <Objects> object_blocks
%type <Scene> scene_block scene_body
%type <Vertices> vertex_block vertex_body
%type <Face3> face3_record
%type <Face4> face4_record
%type <Faces> face_block face_body

%%
%start input;

//Start symbol
input   : scene_block backimage_block material_block object_blocks TOKEN_EOF {model = Model{std::move($1), std::move($3), std::move($4)};}
        ;

//Top level blocks
scene_block : TOKEN_SCENE LEFTBR scene_body RIGHTBR {$$ = std::move($3);}
        ;
backimage_block : TOKEN_BACKIMAGE LEFTBR backimage_body RIGHTBR
        ;
material_block : TOKEN_MATERIAL VAL_INT LEFTBR material_body RIGHTBR {$$ = std::move($4);}
        ;
object_blocks: {}
        | object_blocks object_block {$$.push_back(std::move($2));}
        ;
object_block : TOKEN_OBJECT VAL_STRING LEFTBR object_body RIGHTBR {$$ = std::move($4);}
        ;

//Definition of each top level block
scene_body : pos_record lookat_record head_record pitch_record bank_record ortho_record zoom2_record zoom_pers_record amb_record dirlights_block {$$ = Scene{$1, $2, $3, $4, $5, $6, $7, $8, $9, $10};}
        ;
backimage_body :
        | backimage_body backimage_record
        ;
material_body : {}
        | material_body material_record {$$.push_back(std::move($2));}
        ;
object_body : visible_record locking_record shading_record facet_record color_record color_type_record mirror_record mirror_axis_record vertex_block face_block {$$ = Object{$1, $2, $3, $4, $5, $6, $7, $8, std::move($9), std::move($10)};}
        ;

//Content of Scene block
pos_record : TOKEN_POS val_real val_real val_real {$$ = Vector3{$2, $3, $4};}
        ;
lookat_record : TOKEN_LOOKAT val_real val_real val_real {$$ = Vector3{$2, $3, $4};}
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
amb_record : TOKEN_AMB val_real val_real val_real {$$ = Color3{$2, $3, $4};}
        ;
dirlights_block : TOKEN_DIRLIGHTS VAL_INT LEFTBR dirlights_body RIGHTBR {$$ = std::move($4);}
        ;
dirlights_body : {}
        | dirlights_body light_block {$$.push_back($2);}
        ;
light_block : TOKEN_LIGHT LEFTBR light_body RIGHTBR {$$ = std::move($3);}
        ;
light_body : dir_record color_record {$$ = Light{$1, $2};}
        ;
dir_record : TOKEN_DIR val_real val_real val_real {$$ = Vector3{$2, $3, $4};}
        ;

//Content of Backimage block (ignored)
backimage_record : TOKEN_PERS VAL_STRING val_real val_real val_real val_real
        ;

//Content of Material block
material_record : VAL_STRING col_field dif_field amb_field emi_field spc_field power_field {$$ = Material{$2, $3, $4, $5, $6, $7};}
        ;
col_field : TOKEN_COL LEFTPAR val_real val_real val_real val_real RIGHTPAR {$$ = Color4{$3, $4, $5, $6};}
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

//Content of Object block
visible_record : TOKEN_VISIBLE VAL_INT {$$ = $2;}
        ;
locking_record : TOKEN_LOCKING VAL_INT {$$ = $2;}
        ;
shading_record : TOKEN_SHADING VAL_INT {$$ = $2;}
        ;
facet_record : TOKEN_FACET val_real {$$ = $2;}
        ;
color_record : TOKEN_COLOR val_real val_real val_real {$$ = Color3{$2, $3, $4};}
        ;
color_type_record : TOKEN_COLOR_TYPE VAL_INT {$$ = $2;}
        ;
mirror_record : TOKEN_MIRROR VAL_INT {$$ = $2;}
        ;
mirror_axis_record : TOKEN_MIRROR_AXIS VAL_INT {$$ = $2;}
        ;
vertex_block : TOKEN_VERTEX VAL_INT LEFTBR vertex_body RIGHTBR {$$ = std::move($4);}
        ;
vertex_body : {}
        | vertex_body vertex_record {$$.push_back($2);}
        ;
vertex_record : val_real val_real val_real {$$ = Vector3{$1, $2, $3};}
        ;
face_block : TOKEN_FACE VAL_INT LEFTBR face_body RIGHTBR {$$ = std::move($4);}
        ;
face_body : {}
        | face_body face3_record {$$.triangles.push_back($2);}
        | face_body face4_record {$$.quads.push_back($2);}
        ;
face3_record : VAL_INT index3_field mat_field uv3_field {$$ = Face3{$2, $3, $4};}
        ;
face4_record : VAL_INT index4_field mat_field uv4_field {$$ = Face4{$2, $3, $4};}
        ;
index4_field : TOKEN_V LEFTPAR VAL_INT VAL_INT VAL_INT VAL_INT RIGHTPAR {$$ = {$3, $4, $5, $6};}
        ;
index3_field : TOKEN_V LEFTPAR VAL_INT VAL_INT VAL_INT RIGHTPAR {$$ = {$3, $4, $5};}
        ;
mat_field : TOKEN_M LEFTPAR VAL_INT RIGHTPAR {$$ = $3;}
        ;
uv4_field : {$$ = {Vector2{0, 0}, Vector2{0, 0}, Vector2{0, 0}, Vector2{0, 0}};}
        | TOKEN_UV LEFTPAR val_real val_real val_real val_real val_real val_real val_real val_real RIGHTPAR {$$ = {Vector2{$3, $4}, Vector2{$5, $6}, Vector2{$7, $8}, Vector2{$9, $10}};}
        ;
uv3_field : {$$ = {Vector2{0, 0}, Vector2{0, 0}, Vector2{0, 0}};}
        | TOKEN_UV LEFTPAR val_real val_real val_real val_real val_real val_real RIGHTPAR {$$ = {Vector2{$3, $4}, Vector2{$5, $6}, Vector2{$7, $8}};}
        ;

//Miscellaneous
val_real : VAL_INT {$$ = $1;}
        | VAL_FLOAT {$$ = $1;}
        ;
%%
void yy::MQOParser::error(const std::string& msg)
{
    std::cerr << msg << std::endl;
}
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
