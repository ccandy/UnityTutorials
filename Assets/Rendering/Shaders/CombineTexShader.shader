Shader "Andy/TextureSplatting"
{
    Properties
    {
        _MainTex	("Splat Map", 2D)	= "white"	{}
		[NoScaleOffset] _Texture1	("Texture 1", 2D)	= "white"	{}
		[NoScaleOffset] _Texture2	("Texture 2", 2D)	= "white"	{}
		[NoScaleOffset] _Texture3	("Texture 3", 2D)	= "white"	{}
		[NoScaleOffset] _Texture4	("Texture 4", 2D)	= "white"	{}
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

			sampler2D	_MainTex,_Texture1,_Texture2,_Texture3,_Texture4;
			float4		_MainTex_ST,_Texture1_ST, _Texture2_ST;

			struct Interpolators{
				float4 position			:SV_POSITION;
				float2 uv				:TEXCOORD0;
				float2 uvSplat			:TEXCOORD1;
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
				i.uvSplat		= v.uv;
				return i;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_Target
            {
				float4 Splat	= tex2D(_MainTex, i.uvSplat);
                return tex2D(_Texture1, i.uv) * Splat.r + 
					   tex2D(_Texture2, i.uv) * Splat.g + 
					   tex2D(_Texture3, i.uv) * Splat.b +
					   (1 - Splat.r - Splat.g - Splat.b) * tex2D(_Texture4, i.uv) ;
            }
            ENDCG
        }
    }
}
