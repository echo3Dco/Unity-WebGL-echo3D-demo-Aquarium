// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Terrain Add Pass"
{
	Properties
	{
		[HideInInspector]_TerrainHolesTexture("_TerrainHolesTexture", 2D) = "white" {}
		[HideInInspector]_Control("Control", 2D) = "white" {}
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal0", 2D) = "white" {}
		[HideInInspector]_Normal1("Normal1", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal2", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal3", 2D) = "white" {}
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness0("Smoothness0", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 1
		[HideInInspector]_Mask2("_Mask2", 2D) = "white" {}
		[HideInInspector]_Mask0("_Mask0", 2D) = "white" {}
		[HideInInspector]_Mask1("_Mask1", 2D) = "white" {}
		[HideInInspector]_Mask3("_Mask3", 2D) = "white" {}
		_Specular1("Specular1", Color) = (0,0,0,0)
		_Specular3("Specular3", Color) = (0,0,0,0)
		_Specular0("Specular0", Color) = (0,0,0,0)
		_Specular2("Specular2", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-99" "IgnoreProjector"="True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#define TERRAIN_SPLAT_ADDPASS
		#define TERRAIN_STANDARD_SHADER
		#pragma multi_compile_local __ _ALPHATEST_ON
		#pragma shader_feature_local _MASKMAP
		#pragma exclude_renderers gles vulkan 
		#pragma surface surf Standard keepalpha  decal:add
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _MaskMapRemapScale3;
		uniform float4 _MaskMapRemapOffset1;
		uniform float4 _MaskMapRemapScale2;
		uniform float4 _MaskMapRemapScale0;
		uniform float4 _MaskMapRemapOffset3;
		uniform float4 _MaskMapRemapOffset2;
		uniform float4 _MaskMapRemapOffset0;
		uniform float4 _MaskMapRemapScale1;
		uniform sampler2D _Mask0;
		uniform sampler2D _Mask3;
		uniform sampler2D _Mask1;
		uniform sampler2D _Mask2;
		uniform sampler2D _Control;
		uniform float4 _Control_ST;
		uniform sampler2D _Normal0;
		uniform sampler2D _Splat0;
		uniform float4 _Splat0_ST;
		uniform sampler2D _Normal1;
		uniform sampler2D _Splat1;
		uniform float4 _Splat1_ST;
		uniform sampler2D _Normal2;
		uniform sampler2D _Splat2;
		uniform float4 _Splat2_ST;
		uniform sampler2D _Normal3;
		uniform sampler2D _Splat3;
		uniform float4 _Splat3_ST;
		uniform float _Smoothness0;
		uniform float4 _Specular0;
		uniform float _Smoothness1;
		uniform float4 _Specular1;
		uniform float _Smoothness2;
		uniform float4 _Specular2;
		uniform float _Smoothness3;
		uniform float4 _Specular3;
		uniform sampler2D _TerrainHolesTexture;
		uniform float4 _TerrainHolesTexture_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g27 = tex2D( _Control, uv_Control );
			float dotResult20_g27 = dot( tex2DNode5_g27 , float4(1,1,1,1) );
			float SplatWeight22_g27 = dotResult20_g27;
			float localSplatClip74_g27 = ( SplatWeight22_g27 );
			float SplatWeight74_g27 = SplatWeight22_g27;
			{
			#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
				clip(SplatWeight74_g27 == 0.0f ? -1 : 1);
			#endif
			}
			float4 SplatControl26_g27 = ( tex2DNode5_g27 / ( localSplatClip74_g27 + 0.001 ) );
			float4 temp_output_59_0_g27 = SplatControl26_g27;
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar8_g27 = temp_output_59_0_g27;
			float4 weightedBlend8_g27 = ( weightedBlendVar8_g27.x*tex2D( _Normal0, uv_Splat0 ) + weightedBlendVar8_g27.y*tex2D( _Normal1, uv_Splat1 ) + weightedBlendVar8_g27.z*tex2D( _Normal2, uv_Splat2 ) + weightedBlendVar8_g27.w*tex2D( _Normal3, uv_Splat3 ) );
			float3 temp_output_61_0_g27 = UnpackNormal( weightedBlend8_g27 );
			o.Normal = temp_output_61_0_g27;
			float4 appendResult33_g27 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float4 tex2DNode4_g27 = tex2D( _Splat0, uv_Splat0 );
			float4 temp_output_35_0_g27 = ( appendResult33_g27 * tex2DNode4_g27 * _Specular0 );
			float4 break20_g28 = temp_output_59_0_g27;
			float4 lerpResult16_g28 = lerp( float4( 0,0,0,0 ) , temp_output_35_0_g27 , ( break20_g28.r > max( max( break20_g28.g , break20_g28.b ) , break20_g28.a ) ? 1.0 : 0.0 ));
			float4 appendResult36_g27 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float4 tex2DNode3_g27 = tex2D( _Splat1, uv_Splat1 );
			float4 temp_output_38_0_g27 = ( appendResult36_g27 * tex2DNode3_g27 * _Specular1 );
			float4 lerpResult14_g28 = lerp( lerpResult16_g28 , temp_output_38_0_g27 , ( break20_g28.g > max( max( break20_g28.r , break20_g28.b ) , break20_g28.a ) ? 1.0 : 0.0 ));
			float4 appendResult39_g27 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float4 tex2DNode6_g27 = tex2D( _Splat2, uv_Splat2 );
			float4 temp_output_41_0_g27 = ( appendResult39_g27 * tex2DNode6_g27 * _Specular2 );
			float4 lerpResult8_g28 = lerp( lerpResult14_g28 , temp_output_41_0_g27 , ( break20_g28.b > max( max( break20_g28.r , break20_g28.g ) , break20_g28.a ) ? 1.0 : 0.0 ));
			float4 appendResult42_g27 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float4 tex2DNode7_g27 = tex2D( _Splat3, uv_Splat3 );
			float4 temp_output_44_0_g27 = ( appendResult42_g27 * tex2DNode7_g27 * _Specular3 );
			float4 lerpResult13_g28 = lerp( lerpResult8_g28 , temp_output_44_0_g27 , ( break20_g28.a > max( max( break20_g28.r , break20_g28.g ) , break20_g28.b ) ? 1.0 : 0.0 ));
			float4 MixDiffuse28_g27 = saturate( lerpResult13_g28 );
			float4 temp_output_60_0_g27 = MixDiffuse28_g27;
			float4 localClipHoles100_g27 = ( temp_output_60_0_g27 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float holeClipValue99_g27 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			float Hole100_g27 = holeClipValue99_g27;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole100_g27 == 0.0f ? -1 : 1);
			#endif
			}
			o.Albedo = localClipHoles100_g27.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Hidden/TerrainEngine/Splatmap/Diffuse-AddPass"
}
/*ASEBEGIN
Version=18900
63;119.5;938;499;487.5262;39.07833;1.33655;True;False
Node;AmplifyShaderEditor.FunctionNode;58;151.1972,145.2662;Inherit;False;Stylized Four Splat Blend;1;;27;37452fdfb732e1443b7e39720d05b708;2,85,0,102,1;7;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0;False;58;FLOAT;0;False;201;FLOAT;0;False;62;FLOAT;0;False;6;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;19
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;657.0565,40.11808;Float;False;True;-1;2;;0;0;Standard;Distant Lands/Stylized Terrain Add Pass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;-99;True;Opaque;;Geometry;All;12;d3d9;d3d11_9x;d3d11;glcore;gles3;metal;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Hidden/TerrainEngine/Splatmap/Diffuse-AddPass;0;-1;-1;-1;1;IgnoreProjector=True;False;0;0;False;-1;-1;0;False;-1;2;Define;TERRAIN_SPLAT_ADDPASS;False;;Custom;Define;TERRAIN_STANDARD_SHADER;False;;Custom;1;decal:add;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;58;0
WireConnection;0;1;58;14
ASEEND*/
//CHKSM=280732FE9BB8937204F9FE904E5663F86F38CF91