//UNITY_SHADER_NO_UPGRADE

Shader "Unlit/WaveShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;	

			struct vertIn
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct vertOut
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			// Implementation of the vertex shader
			vertOut vert(vertIn v)
			{
				// Displace the original vertex in model space

				// Up/Down oscilation
				//float4 displacement = float4(0.0f, sin(_Time.y), 0.0f, 0.0f);
				
				// Stationary wave
				//float4 displacement = float4(0.0f, sin(v.vertex.x), 0.0f, 0.0f);
				
				// Animated wave
				//float4 displacement = float4(0.0f, sin(v.vertex.x + (_Time.y)), 0.0f, 0.0f);
				// To make faster, multiply stuff inside the sin
				// To change height, multiply sin itself
				
				// Animated wave - Increasing speed
				//float4 displacement = float4(0.0f, sin(v.vertex.x + (_Time.y * _Time.y)), 0.0f, 0.0f);

				// Displacement based on World position

				//v.vertex += displacement;

				vertOut o;
				//o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

				// Eliminates V, puts wave right in your face
				//o.vertex = mul(mul(UNITY_MATRIX_P, unity_ObjectToWorld), v.vertex);
				// Culled when bounding box isn't in view, so can''t always see

				// Relativity - makes wave relative to view space
				/*
				o.vertex = mul(UNITY_MATRIX_MV, v.vertex);
				o.vertex += displacement;
				o.vertex = mul(UNITY_MATRIX_P, o.vertex);
				*/
				// To make work, comment out "v.vertex += displacement;"
				//							 "o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);"

				// Displacement based on World position
				o.vertex = mul(UNITY_MATRIX_M, v.vertex);
				o.vertex += float4(0.0f, sin(o.vertex.x - o.vertex.z + (_Time.y/2))/2 - sin(o.vertex.z + (_Time.y))/4, 0.0f, 0.0f);;
				o.vertex = mul(UNITY_MATRIX_VP, o.vertex);

				o.uv = v.uv;
				return o;
			}
			
			// Implementation of the fragment shader
			fixed4 frag(vertOut v) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, v.uv);
				return col;
			}
			ENDCG
		}
	}
}