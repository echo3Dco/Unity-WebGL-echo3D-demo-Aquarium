// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Fog"
{
	Properties
	{
		[HDR]_FogColor1("Fog Color 1", Color) = (1,0,0.8999224,1)
		[HDR]_FogColor2("Fog Color 2", Color) = (1,0,0,1)
		[HDR]_FogColor3("Fog Color 3", Color) = (1,0,0.7469492,1)
		[HDR]_FogColor4("Fog Color 4", Color) = (0,0.8501792,1,1)
		[HDR]_FogColor5("Fog Color 5", Color) = (0.164721,0,1,1)
		_ColorStart1("Color Start 1", Float) = 1
		_ColorStart2("Color Start 2", Float) = 2
		_ColorStart3("Color Start 3", Float) = 3
		_ColorStart4("Color Start 4", Float) = 4
		_FogDepthMultiplier("Fog Depth Multiplier", Float) = 1
		_LightFalloff("Light Falloff", Float) = 1
		LightIntensity("Light Intensity", Float) = 0
		[HDR]_LightColor("Light Color", Color) = (0,0,0,0)
		_FogSmoothness("Fog Smoothness", Float) = 0
		_FogIntensity("Fog Intensity", Float) = 1
		_FogOffset("Fog Offset", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "HeightFog"  "Queue" = "Transparent+1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float4 _FogColor1;
		uniform float4 _FogColor2;
		uniform float _FogDepthMultiplier;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _ColorStart1;
		uniform float4 _FogColor3;
		uniform float _ColorStart2;
		uniform float4 _FogColor4;
		uniform float _ColorStart3;
		uniform float4 _FogColor5;
		uniform float _ColorStart4;
		uniform float4 _LightColor;
		uniform half LightIntensity;
		uniform half _LightFalloff;
		uniform float _FogSmoothness;
		uniform float _FogOffset;
		uniform float _FogIntensity;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor16 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPos.xy/ase_grabScreenPos.w);
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float eyeDepth80 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float temp_output_102_0 = ( _FogDepthMultiplier * sqrt( eyeDepth80 ) );
			float temp_output_1_0_g1 = temp_output_102_0;
			float4 lerpResult28_g1 = lerp( _FogColor1 , _FogColor2 , saturate( ( temp_output_1_0_g1 / _ColorStart1 ) ));
			float4 lerpResult41_g1 = lerp( saturate( lerpResult28_g1 ) , _FogColor3 , saturate( ( ( _ColorStart1 - temp_output_1_0_g1 ) / ( _ColorStart1 - _ColorStart2 ) ) ));
			float4 lerpResult35_g1 = lerp( lerpResult41_g1 , _FogColor4 , saturate( ( ( _ColorStart2 - temp_output_1_0_g1 ) / ( _ColorStart2 - _ColorStart3 ) ) ));
			float4 lerpResult113_g1 = lerp( lerpResult35_g1 , _FogColor5 , saturate( ( ( _ColorStart3 - temp_output_1_0_g1 ) / ( _ColorStart3 - _ColorStart4 ) ) ));
			float4 temp_output_81_0 = lerpResult113_g1;
			float3 hsvTorgb108 = RGBToHSV( _LightColor.rgb );
			float3 hsvTorgb113 = RGBToHSV( temp_output_81_0.rgb );
			float3 hsvTorgb110 = HSVToRGB( float3(hsvTorgb108.x,hsvTorgb108.y,( hsvTorgb108.z * hsvTorgb113.z )) );
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult84 = normalize( ( ase_worldPos - _WorldSpaceCameraPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult83 = dot( normalizeResult84 , ase_worldlightDir );
			half LightMask95 = saturate( pow( abs( ( (dotResult83*0.5 + 0.5) * LightIntensity ) ) , _LightFalloff ) );
			float temp_output_52_0 = ( temp_output_81_0.a * saturate( temp_output_102_0 ) );
			float4 lerpResult97 = lerp( temp_output_81_0 , float4( hsvTorgb110 , 0.0 ) , saturate( ( LightMask95 * ( 1.5 * temp_output_52_0 ) ) ));
			float4 lerpResult17 = lerp( screenColor16 , lerpResult97 , temp_output_52_0);
			o.Emission = lerpResult17.rgb;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			o.Alpha = saturate( ( ( 1.0 - saturate( ( ( ase_vertex3Pos.y * ( 1.0 / _FogSmoothness ) ) + ( 1.0 - _FogOffset ) ) ) ) * _FogIntensity ) );
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=18900
63;119.5;938;499;2826.981;859.7094;2.472507;True;False
Node;AmplifyShaderEditor.WorldSpaceCameraPos;92;-2246.261,1601.184;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;96;-2209.292,1412.168;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;-1911.576,1516.382;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;101;-1783.511,1737.381;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;84;-1719.576,1516.382;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;83;-1399.576,1516.382;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1206.149,1644.382;Half;False;Property;LightIntensity;Light Intensity;12;0;Create;False;0;0;0;False;0;False;0;1.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;94;-1196.111,1506.661;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;80;-2937.401,-36.85109;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-2740.819,-168.4445;Inherit;False;Property;_FogDepthMultiplier;Fog Depth Multiplier;10;0;Create;True;0;0;0;False;0;False;1;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;27;-2631.441,-32.15002;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-887.5762,1516.382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;90;-695.5763,1516.382;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-765.2436,1720.628;Half;False;Property;_LightFalloff;Light Falloff;11;0;Create;True;0;0;0;False;0;False;1;6.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-2382.038,-48.60735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2108.887,971.3538;Inherit;False;Property;_FogSmoothness;Fog Smoothness;14;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;85;-404.4603,1523.738;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;81;-2185.939,-143.7237;Inherit;False;Simple Gradient;0;;1;ece53c110c682694c8953a12e134178f;0;1;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-2069.908,730.2038;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-1866.167,941.8475;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;100;-162.1658,1529.244;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;23;-1672.381,289.1757;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;53;-1615.791,37.16594;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;12;-1762.906,1092.643;Inherit;False;Property;_FogOffset;Fog Offset;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;98;-2195.164,-643.988;Inherit;False;Property;_LightColor;Light Color;13;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.509804,1.498039,1.184381,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;95.53743,1472.42;Half;False;LightMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-1596.082,1051.347;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1684.825,893.2972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1449.165,200.9864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;113;-1831.675,-348.8723;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-1395.179,83.85851;Inherit;False;2;2;0;FLOAT;1.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;108;-1842.9,-559.7668;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1519.154,-87.30054;Inherit;False;95;LightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1424.935,890.2433;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1496.468,-320.508;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-1284.269,-19.74319;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;8;-1178.608,898.4158;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-989.9459,1183.116;Inherit;False;Property;_FogIntensity;Fog Intensity;15;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;110;-1251.211,-401.89;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;105;-1132.285,-51.73991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-994.2161,895.1584;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;97;-973.3299,-203.4272;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;16;-939.0598,-574.9932;Inherit;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-786.5247,896.6517;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;-487.8733,817.4925;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-662.6947,-105.6563;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Unlit;Distant Lands/Stylized Fog;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Front;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0.5;True;False;1;True;Custom;HeightFog;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;16;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;87;0;96;0
WireConnection;87;1;92;0
WireConnection;84;0;87;0
WireConnection;83;0;84;0
WireConnection;83;1;101;0
WireConnection;94;0;83;0
WireConnection;27;0;80;0
WireConnection;88;0;94;0
WireConnection;88;1;89;0
WireConnection;90;0;88;0
WireConnection;102;0;103;0
WireConnection;102;1;27;0
WireConnection;85;0;90;0
WireConnection;85;1;91;0
WireConnection;81;1;102;0
WireConnection;15;1;9;0
WireConnection;100;0;85;0
WireConnection;23;0;102;0
WireConnection;53;0;81;0
WireConnection;95;0;100;0
WireConnection;26;0;12;0
WireConnection;7;0;1;2
WireConnection;7;1;15;0
WireConnection;52;0;53;3
WireConnection;52;1;23;0
WireConnection;113;0;81;0
WireConnection;107;1;52;0
WireConnection;108;0;98;0
WireConnection;13;0;7;0
WireConnection;13;1;26;0
WireConnection;111;0;108;3
WireConnection;111;1;113;3
WireConnection;104;0;99;0
WireConnection;104;1;107;0
WireConnection;8;0;13;0
WireConnection;110;0;108;1
WireConnection;110;1;108;2
WireConnection;110;2;111;0
WireConnection;105;0;104;0
WireConnection;4;0;8;0
WireConnection;97;0;81;0
WireConnection;97;1;110;0
WireConnection;97;2;105;0
WireConnection;6;0;4;0
WireConnection;6;1;10;0
WireConnection;19;0;6;0
WireConnection;17;0;16;0
WireConnection;17;1;97;0
WireConnection;17;2;52;0
WireConnection;0;2;17;0
WireConnection;0;9;19;0
ASEEND*/
//CHKSM=469F91D0E2A2D32C1A3EB27B48C589230AEAEA26