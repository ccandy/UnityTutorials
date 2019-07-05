#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED

#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"
#include "UnityLightingCommon.cginc"

sampler2D	_MainTex,_DetailTex, _NormalMap;
float4		_MainTex_ST,_DetailTex_ST;
float4		_Tint, _SpecTint;
float4		_HeightMap_TexelSize;
float		_Smoothness, _Metallic, _BumpScale;




struct Interpolators{
	float4 position			:SV_POSITION;
	float4 uv				:TEXCOORD0;
	float3 normal			:TEXCOORD1;
	float3 worldPos			:TEXCOORD2;

	#if defined(VERTEXLIGHT_ON)
		float3 vertexLightColor:TEXCOORD3;
	#endif

};

struct VertexData{
	float4 position	:POSITION;
	float2 uv		:TEXCOORD0;
	float3 normal	:NORMAL;
};

UnityLight CreateLight(Interpolators i){
	UnityLight light;

	#if defined(POINT) || defined(SPOT) || defined(POINT_COOKIE)
		light.dir		= normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
	#else
		light.dir		= _WorldSpaceLightPos0.xyz;
	#endif

	UNITY_LIGHT_ATTENUATION(atten, 0, i.worldPos);
	light.color		= _LightColor0.rgb * atten;
	light.ndotl		= DotClamped(i.normal, light.dir);
	return light;
}

UnityIndirect CreateIndirectLight(Interpolators i){
	UnityIndirect indirectLight;
	indirectLight.diffuse 	= 0;
	indirectLight.specular	= 0;
	
	#if defined(VERTEXLIGHT_ON)
		indirectLight.diffuse = i.vertexLightColor;
	#endif
	return indirectLight;
}

void InitializeFragmentNormal(inout Interpolators i){
	i.normal	= UnpackScaleNormal(tex2D(_NormalMap, i.uv.xy), _BumpScale);
	i.normal	= i.normal.xyz;
	i.normal	= normalize(i.normal);
}


void ComputeVertexLightColor(inout Interpolators i){
	#if defined(VERTEXLIGHT_ON)
		i.vertexLightColor	= unity_LightColor[0].rgb;
	#endif
}

Interpolators MyVertexProgram (VertexData v)
{
	Interpolators i;
	i.position		= UnityObjectToClipPos(v.position);			
	i.uv.xy		= TRANSFORM_TEX(v.uv, _MainTex);
	i.uv.zw			= TRANSFORM_TEX(v.uv, _DetailTex);
	i.normal		= UnityObjectToWorldNormal(v.normal);
	i.worldPos		= mul(unity_ObjectToWorld, v.position);
	ComputeVertexLightColor(i);
	return i;
}




float4 MyFragmentProgram (Interpolators i) : SV_Target
{
	//i.normal			= normalize(i.normal);
	InitializeFragmentNormal(i);
	float3 viewDir		= normalize(_WorldSpaceCameraPos  - i.worldPos);
	half3 albedo		= tex2D(_MainTex, i.uv.xy).rgb * _Tint.rgb;
	albedo				*= tex2D(_DetailTex, i.uv.zw) * unity_ColorSpaceDouble;
	half3 specTine;
				// consider enegry make sure that the sum of the diffuse and specular parts of our material never exceed 1
	half oneMinusReflectivity;
	half3 color = DiffuseAndSpecularFromMetallic(
					albedo, _Metallic, specTine, oneMinusReflectivity
				);
							
	UnityIndirect indirectLight;
	indirectLight.diffuse	=	0;
	indirectLight.specular	=	0;

	return UNITY_BRDF_PBS(albedo, specTine,oneMinusReflectivity, _Smoothness,i.normal, viewDir, CreateLight(i),CreateIndirectLight(i));
}

#endif
