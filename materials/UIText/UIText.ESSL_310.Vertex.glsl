#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* ALPHA_TEST:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON (not used)
*
* MSDF:
* - MSDF__OFF (not used)
* - MSDF__ON (not used)
*
* SMOOTH:
* - SMOOTH__OFF (not used)
* - SMOOTH__ON (not used)
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
varying vec4 v_color0;
varying vec2 v_texcoord0;
struct NoopSampler {
    int noop;
};

struct NoopImage2D {
    int noop;
};

struct NoopImage3D {
    int noop;
};

struct rayQueryKHR {
    int noop;
};

struct accelerationStructureKHR {
    int noop;
};

uniform vec4 u_viewRect;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 u_viewTexel;
uniform vec4 ShadowSmoothRadius;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 HudOpacity;
uniform vec4 TintColor;
uniform vec4 GlyphSmoothRadius;
uniform vec4 GlyphCutoff;
uniform vec4 OutlineCutoff;
uniform vec4 OutlineColor;
uniform vec4 ShadowOffset;
uniform vec4 ShadowColor;
vec4 ViewRect;
mat4 Proj;
mat4 View;
vec4 ViewTexel;
mat4 InvView;
mat4 InvProj;
mat4 ViewProj;
mat4 InvViewProj;
mat4 PrevViewProj;
mat4 WorldArray[4];
mat4 World;
mat4 WorldView;
mat4 WorldViewProj;
vec4 PrevWorldPosOffset;
vec4 AlphaRef4;
float AlphaRef;
struct VertexInput {
    vec2 texcoord0;
    vec4 color0;
    vec3 position;
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
    vec4 color0;
};

struct FragmentInput {
    vec2 texcoord0;
    vec4 color0;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_GlyphTexture;
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((WorldViewProj) * (vec4(vertInput.position, 1.0)));
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.color0 = vertInput.color0;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.texcoord0 = (a_texcoord0);
    vertexInput.color0 = (a_color0);
    vertexInput.position = (a_position);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.position = vec4(0, 0, 0, 0);
    ViewRect = u_viewRect;
    Proj = u_proj;
    View = u_view;
    ViewTexel = u_viewTexel;
    InvView = u_invView;
    InvProj = u_invProj;
    ViewProj = u_viewProj;
    InvViewProj = u_invViewProj;
    PrevViewProj = u_prevViewProj;
    {
        WorldArray[0] = u_model[0];
        WorldArray[1] = u_model[1];
        WorldArray[2] = u_model[2];
        WorldArray[3] = u_model[3];
    }
    World = u_model[0];
    WorldView = u_modelView;
    WorldViewProj = u_modelViewProj;
    PrevWorldPosOffset = u_prevWorldPosOffset;
    AlphaRef4 = u_alphaRef4;
    AlphaRef = u_alphaRef4.x;
    Vert(vertexInput, vertexOutput);
    v_texcoord0 = vertexOutput.texcoord0;
    v_color0 = vertexOutput.color0;
    gl_Position = vertexOutput.position;
}
