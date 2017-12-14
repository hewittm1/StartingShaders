Shader "Custom/WaterRippleEffect" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		
		//speed of each wave
		_Speed ("Speed", float) = 1
		//how frequent the waves are
		_Frequency ("Frequency", float) = 1
		//size/scale of the waves
		_Scale ("Scale", float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert
		
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _Scale, _Speed, _Frequency;
		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;

		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END
		void vert(inout appdata_full v){
			//value for offset is equal to the x vertex of object
			half offsetVert = ((v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z) + (v.vertex.y * v.vertex.y));
			//algorithm for the wave simulation
			half value = _Scale * sin(_Time.w * _Speed + offsetVert * _Frequency);
			v.vertex.y += value;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
