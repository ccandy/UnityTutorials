Shader "Andy/FristLighting"
{
    Properties
    {
       _MainTex("Main Texture", 2D) = "White"{}
	   _Tint("Tint", Color)			= (1,1,1,1)
	   _Smoothness("Smoothness", Range(0,1)) = 0.5
	   _SpecTint("Specular", Color) = (0.5,0.5,0.5)
	   [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
	   [NoScaleOffset] _NormalMap ("Heights", 2D) = "bump"{}
	   _BumpScale ("Bump Scale", Float) = 1
	   _DetailTex ("Detail Texture", 2D) = "gray" {}
    }
    SubShader
    {
        
        LOD 100

        Pass
        {

			Tags 
			{ 
				"RenderType"= "Opaque" 
				"LightMode" = "ForwardBase"
			}
            CGPROGRAM

			#pragma target 3.0
			#pragma multi_compile_VERTEXLIGHT_ON
            #pragma vertex		MyVertexProgram
            #pragma fragment	MyFragmentProgram

			#include "MyLighting.cginc"           
        
			ENDCG
		}
		Pass
		{

			Tags 
			{ 
				"RenderType"= "Opaque" 
				"LightMode" = "ForwardAdd"
			}

			Blend One One
			ZWrite Off

			CGPROGRAM

			#pragma target 3.0

            #pragma vertex		MyVertexProgram
            #pragma fragment	MyFragmentProgram
			#pragma multi_compile_fwdadd

			#include "MyLighting.cginc"           
        
			ENDCG
		}
		
    }
}