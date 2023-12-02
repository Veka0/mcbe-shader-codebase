#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS
* - GEOMETRY_PREPASS_PASS
* - OPAQUE_PASS
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec3 a_position;
#ifdef GEOMETRY_PREPASS_PASS
attribute vec2 a_texcoord0;
#endif
#ifdef INSTANCING__ON
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
varying vec4 v_color0;
#ifdef GEOMETRY_PREPASS_PASS
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
varying vec2 v_texcoord0;
varying vec3 v_worldPos;
#endif
struct NoopSampler {
    int noop;
};

#ifdef INSTANCING__ON
vec3 instMul(vec3 _vec, mat3 _mtx) {
    return ((_vec) * (_mtx));
}
vec3 instMul(mat3 _mtx, vec3 _vec) {
    return ((_mtx) * (_vec));
}
vec4 instMul(vec4 _vec, mat4 _mtx) {
    return ((_vec) * (_mtx));
}
vec4 instMul(mat4 _mtx, vec4 _vec) {
    return ((_mtx) * (_vec));
}
#endif
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
uniform vec4 LightWorldSpaceDirection;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 SkyColor;
uniform vec4 FogColor;
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
    vec3 position;
    #ifdef GEOMETRY_PREPASS_PASS
    vec2 texcoord0;
    #endif
    vec4 color0;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    #ifdef GEOMETRY_PREPASS_PASS
    vec2 texcoord0;
    #endif
    vec4 color0;
    #ifdef GEOMETRY_PREPASS_PASS
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    #endif
};

struct FragmentInput {
    #ifdef GEOMETRY_PREPASS_PASS
    vec2 texcoord0;
    #endif
    vec4 color0;
    #ifdef GEOMETRY_PREPASS_PASS
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
    #endif
};

struct FragmentOutput {
    #ifndef GEOMETRY_PREPASS_PASS
    vec4 Color0;
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    vec4 Color0; vec4 Color1; vec4 Color2;
    #endif
};

#ifdef FALLBACK_PASS
void FallbackVert(VertexInput vertInput, inout VertexOutput vertOutput) {
}
#endif
#ifdef GEOMETRY_PREPASS_PASS
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 color0;
    vec3 worldPos;
    vec3 prevWorldPos;
    vec3 normal;
};

struct StandardVertexInput {
    VertexInput vertInput;
    vec3 worldPos;
};

struct StandardSurfaceOutput {
    vec3 Albedo;
    float Alpha;
    float Metallic;
    float Roughness;
    float Occlusion;
    float Emissive;
    vec3 AmbientLight;
    vec3 ViewSpaceNormal;
};

struct CompositingOutput {
    vec3 mLitColor;
};

void StandardTemplate_VertSharedTransform(VertexInput vertInput, inout VertexOutput vertOutput, out vec3 worldPosition) {
    #ifdef INSTANCING__OFF
    vec3 wpos = ((World) * (vec4(vertInput.position, 1.0))).xyz;
    #endif
    #ifdef INSTANCING__ON
    mat4 model;
    model[0] = vec4(vertInput.instanceData0.x, vertInput.instanceData1.x, vertInput.instanceData2.x, 0);
    model[1] = vec4(vertInput.instanceData0.y, vertInput.instanceData1.y, vertInput.instanceData2.y, 0);
    model[2] = vec4(vertInput.instanceData0.z, vertInput.instanceData1.z, vertInput.instanceData2.z, 0);
    model[3] = vec4(vertInput.instanceData0.w, vertInput.instanceData1.w, vertInput.instanceData2.w, 1);
    vec3 wpos = instMul(model, vec4(vertInput.position, 1.0)).xyz;
    #endif
    vertOutput.position = ((ViewProj) * (vec4(wpos, 1.0)));
    worldPosition = wpos;
}
void StandardTemplate_VertexPreprocessIdentity(VertexInput vertInput, inout VertexOutput vertOutput) {
}
void StandardTemplate_LightingVertexFunctionIdentity(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
}

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

void SkyVertGeometryPrepassOverride(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    vertOutput.worldPos = stdInput.worldPos;
    vertOutput.position = ((WorldViewProj) * (vec4(stdInput.vertInput.position, 1.0)));
    vertOutput.color0 = mix(SkyColor, FogColor, stdInput.vertInput.color0.r);
    vertOutput.prevWorldPos = ((World) * (vec4(stdInput.vertInput.position, 1.0))).xyz;
}
void StandardTemplate_VertShared(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(vertInput, vertOutput, stdInput.worldPos);
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.color0 = vertInput.color0;
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
    StandardTemplate_InvokeLightingVertexFunction(vertInput, vertOutput, stdInput.worldPos);
}
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertexPreprocessIdentity(vertInput, vertOutput);
}
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    SkyVertGeometryPrepassOverride(vertInput, vertOutput);
}
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    StandardTemplate_LightingVertexFunctionIdentity(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
#endif
#ifdef OPAQUE_PASS
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((WorldViewProj) * (vec4(vertInput.position, 1.0)));
    vertOutput.color0 = mix(SkyColor, FogColor, vertInput.color0.r);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    #ifdef GEOMETRY_PREPASS_PASS
    vertexInput.texcoord0 = (a_texcoord0);
    #endif
    vertexInput.color0 = (a_color0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    vertexOutput.texcoord0 = vec2(0, 0);
    #endif
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    #ifdef GEOMETRY_PREPASS_PASS
    vertexOutput.worldPos = vec3(0, 0, 0);
    vertexOutput.prevWorldPos = vec3(0, 0, 0);
    vertexOutput.normal = vec3(0, 0, 0);
    #endif
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
    #ifdef FALLBACK_PASS
    FallbackVert(vertexInput, vertexOutput);
    #endif
    #ifdef GEOMETRY_PREPASS_PASS
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    v_texcoord0 = vertexOutput.texcoord0;
    #endif
    #ifdef OPAQUE_PASS
    Vert(vertexInput, vertexOutput);
    #endif
    v_color0 = vertexOutput.color0;
    #ifdef GEOMETRY_PREPASS_PASS
    v_worldPos = vertexOutput.worldPos;
    v_prevWorldPos = vertexOutput.prevWorldPos;
    v_normal = vertexOutput.normal;
    #endif
    gl_Position = vertexOutput.position;
}
