Shader "Andy/FristLighting"
{
    Properties
    {
       _MainTex("Main Texture", 2D) = "White"{}
	   _Tint("Tint", Color)			= (1,1,1,1)
	   _Smoothness("Smoothness", Range(0,1)) = 0.5
	   _SpecTint("Specular", Color) = (0.5,0.5,0.5)
	   [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0

    }
    SubShader
    {
        Tags 
		{ 
			"RenderType"= "Opaque" 
			"LightMode" = "ForwardBase"
		}
        LOD 100

        Pass
        {
            CGPROGRAM

			#pragma target 3.0

            #pragma vertex		MyVertexProgram
            #pragma fragment	MyFragmentProgram
            
            #include "UnityPBSLighting.cginc"
			#include "UnityLightingCommon.cginc"

			sampler2D	_MainTex,_Texture1,_Texture2,_Texture3,_Texture4;
			float4		_MainTex_ST,_Texture1_ST, _Texture2_ST;
			float4		_Tint, _SpecTint;
			float		_Smoothness, _Metallic;

			struct Interpolators{
				float4 position			:SV_POSITION;
				float2 uv				:TEXCOORD0;
				float3 normal			:TEXCOORD1;
				float3 worldPos			:TEXCOORD2;
			};

			struct VertexData{
				float4 position	:POSITION;
				float2 uv		:TEXCOORD0;
				float3 normal	:NORMAL;
			};


            Interpolators MyVertexProgram (VertexData v)
            {
				Interpolators i;
				i.position		= UnityObjectToClipPos(v.position);			
				i.uv			= TRANSFORM_TEX(v.uv, _MainTex);
				i.normal		= UnityObjectToWorldNormal(v.normal);
				i.worldPos		= mul(unity_ObjectToWorld, v.position);
				return i;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_Target
            {
				i.normal			= normalize(i.normal);
				float3 lightDir		= _WorldSpaceLightPos0.xyz;
				float3 lightColor	= _LightColor0.rgb;
				float3 viewDir		= normalize(_WorldSpaceCameraPos  - i.worldPos);
				half3 albedo		= tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
				half3 specTine;
				// consider enegry make sure that the sum of the diffuse and specular parts of our material never exceed 1
				half oneMinusReflectivity;
				half3 color = DiffuseAndSpecularFromMetallic(
										albedo, _Metallic, specTine, oneMinusReflectivity
									);
								
				
				UnityLight light;
				light.color = lightColor;
				light.dir   = lightDir;
				light.ndotl = DotClamped(i.normal, lightDir);

				UnityIndirect indirectLight;
				indirectLight.diffuse	=	0;
				indirectLight.specular	=	0;

				return UNITY_BRDF_PBS(albedo, specTine,oneMinusReflectivity, _Smoothness,i.normal, viewDir, light,indirectLight);
			}
            ENDCG
        }
    }
}
