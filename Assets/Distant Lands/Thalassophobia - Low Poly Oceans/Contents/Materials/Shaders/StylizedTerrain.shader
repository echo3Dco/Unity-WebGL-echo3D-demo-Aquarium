// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Nature/Terrain/StylizedTerrain"
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
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#pragma multi_compile_local __ _ALPHATEST_ON
		#pragma shader_feature_local _MASKMAP
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _MaskMapRemapScale1;
		uniform sampler2D _Mask0;
		uniform sampler2D _Mask2;
		uniform sampler2D _Mask1;
		uniform sampler2D _Mask3;
		uniform float4 _MaskMapRemapOffset2;
		uniform float4 _MaskMapRemapOffset3;
		uniform float4 _MaskMapRemapOffset0;
		uniform float4 _MaskMapRemapScale0;
		uniform float4 _MaskMapRemapScale3;
		uniform float4 _MaskMapRemapOffset1;
		uniform float4 _MaskMapRemapScale2;
		#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
			sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
			sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
		#endif//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
			UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
		CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
				float4 _TerrainHeightmapScale;//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
		CBUFFER_END//ASE Terrain Instancing
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


		void ApplyMeshModification( inout appdata_full v )
		{
			#if defined(UNITY_INSTANCING_ENABLED) && !defined(SHADER_API_D3D11_9X)
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);
				
				float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
				float4 uvoffset = instanceData.xyxy * uvscale;
				uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
				float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
				
				float hm = UnpackHeightmap(tex2Dlod(_TerrainHeightmapTexture, float4(sampleCoords, 0, 0)));
				v.vertex.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
				v.vertex.y = hm * _TerrainHeightmapScale.y;
				v.vertex.w = 1.0f;
				
				v.texcoord.xy = (patchVertex.xy * uvscale.zw + uvoffset.zw);
				v.texcoord3 = v.texcoord2 = v.texcoord1 = v.texcoord;
				
				#ifdef TERRAIN_INSTANCED_PERPIXEL_NORMAL
					v.normal = float3(0, 1, 0);
					//data.tc.zw = sampleCoords;
				#else
					float3 nor = tex2Dlod(_TerrainNormalmapTexture, float4(sampleCoords, 0, 0)).xyz;
					v.normal = 2.0f * nor - 1.0f;
				#endif
			#endif
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			ApplyMeshModification(v);;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g13 = tex2D( _Control, uv_Control );
			float dotResult20_g13 = dot( tex2DNode5_g13 , float4(1,1,1,1) );
			float SplatWeight22_g13 = dotResult20_g13;
			float localSplatClip74_g13 = ( SplatWeight22_g13 );
			float SplatWeight74_g13 = SplatWeight22_g13;
			{
			#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
				clip(SplatWeight74_g13 == 0.0f ? -1 : 1);
			#endif
			}
			float4 SplatControl26_g13 = ( tex2DNode5_g13 / ( localSplatClip74_g13 + 0.001 ) );
			float4 temp_output_59_0_g13 = SplatControl26_g13;
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar8_g13 = temp_output_59_0_g13;
			float4 weightedBlend8_g13 = ( weightedBlendVar8_g13.x*tex2D( _Normal0, uv_Splat0 ) + weightedBlendVar8_g13.y*tex2D( _Normal1, uv_Splat1 ) + weightedBlendVar8_g13.z*tex2D( _Normal2, uv_Splat2 ) + weightedBlendVar8_g13.w*tex2D( _Normal3, uv_Splat3 ) );
			float3 temp_output_61_0_g13 = UnpackNormal( weightedBlend8_g13 );
			o.Normal = temp_output_61_0_g13;
			float4 appendResult33_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float4 tex2DNode4_g13 = tex2D( _Splat0, uv_Splat0 );
			float4 temp_output_35_0_g13 = ( appendResult33_g13 * tex2DNode4_g13 * _Specular0 );
			float4 break20_g14 = temp_output_59_0_g13;
			float4 lerpResult16_g14 = lerp( float4( 0,0,0,0 ) , temp_output_35_0_g13 , ( break20_g14.r > max( max( break20_g14.g , break20_g14.b ) , break20_g14.a ) ? 1.0 : 0.0 ));
			float4 appendResult36_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float4 tex2DNode3_g13 = tex2D( _Splat1, uv_Splat1 );
			float4 temp_output_38_0_g13 = ( appendResult36_g13 * tex2DNode3_g13 * _Specular1 );
			float4 lerpResult14_g14 = lerp( lerpResult16_g14 , temp_output_38_0_g13 , ( break20_g14.g > max( max( break20_g14.r , break20_g14.b ) , break20_g14.a ) ? 1.0 : 0.0 ));
			float4 appendResult39_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float4 tex2DNode6_g13 = tex2D( _Splat2, uv_Splat2 );
			float4 temp_output_41_0_g13 = ( appendResult39_g13 * tex2DNode6_g13 * _Specular2 );
			float4 lerpResult8_g14 = lerp( lerpResult14_g14 , temp_output_41_0_g13 , ( break20_g14.b > max( max( break20_g14.r , break20_g14.g ) , break20_g14.a ) ? 1.0 : 0.0 ));
			float4 appendResult42_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float4 tex2DNode7_g13 = tex2D( _Splat3, uv_Splat3 );
			float4 temp_output_44_0_g13 = ( appendResult42_g13 * tex2DNode7_g13 * _Specular3 );
			float4 lerpResult13_g14 = lerp( lerpResult8_g14 , temp_output_44_0_g13 , ( break20_g14.a > max( max( break20_g14.r , break20_g14.g ) , break20_g14.b ) ? 1.0 : 0.0 ));
			float4 MixDiffuse28_g13 = saturate( lerpResult13_g14 );
			float4 temp_output_60_0_g13 = MixDiffuse28_g13;
			float4 localClipHoles100_g13 = ( temp_output_60_0_g13 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float holeClipValue99_g13 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			float Hole100_g13 = holeClipValue99_g13;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole100_g13 == 0.0f ? -1 : 1);
			#endif
			}
			o.Albedo = localClipHoles100_g13.xyz;
			o.Alpha = 1;
		}

		ENDCG
		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
		UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
	}

	Dependency "BaseMapShader"="ASESampleShaders/SimpleTerrainBase"
	Dependency "AddPassShader"="ASESampleShaders/Terrain/SimpleTerrainAddPass"
	Fallback "Nature/Terrain/Diffuse"
}
/*ASEBEGIN
Version=18900
34;141.5;938;507;1340.785;237.4538;1.762053;True;False
Node;AmplifyShaderEditor.FunctionNode;6;-602.3495,40.77017;Inherit;False;Four Splats First Pass Terrain;1;;13;37452fdfb732e1443b7e39720d05b708;2,102,1,85,0;7;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0;False;58;FLOAT;0;False;201;FLOAT;0;False;62;FLOAT;0;False;6;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;19
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Standard;Nature/Terrain/StylizedTerrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Nature/Terrain/Diffuse;0;-1;-1;-1;0;False;2;BaseMapShader=ASESampleShaders/SimpleTerrainBase;AddPassShader=ASESampleShaders/Terrain/SimpleTerrainAddPass;0;False;-1;-1;0;False;-1;0;0;0;True;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;6;0
WireConnection;0;1;6;14
ASEEND*/
//CHKSM=57F6DC450C0789CAE4558999237E4AE40846DCE4