// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Stylized Dynamic Coral"
{
	Properties
	{
		[HDR]_TopColor("Top Color", Color) = (0.3160377,1,0.695684,1)
		[HDR]_MainColor("Main Color", Color) = (0.3160377,1,0.695684,1)
		[HDR]_Emmision("Emmision", Color) = (0,0,0,1)
		_MainWaveAmount("Main Wave Amount", Float) = 0.3
		_WaveSpeed("Wave Speed", Float) = 0.5
		_MainWaveScale("Main Wave Scale", Float) = 1
		_GradientSmoothness1("Gradient Smoothness", Float) = 0.5
		_WaveHeightMultiplier("Wave Height Multiplier", Float) = 1
		_FlutterAmount("Flutter Amount", Float) = 0.3
		_GradientOffset1("Gradient Offset", Float) = 0
		_FlutterSpeed("Flutter Speed", Float) = 0.5
		_FlutterScale("Flutter Scale", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _FlutterAmount;
		uniform float _FlutterSpeed;
		uniform float _FlutterScale;
		uniform float _MainWaveAmount;
		uniform float _WaveHeightMultiplier;
		uniform float _WaveSpeed;
		uniform float _MainWaveScale;
		uniform float4 _MainColor;
		uniform float4 _TopColor;
		uniform float _GradientOffset1;
		uniform float _GradientSmoothness1;
		uniform float4 _Emmision;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_59_0 = ( _FlutterSpeed * _Time.y );
			float3 appendResult63 = (float3(temp_output_59_0 , temp_output_59_0 , temp_output_59_0));
			float3 temp_output_64_0 = ( ase_worldPos + appendResult63 );
			float temp_output_62_0 = ( 1.0 / _FlutterScale );
			float simplePerlin3D70 = snoise( temp_output_64_0*temp_output_62_0 );
			float simplePerlin3D69 = snoise( temp_output_64_0*( temp_output_62_0 * 0.5 ) );
			float3 appendResult67 = (float3(simplePerlin3D70 , 0.0 , simplePerlin3D69));
			float4 transform52 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 appendResult51 = (float3(transform52.x , ( ase_vertex3Pos.y * _WaveHeightMultiplier ) , transform52.z));
			float temp_output_36_0 = ( _WaveSpeed * _Time.y );
			float3 appendResult38 = (float3(temp_output_36_0 , temp_output_36_0 , temp_output_36_0));
			float3 temp_output_39_0 = ( appendResult51 + appendResult38 );
			float temp_output_16_0 = ( 1.0 / _MainWaveScale );
			float simplePerlin2D7 = snoise( temp_output_39_0.xy*temp_output_16_0 );
			float simplePerlin3D8 = snoise( temp_output_39_0*( temp_output_16_0 * 0.8 ) );
			float3 appendResult17 = (float3(simplePerlin2D7 , 0.0 , simplePerlin3D8));
			float clampResult42 = clamp( ase_vertex3Pos.y , 0.0 , 100000.0 );
			v.vertex.xyz += ( float4( ( ( _FlutterAmount * appendResult67 ) + ( _MainWaveAmount * float3( 0.01,0.01,0.01 ) * appendResult17 * clampResult42 ) ) , 0.0 ) * v.color ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult44 = lerp( _MainColor , _TopColor , saturate( ( ( ase_vertex3Pos.y - _GradientOffset1 ) * _GradientSmoothness1 ) ));
			o.Albedo = lerpResult44.rgb;
			o.Emission = ( lerpResult44 * _Emmision ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18900
63;120;938;499;2549.012;-353.2474;1.821522;True;False
Node;AmplifyShaderEditor.RangedFloatNode;56;-3033.653,94.50374;Inherit;False;Property;_FlutterSpeed;Flutter Speed;10;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;57;-3038.943,193.6891;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-3044.586,820.4589;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-3215.202,451.1026;Inherit;False;Property;_WaveHeightMultiplier;Wave Height Multiplier;7;0;Create;True;0;0;0;False;0;False;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3055.296,717.2733;Inherit;False;Property;_WaveSpeed;Wave Speed;4;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-3153.426,298.4057;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-2849.276,747.2342;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2822.762,980.9027;Inherit;False;Property;_MainWaveScale;Main Wave Scale;5;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2934.403,432.9028;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2843.634,120.4647;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2752.999,255.4871;Inherit;False;Property;_FlutterScale;Flutter Scale;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;52;-3153.041,537.7037;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;38;-2698.409,711.3109;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;63;-2692.766,84.54134;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;74;-2908.575,-124.0986;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-2517.245,203.3979;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-2734.458,501.2712;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-2522.888,830.1678;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;80;-1049.46,-386.0877;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-2515.125,627.226;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2299.141,840.2739;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2293.499,213.5046;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-2509.482,0.4566422;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1038.036,-207.0047;Inherit;False;Property;_GradientOffset1;Gradient Offset;9;0;Create;True;0;0;0;False;0;False;0;3.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;69;-2072.783,134.6128;Inherit;True;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;-2078.383,504.5795;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;70;-2071.44,-122.19;Inherit;True;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;40;-2044.757,988.7598;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-2078.426,761.3823;Inherit;True;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-885.8349,-83.15372;Inherit;False;Property;_GradientSmoothness1;Gradient Smoothness;6;0;Create;True;0;0;0;False;0;False;0.5;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;83;-819.8279,-270.7678;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-616.1689,-224.9426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1766.963,-91.40085;Inherit;False;Property;_FlutterAmount;Flutter Amount;8;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;42;-1719.654,906.9958;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100000;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1772.606,535.3686;Inherit;False;Property;_MainWaveAmount;Main Wave Amount;3;0;Create;True;0;0;0;False;0;False;0.3;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-1739.742,26.16905;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1745.385,652.9384;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;75;-337.7106,-255.9082;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1503.204,621.0511;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT3;0.01,0.01,0.01;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1;-604.168,-613.8814;Inherit;False;Property;_MainColor;Main Color;1;1;[HDR];Create;True;0;0;0;False;0;False;0.3160377,1,0.695684,1;0.8784314,0.3764706,0.542779,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;-603.7123,-435.2812;Inherit;False;Property;_TopColor;Top Color;0;1;[HDR];Create;True;0;0;0;False;0;False;0.3160377,1,0.695684,1;1,0.6078432,0.6705946,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1497.561,-5.718361;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;2;-527.6379,102.6616;Inherit;False;Property;_Emmision;Emmision;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;87;-491.6965,465.128;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-765.2247,415.536;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;44;-260.8647,-452.5032;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-140.7759,58.37732;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-293.2065,337.0609;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;8.799211,7.152557E-07;Float;False;True;-1;2;;0;0;Standard;Distant Lands/Stylized Dynamic Coral;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;11;0
WireConnection;36;1;9;0
WireConnection;73;0;13;2
WireConnection;73;1;72;0
WireConnection;59;0;56;0
WireConnection;59;1;57;0
WireConnection;38;0;36;0
WireConnection;38;1;36;0
WireConnection;38;2;36;0
WireConnection;63;0;59;0
WireConnection;63;1;59;0
WireConnection;63;2;59;0
WireConnection;62;1;71;0
WireConnection;51;0;52;1
WireConnection;51;1;73;0
WireConnection;51;2;52;3
WireConnection;16;1;14;0
WireConnection;39;0;51;0
WireConnection;39;1;38;0
WireConnection;15;0;16;0
WireConnection;65;0;62;0
WireConnection;64;0;74;0
WireConnection;64;1;63;0
WireConnection;69;0;64;0
WireConnection;69;1;65;0
WireConnection;7;0;39;0
WireConnection;7;1;16;0
WireConnection;70;0;64;0
WireConnection;70;1;62;0
WireConnection;8;0;39;0
WireConnection;8;1;15;0
WireConnection;83;0;80;2
WireConnection;83;1;81;0
WireConnection;84;0;83;0
WireConnection;84;1;82;0
WireConnection;42;0;40;2
WireConnection;67;0;70;0
WireConnection;67;2;69;0
WireConnection;17;0;7;0
WireConnection;17;2;8;0
WireConnection;75;0;84;0
WireConnection;18;0;4;0
WireConnection;18;2;17;0
WireConnection;18;3;42;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;19;0;68;0
WireConnection;19;1;18;0
WireConnection;44;0;1;0
WireConnection;44;1;43;0
WireConnection;44;2;75;0
WireConnection;85;0;44;0
WireConnection;85;1;2;0
WireConnection;86;0;19;0
WireConnection;86;1;87;0
WireConnection;0;0;44;0
WireConnection;0;2;85;0
WireConnection;0;11;86;0
ASEEND*/
//CHKSM=F6D9509EA61890ACDA882904726334562C93174A