// Upgrade NOTE: upgraded instancing buffer 'DistantLandsStylizedGrass' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Grass"
{
	Properties
	{
		_GrassTexture("Grass Texture", 2D) = "white" {}
		_AlphaClip("Alpha Clip", Float) = 0
		_TopColor("Top Color", Color) = (0.359336,0.8018868,0.5062882,0)
		_BottomColor("Bottom Color", Color) = (0.359336,0.8018868,0.5062882,0)
		_GradientAmount("Gradient Amount", Float) = 0
		_WindScale("Wind Scale", Float) = 0
		_WindSpeed("Wind Speed", Float) = 0
		_WindStrength("Wind Strength", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _WindSpeed;
		uniform float _WindScale;
		uniform float4 _BottomColor;
		uniform float4 _TopColor;
		uniform float _GradientAmount;
		uniform sampler2D _GrassTexture;
		uniform float _AlphaClip;

		UNITY_INSTANCING_BUFFER_START(DistantLandsStylizedGrass)
			UNITY_DEFINE_INSTANCED_PROP(float4, _GrassTexture_ST)
#define _GrassTexture_ST_arr DistantLandsStylizedGrass
			UNITY_DEFINE_INSTANCED_PROP(float3, _WindStrength)
#define _WindStrength_arr DistantLandsStylizedGrass
		UNITY_INSTANCING_BUFFER_END(DistantLandsStylizedGrass)


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 _WindStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_WindStrength_arr, _WindStrength);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime11 = _Time.y * 3.0;
			float2 uv_TexCoord17 = v.texcoord.xy + ( ase_worldPos + ( _WindSpeed * mulTime11 * 3.0 ) ).xy;
			float simpleNoise21 = SimpleNoise( uv_TexCoord17*_WindScale );
			simpleNoise21 = simpleNoise21*2 - 1;
			float4 transform25 = mul(unity_WorldToObject,float4( ( _WindStrength_Instance * simpleNoise21 * v.color.r ) , 0.0 ));
			v.vertex.xyz += transform25.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_cast_0 = (_GradientAmount).xxxx;
			float4 lerpResult40 = lerp( _BottomColor , _TopColor , saturate( pow( i.vertexColor , temp_cast_0 ) ));
			float4 _GrassTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_GrassTexture_ST_arr, _GrassTexture_ST);
			float2 uv_GrassTexture = i.uv_texcoord * _GrassTexture_ST_Instance.xy + _GrassTexture_ST_Instance.zw;
			float4 tex2DNode29 = tex2D( _GrassTexture, uv_GrassTexture );
			clip( tex2DNode29.a - _AlphaClip);
			o.Albedo = ( lerpResult40 * tex2DNode29 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18900
63;120;938;499;2822.658;845.7817;1.836255;True;False
Node;AmplifyShaderEditor.CommentaryNode;35;-1782.613,66.60786;Inherit;False;1507.094;1005.034;Use a noise generator to generate wind;17;37;36;25;18;24;21;23;22;19;20;17;16;15;14;11;12;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1680.661,282.7079;Inherit;False;Property;_WindSpeed;Wind Speed;6;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1706.067,469.8168;Inherit;False;Constant;_FlutterMultiplier;Flutter Multiplier;12;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1680.374,372.7767;Inherit;False;1;0;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-1606.453,120.5224;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1451.369,330.3996;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1306.666,257.3826;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1152.312,252.0274;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;38;-1608.364,-895.8552;Inherit;False;1209.692;839.5466;Color and texture;11;45;32;27;33;40;29;39;1;48;49;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;18;-928.2369,387.4195;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;19;-1271.59,418.6251;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;54;-1517.483,-579.9698;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1419.344,-375.0086;Inherit;False;Property;_GradientAmount;Gradient Amount;4;0;Create;True;0;0;0;False;0;False;0;2.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1497.601,718.4606;Inherit;False;Property;_WindScale;Wind Scale;5;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;23;-1194.742,713.3535;Inherit;False;InstancedProperty;_WindStrength;Wind Strength;7;0;Create;True;0;0;0;False;0;False;0,0,0;0.2,0,0.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;21;-1197.072,463.4114;Inherit;True;Simple;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;22;-1173.989,877.2496;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;49;-1215.528,-468.49;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-1187.32,-863.6912;Inherit;False;Property;_BottomColor;Bottom Color;3;0;Create;True;0;0;0;False;0;False;0.359336,0.8018868,0.5062882,0;0.7450981,0.5882353,0.4588236,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-799.1182,711.2886;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;48;-1054.735,-462.8972;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;39;-1193.598,-700.983;Inherit;False;Property;_TopColor;Top Color;2;0;Create;True;0;0;0;False;0;False;0.359336,0.8018868,0.5062882,0;0.3709377,0.6603774,0.1713242,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;29;-1119.412,-313.6424;Inherit;True;Property;_GrassTexture;Grass Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;dc104d1911e6d194e8ea8d728861d6c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;36;-585.0059,693.1005;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;40;-917.2863,-663.6208;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-780.2438,-336.3596;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;37;-673.2333,541.8539;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-770.0167,-178.9537;Inherit;False;Property;_AlphaClip;Alpha Clip;1;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;32;-601.3452,-323.4284;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;25;-570.4775,398.1627;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Standard;Distant Lands/Stylized Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;13;0
WireConnection;15;1;11;0
WireConnection;15;2;12;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;19;0;18;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;49;0;54;0
WireConnection;49;1;45;0
WireConnection;24;0;23;0
WireConnection;24;1;21;0
WireConnection;24;2;22;1
WireConnection;48;0;49;0
WireConnection;36;0;24;0
WireConnection;40;0;1;0
WireConnection;40;1;39;0
WireConnection;40;2;48;0
WireConnection;27;0;40;0
WireConnection;27;1;29;0
WireConnection;37;0;36;0
WireConnection;32;0;27;0
WireConnection;32;1;29;4
WireConnection;32;2;33;0
WireConnection;25;0;37;0
WireConnection;0;0;32;0
WireConnection;0;11;25;0
ASEEND*/
//CHKSM=B12797F9264E057DF0DE461DC8FC69575663C8B0