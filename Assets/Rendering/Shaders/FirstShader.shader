// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Andy/FirstShader"
{
    Properties
    {
        _MainTex ("Texture", 2D)	= "white" {}
		_Tint	 ("Tint", Color)	= (1,1,1,1)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex		MyVertexProgram
            #pragma fragment	MyFragmentProgram
            
            #include "UnityCG.cginc"

			sampler2D	_MainTex;
			float4		_MainTex_ST;
			float4		_Tint;

			struct Interpolators{
				float4 position			:SV_POSITION;
				//float3 localPosition	:TEXCOORD0;
				float2 uv				:TEXCOORD0;
			};

			struct VertexData{
				float4 position			:POSITION;
				float2 uv				:TEXCOORD0;
			};


            Interpolators MyVertexProgram (VertexData v)
            {
				Interpolators i;
				i.position		= UnityObjectToClipPos(v.position);
				i.uv			= TRANSFORM_TEX(v.uv, _MainTex);

				return i;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_Target
            {
				float4 color = tex2D(_MainTex, i.uv) * _Tint;
                return color;
            }
            ENDCG
        }
    }
}
