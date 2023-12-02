#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - OPAQUE_PASS
* - TRANSPARENT_PASS
*
* Change_Color:
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__OFF
* - FANCY__ON
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*
* Tinting:
* - TINTING__DISABLED (not used)
* - TINTING__ENABLED (not used)
*
* UIEntity:
* - UI_ENTITY__DISABLED (not used)
* - UI_ENTITY__ENABLED (not used)
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute float a_indices;
attribute vec4 a_normal;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
#ifdef INSTANCING__ON
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
varying vec4 v_color0;
varying vec4 v_fog;
varying vec4 v_layerUv;
varying vec4 v_light;
centroid varying vec2 v_texcoord0;
centroid varying vec4 v_texcoords;
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
uniform vec4 UseAlphaRewrite;
uniform mat4 u_view;
uniform vec4 PatternCount;
uniform vec4 ChangeColor;
uniform vec4 FogControl;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform vec4 OverlayColor;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MatColor;
uniform vec4 TileLightIntensity;
uniform vec4 UVAnimation;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 UVScale;
uniform vec4 ColorBased;
uniform vec4 TintedAlphaTestEnabled;
uniform vec4 SubPixelOffset;
uniform vec4 HudOpacity;
uniform vec4 FogColor;
uniform vec4 ActorFPEpsilon;
uniform vec4 MultiplicativeTintColor;
uniform vec4 TileLightColor;
uniform mat4 Bones[8];
uniform vec4 PatternColors[7];
uniform vec4 PatternUVOffsetsAndScales[7];
uniform vec4 GlintColor;
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
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vec3 position;
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    int boneId;
    #endif
    vec4 normal;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec3 position;
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    int boneId;
    #endif
    vec2 texcoord0;
    vec4 color0;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vec4 color0;
    #endif
    vec4 texcoords;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 color0;
    vec4 layerUv;
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    vec4 light;
    #endif
    vec4 fog;
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    vec4 light;
    #endif
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vec4 layerUv;
    #endif
};

struct FragmentInput {
    vec2 texcoord0;
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vec4 color0;
    #endif
    vec4 texcoords;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 color0;
    vec4 layerUv;
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    vec4 light;
    #endif
    vec4 fog;
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    vec4 light;
    #endif
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vec4 layerUv;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_MatTexture;
uniform lowp sampler2D s_MatTexture1;
uniform lowp sampler2D s_MatTexture2;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 layerUv;
    #endif
    #if ! defined(ALPHA_TEST_PASS)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)
    vec4 texcoords;
    #endif
    vec2 texcoord0;
    #if defined(ALPHA_TEST_PASS)|| defined(TRANSPARENT_PASS)
    vec4 light;
    #endif
    vec4 fog;
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    vec4 light;
    #endif
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)
    vec4 texcoords;
    #endif
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vec4 layerUv;
    #endif
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vec4 light;
    #endif
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

vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x;
    offsetProj[2][1] -= SubPixelOffset.y;
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f)))));
}
vec2 applyUvAnimation(vec2 uv, const vec4 uvAnimation) {
    uv = uvAnimation.xy + (uv * uvAnimation.zw);
    return uv;
}
float calculateLightIntensity(const mat4 world, const vec4 normal, const vec4 tileLightColor) {
    #ifdef FANCY__OFF
    return 1.0;
    #endif
    #ifdef FANCY__ON
    const float AMBIENT = 0.45;
    const float XFAC = -0.1;
    const float ZFAC = 0.1;
    vec3 N = normalize(((world) * (normal))).xyz;
    N.y *= tileLightColor.a;
    float yLight = (1.0 + N.y) * 0.5;
    return yLight * (1.0 - AMBIENT) + N.x * N.x * XFAC + N.z * N.z * ZFAC + AMBIENT;
    #endif
}
float calculateFogIntensityVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd) {
    float distance = cameraDepth / maxDistance;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
void ActorVert(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    World = ((World) * (Bones[vertInput.boneId]));
    WorldView = ((View) * (World));
    WorldViewProj = ((Proj) * (WorldView));
    vec2 texcoord = vertInput.texcoord0;
    texcoord = applyUvAnimation(texcoord, UVAnimation);
    vertInput.texcoord0 = texcoord;
    float lightIntensity = calculateLightIntensity(World, vec4(vertInput.normal.xyz, 0.0), TileLightColor);
    lightIntensity += OverlayColor.a * 0.35;
    vertOutput.light = vec4(lightIntensity * TileLightColor.rgb, 1.0);
}
void ActorVertFog(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = jitterVertexPosition(vertInput.worldPos);
    float cameraDepth = vertOutput.position.z;
    float fogIntensity = calculateFogIntensityVanilla(cameraDepth, FogControl.z, FogControl.x, FogControl.y);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
}
#if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
vec2 calculateLayerUV(const vec2 origUV, const float offset, const float rotation, const vec2 scale) {
    vec2 uv = origUV;
    uv -= 0.5;
    float rsin = sin(rotation);
    float rcos = cos(rotation);
    uv = ((uv) * (mat2(rcos, - rsin, rsin, rcos)));
    uv.x += offset;
    uv += 0.5;
    return uv * scale;
}
void ActorVertGlint(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.layerUv.xy = calculateLayerUV(vertInput.texcoord0, UVAnimation.x, UVAnimation.z, UVScale.xy);
    vertOutput.layerUv.zw = calculateLayerUV(vertInput.texcoord0, UVAnimation.y, UVAnimation.w, UVScale.xy);
    ActorVert(vertInput, vertOutput);
}
#endif
#ifdef TRANSPARENT_PASS
void ActorVertPattern(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    ActorVertFog(stdInput, vertOutput);
}
#endif
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
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_LightingVertexFunctionIdentity(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
}
#endif

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
#endif
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifndef DEPTH_ONLY_PASS
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
#endif
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    ActorVert(vertInput, vertOutput);
    #endif
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    ActorVertGlint(vertInput, vertOutput);
    #endif
}
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    #ifndef TRANSPARENT_PASS
    ActorVertFog(vertInput, vertOutput);
    #endif
    #ifdef TRANSPARENT_PASS
    ActorVertPattern(vertInput, vertOutput);
    #endif
}
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    StandardTemplate_LightingVertexFunctionIdentity(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
#endif
#ifdef DEPTH_ONLY_PASS
void StandardTemplate_DepthOnly_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(vertInput, vertOutput, stdInput.worldPos);
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vertexInput.position = (a_position);
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    vertexInput.boneId = int(a_indices);
    #endif
    vertexInput.normal = (a_normal);
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vertexInput.position = (a_position);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    vertexInput.boneId = int(a_indices);
    #endif
    vertexInput.texcoord0 = (a_texcoord0);
    vertexInput.color0 = (a_color0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    vertexOutput.texcoord0 = vec2(0, 0);
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    #endif
    vertexOutput.texcoords = vec4(0, 0, 0, 0);
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.layerUv = vec4(0, 0, 0, 0);
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    vertexOutput.light = vec4(0, 0, 0, 0);
    #endif
    vertexOutput.fog = vec4(0, 0, 0, 0);
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    vertexOutput.light = vec4(0, 0, 0, 0);
    #endif
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    vertexOutput.layerUv = vec4(0, 0, 0, 0);
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
    #ifndef DEPTH_ONLY_PASS
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    #endif
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_DepthOnly_Vert(vertexInput, vertexOutput);
    #endif
    v_texcoord0 = vertexOutput.texcoord0;
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    v_color0 = vertexOutput.color0;
    #endif
    v_texcoords = vertexOutput.texcoords;
    #if defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    v_color0 = vertexOutput.color0;
    v_layerUv = vertexOutput.layerUv;
    #endif
    #ifndef DEPTH_ONLY_OPAQUE_PASS
    v_light = vertexOutput.light;
    #endif
    v_fog = vertexOutput.fog;
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    v_light = vertexOutput.light;
    #endif
    #if ! defined(DEPTH_ONLY_PASS)&& ! defined(OPAQUE_PASS)
    v_layerUv = vertexOutput.layerUv;
    #endif
    gl_Position = vertexOutput.position;
}
