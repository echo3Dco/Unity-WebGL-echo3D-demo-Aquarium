// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Coral"
{
	Properties
	{
		[HDR]_TopColor1("Top Color", Color) = (0.3160377,1,0.695684,1)
		[HDR]_MainColor1("Main Color", Color) = (0.3160377,1,0.695684,1)
		[HDR]_Emmision1("Emmision", Color) = (0,0,0,1)
		_GradientSmoothness2("Gradient Smoothness", Float) = 0.5
		_GradientOffset2("Gradient Offset", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _MainColor1;
		uniform float4 _TopColor1;
		uniform float _GradientOffset2;
		uniform float _GradientSmoothness2;
		uniform float4 _Emmision1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult9 = lerp( _MainColor1 , _TopColor1 , saturate( ( ( distance( ase_vertex3Pos , float3( 0,0,0 ) ) - _GradientOffset2 ) * _GradientSmoothness2 ) ));
			o.Albedo = lerpResult9.rgb;
			o.Emission = ( lerpResult9 * _Emmision1 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18900
63;120;938;499;2395.06;1109.614;2.875728;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;2;-1486.615,-396.1531;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1;-1246.898,-141.6702;Inherit;False;Property;_GradientOffset2;Gradient Offset;4;0;Create;True;0;0;0;False;0;False;0;0.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;13;-1239.925,-299.0639;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-1028.69,-205.4333;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1094.697,-17.81927;Inherit;False;Property;_GradientSmoothness2;Gradient Smoothness;3;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-825.0306,-159.6081;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;-546.5723,-190.5737;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-813.0297,-548.547;Inherit;False;Property;_MainColor1;Main Color;1;1;[HDR];Create;True;0;0;0;False;0;False;0.3160377,1,0.695684,1;0.5960784,0.1963533,0.1333333,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-809.0175,-369.9467;Inherit;False;Property;_TopColor1;Top Color;0;1;[HDR];Create;True;0;0;0;False;0;False;0.3160377,1,0.695684,1;1,0.5330188,0.5986881,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;9;-469.7264,-387.1688;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;10;-736.4996,167.996;Inherit;False;Property;_Emmision1;Emmision;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-312.3885,67.83826;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Standard;Distant Lands/Stylized Coral;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;2;0
WireConnection;3;0;13;0
WireConnection;3;1;1;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;6;0;5;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;9;2;6;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;0;0;9;0
WireConnection;0;2;11;0
ASEEND*/
//CHKSM=DED2329E230C8B064D68132FE00BA340481BAD07