// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Fish"
{
	Properties
	{
		_Atlas("Atlas", 2D) = "white" {}
		_WaveAmount("Wave Amount", Vector) = (0,0,0,0)
		_TimeScale("Time Scale", Vector) = (1,1,0,0)
		_WaveWidth("Wave Width", Vector) = (1,1,0,0)
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float2 _WaveWidth;
		uniform float2 _TimeScale;
		uniform float2 _WaveAmount;
		uniform sampler2D _Atlas;
		uniform float4 _Atlas_ST;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_58_0 = abs( ase_vertex3Pos.z );
			float mulTime39 = _Time.y * _TimeScale.x;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 temp_output_40_0 = ( ( ase_objectScale * float3( 50,50,50 ) ) + ( 0.0 - temp_output_58_0 ) );
			float3 rotatedValue64 = RotateAroundAxis( float3( 0,0,0 ), ase_vertex3Pos, float3(0,1,0), ( temp_output_58_0 * sin( ( _WaveWidth.x * ( mulTime39 + temp_output_40_0 ) ) ) * _WaveAmount.x ).x );
			float mulTime70 = _Time.y * _TimeScale.y;
			float3 rotatedValue60 = RotateAroundAxis( float3( 0,0,0 ), ase_vertex3Pos, float3(0,0,1), ( _WaveAmount.y * sin( ( _WaveWidth.y * ( mulTime70 + temp_output_40_0 ) ) ) * temp_output_58_0 ).x );
			v.vertex.xyz += ( ( rotatedValue64 - ase_vertex3Pos ) + ( rotatedValue60 - ase_vertex3Pos ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Atlas = i.uv_texcoord * _Atlas_ST.xy + _Atlas_ST.zw;
			o.Albedo = tex2D( _Atlas, uv_Atlas ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18900
63;120;938;499;3700.602;24.36014;2.033531;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;57;-2464.412,554.4866;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;58;-2163.037,614.3812;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;100;-3013.864,408.2064;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-1931.231,563.1789;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-2775.346,436.2346;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;50,50,50;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;69;-2870.066,125.9111;Inherit;False;Property;_TimeScale;Time Scale;2;0;Create;True;0;0;0;False;0;False;1,1;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-2587.381,414.852;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;39;-2657.47,152.2212;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;70;-2649.144,266.4988;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2384.684,326.8318;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;72;-2454.153,-10.72937;Inherit;False;Property;_WaveWidth;Wave Width;3;0;Create;True;0;0;0;False;0;False;1,1;5,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-2381.033,197.1991;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2211.728,170.4665;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2210.905,303.0765;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;63;-2036.31,24.49496;Inherit;False;Property;_WaveAmount;Wave Amount;1;0;Create;True;0;0;0;False;0;False;0,0;0.2,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SinOpNode;41;-1997.862,196.7075;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;71;-2012.501,301.1081;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1623.579,223.5644;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;53;-1637.805,-107.3212;Inherit;False;Constant;_Y;Y;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1621.844,346.3925;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;61;-1644.046,70.84964;Inherit;False;Constant;_Z;Z;2;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;79;-1215.066,664.2933;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotateAboutAxisNode;64;-1311.251,230.9231;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;60;-1296.151,476.0071;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;77;-908.5732,472.3282;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;80;-881.6181,313.3759;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-662.6967,372.7485;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;33;-481.4517,-216.4754;Inherit;True;Property;_Atlas;Atlas;0;0;Create;True;0;0;0;False;0;False;-1;None;1a68ea239630eef47b731649a5f85f42;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Standard;Distant Lands/Stylized Fish;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;57;3
WireConnection;59;1;58;0
WireConnection;101;0;100;0
WireConnection;40;0;101;0
WireConnection;40;1;59;0
WireConnection;39;0;69;1
WireConnection;70;0;69;2
WireConnection;68;0;70;0
WireConnection;68;1;40;0
WireConnection;67;0;39;0
WireConnection;67;1;40;0
WireConnection;74;0;72;1
WireConnection;74;1;67;0
WireConnection;75;0;72;2
WireConnection;75;1;68;0
WireConnection;41;0;74;0
WireConnection;71;0;75;0
WireConnection;51;0;58;0
WireConnection;51;1;41;0
WireConnection;51;2;63;1
WireConnection;65;0;63;2
WireConnection;65;1;71;0
WireConnection;65;2;58;0
WireConnection;64;0;53;0
WireConnection;64;1;51;0
WireConnection;64;3;57;0
WireConnection;60;0;61;0
WireConnection;60;1;65;0
WireConnection;60;3;57;0
WireConnection;77;0;60;0
WireConnection;77;1;79;0
WireConnection;80;0;64;0
WireConnection;80;1;79;0
WireConnection;66;0;80;0
WireConnection;66;1;77;0
WireConnection;0;0;33;0
WireConnection;0;11;66;0
ASEEND*/
//CHKSM=F11B079C80D463C22A3DF35203C5E1E17C243A67