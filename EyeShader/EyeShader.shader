// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/EyeShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Specular("Specular", Range( 0 , 1)) = 0.08
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_Normal("Normal", 2D) = "bump" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		_EmissiveMask("Emissive Mask", 2D) = "white" {}
		_FlowSpeed("Flow Speed", Float) = 0.2
		_FlowStrength("Flow Strength", Vector) = (0.1,0.1,0,0)
		_AudioLinkIntensity("AudioLink Intensity", Range( 0 , 3)) = 1
		_VideoLerp("Video Lerp", Range( 0 , 1)) = 0
		_VideoIntensity("Video Intensity", Range( 1 , 7)) = 1
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  "LTCGI"="ALWAYS" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#include "Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc"
		#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv2_texcoord2;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _Smoothness;
		uniform float _Specular;
		uniform sampler2D _EmissiveMask;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float2 _FlowStrength;
		uniform float _FlowSpeed;
		uniform float _AudioLinkIntensity;
		uniform sampler2D _Udon_VideoTex;
		float4 _Udon_VideoTex_TexelSize;
		uniform float _VideoIntensity;
		uniform float _VideoLerp;


		float IfAudioLinkv2Exists1_g128(  )
		{
			int w = 0; 
			int h; 
			int res = 0;
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS
			_AudioTexture.GetDimensions(w, h); 
			#endif
			if (w == 128) res = 1;
			return res;
		}


		inline float AudioLinkLerp3_g125( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g127( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g121( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g123( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode160 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = tex2DNode160.rgb;
			float localLTCGI15_g129 = ( 0.0 );
			float3 ase_worldPos = i.worldPos;
			float3 worldPos15_g129 = ase_worldPos;
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 normalizeResult9_g129 = normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _Normal, uv_Normal ) ) )) );
			float3 worldNorm15_g129 = normalizeResult9_g129;
			float3 normalizeResult12_g129 = normalize( ( _WorldSpaceCameraPos - ase_worldPos ) );
			float3 cameraDir15_g129 = normalizeResult12_g129;
			float roughness15_g129 = ( 1.0 - _Smoothness );
			float2 lightmapUV15_g129 = i.uv2_texcoord2;
			float3 diffuse15_g129 = float3( 0,0,0 );
			float3 specular15_g129 = float3( 0,0,0 );
			float specularIntensity15_g129 = 0;
			{
			LTCGI_Contribution(worldPos15_g129, worldNorm15_g129, cameraDir15_g129, roughness15_g129, lightmapUV15_g129, diffuse15_g129, specular15_g129, specularIntensity15_g129);
			}
			float2 temp_output_4_0_g130 = (( i.uv_texcoord / 1.0 )).xy;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 temp_output_17_0_g130 = _FlowStrength;
			float mulTime22_g130 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g130 = frac( mulTime22_g130 );
			float2 temp_output_11_0_g130 = ( temp_output_4_0_g130 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g130 * temp_output_27_0_g130 ) );
			float2 temp_output_12_0_g130 = ( temp_output_4_0_g130 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g130 * frac( ( mulTime22_g130 + 0.5 ) ) ) );
			float4 lerpResult9_g130 = lerp( tex2D( _EmissiveMask, temp_output_11_0_g130 ) , tex2D( _EmissiveMask, temp_output_12_0_g130 ) , ( abs( ( temp_output_27_0_g130 - 0.5 ) ) / 0.5 ));
			float localIfAudioLinkv2Exists1_g128 = IfAudioLinkv2Exists1_g128();
			int Band3_g125 = (int)0.0;
			float temp_output_16_0_g119 = 1.0;
			float2 temp_output_34_0_g119 = float2( 1,0 );
			float2 break16_g124 = temp_output_34_0_g119;
			float Delay3_g125 = ( temp_output_16_0_g119 * ( ( i.uv_texcoord.x * break16_g124.x ) + ( i.uv_texcoord.y * break16_g124.y ) ) );
			float localAudioLinkLerp3_g125 = AudioLinkLerp3_g125( Band3_g125 , Delay3_g125 );
			float4 color21_g119 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			int Band3_g127 = (int)1.0;
			float2 break16_g126 = temp_output_34_0_g119;
			float Delay3_g127 = ( temp_output_16_0_g119 * ( ( i.uv_texcoord.x * break16_g126.x ) + ( i.uv_texcoord.y * break16_g126.y ) ) );
			float localAudioLinkLerp3_g127 = AudioLinkLerp3_g127( Band3_g127 , Delay3_g127 );
			float4 color27_g119 = IsGammaSpace() ? float4(1,0.5767992,0,0) : float4(1,0.2921353,0,0);
			int Band3_g121 = (int)2.0;
			float2 break16_g120 = temp_output_34_0_g119;
			float Delay3_g121 = ( temp_output_16_0_g119 * ( ( i.uv_texcoord.x * break16_g120.x ) + ( i.uv_texcoord.y * break16_g120.y ) ) );
			float localAudioLinkLerp3_g121 = AudioLinkLerp3_g121( Band3_g121 , Delay3_g121 );
			float4 color28_g119 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
			int Band3_g123 = (int)3.0;
			float2 break16_g122 = temp_output_34_0_g119;
			float Delay3_g123 = ( temp_output_16_0_g119 * ( ( i.uv_texcoord.x * break16_g122.x ) + ( i.uv_texcoord.y * break16_g122.y ) ) );
			float localAudioLinkLerp3_g123 = AudioLinkLerp3_g123( Band3_g123 , Delay3_g123 );
			float4 color29_g119 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
			float2 temp_output_4_0_g118 = (( i.uv_texcoord / 1.0 )).xy;
			float2 temp_output_17_0_g118 = _FlowStrength;
			float mulTime22_g118 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g118 = frac( mulTime22_g118 );
			float2 temp_output_11_0_g118 = ( temp_output_4_0_g118 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g118 * temp_output_27_0_g118 ) );
			float2 temp_output_12_0_g118 = ( temp_output_4_0_g118 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g118 * frac( ( mulTime22_g118 + 0.5 ) ) ) );
			float4 lerpResult9_g118 = lerp( tex2D( _Udon_VideoTex, temp_output_11_0_g118 ) , tex2D( _Udon_VideoTex, temp_output_12_0_g118 ) , ( abs( ( temp_output_27_0_g118 - 0.5 ) ) / 0.5 ));
			float4 lerpResult195 = lerp( ( ( localIfAudioLinkv2Exists1_g128 * min( ( ( localAudioLinkLerp3_g125 * color21_g119 ) + ( localAudioLinkLerp3_g127 * color27_g119 ) + ( localAudioLinkLerp3_g121 * color28_g119 ) + ( localAudioLinkLerp3_g123 * color29_g119 ) ) , float4( 1,1,1,0 ) ) ) * _AudioLinkIntensity ) , ( ( _Udon_VideoTex_TexelSize.z > 16.0 ? lerpResult9_g118 : float4( 0,0,0,0 ) ) * _VideoIntensity ) , _VideoLerp);
			o.Emission = ( ( tex2DNode160 * float4( diffuse15_g129 , 0.0 ) ) + float4( ( specular15_g129 * specularIntensity15_g129 * _Specular ) , 0.0 ) + ( lerpResult9_g130 * lerpResult195 ) ).rgb;
			float temp_output_204_0 = _Specular;
			float3 temp_cast_10 = (temp_output_204_0).xxx;
			o.Specular = temp_cast_10;
			float temp_output_100_0 = _Smoothness;
			o.Smoothness = temp_output_100_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Standard"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.TexturePropertyNode;182;-789.5341,1664.341;Inherit;True;Global;_Udon_VideoTex;_Udon_VideoTex;7;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;185;-803.3344,1855.276;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;188;-865.7507,1972.701;Inherit;True;Property;_FlowMap2;FlowMap;6;0;Create;True;0;0;0;False;0;False;-1;None;59cea2e54c710d447b163f9fff15adf8;True;0;False;white;Auto;False;Instance;155;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;189;-682.3522,1240.07;Inherit;False;Property;_FlowStrength;Flow Strength;10;0;Create;True;0;0;0;False;0;False;0.1,0.1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;190;-674.3588,1393.102;Inherit;False;Property;_FlowSpeed;Flow Speed;9;0;Create;True;0;0;0;False;0;False;0.2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;197;-310.0323,1601.58;Inherit;True;Flow;3;;118;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;7;56;FLOAT;1;False;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.TexelSizeNode;202;-305.1174,1841.346;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;194;-278.1606,1505.248;Inherit;False;Property;_AudioLinkIntensity;AudioLink Intensity;11;0;Create;True;0;0;0;False;0;False;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;203;79.88257,1612.346;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;16;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;199;30.01636,1785.646;Inherit;False;Property;_VideoIntensity;Video Intensity;13;0;Create;True;0;0;0;False;0;False;1;1;1;7;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-259.9191,130.5153;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;192;-245.2664,1395.597;Inherit;False;M_GetRainbowTrack;-1;;119;a14bfb64767603a449f9acd9d7712fd0;0;2;34;FLOAT2;1,0;False;16;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;184;41.00549,1863.617;Inherit;False;Property;_VideoLerp;Video Lerp;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;101.5394,1447.348;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;274.6164,1607.545;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;154;-50.16504,815.4182;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;114;31.79487,261.0317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;155;-331.6815,891.1307;Inherit;True;Property;_FlowMap;FlowMap;6;0;Create;True;0;0;0;False;0;False;-1;59cea2e54c710d447b163f9fff15adf8;59cea2e54c710d447b163f9fff15adf8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;162;-47.7841,608.6061;Inherit;True;Property;_EmissiveMask;Emissive Mask;8;0;Create;True;0;0;0;False;0;False;a0a1d596e870a8e43a7322c0e568730c;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;115;-273.9825,300.0136;Inherit;True;Property;_Normal;Normal;5;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;112;220.0252,304.425;Inherit;False;LTCGI_Contribution;-1;;129;d3ea6060590627141a6e856295f0e87c;0;2;18;SAMPLER2D;_Sampler18112;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;196;234.3986,910.8463;Inherit;True;Flow;3;;130;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;7;56;FLOAT;1;False;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;195;494.9254,1556.857;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;160;198.97,-264.2907;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;60a5cd4b5de8ad449805671facd6227a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;204;-229.4184,44.659;Inherit;False;Property;_Specular;Specular;1;0;Create;True;0;0;0;False;0;False;0.08;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;656.6271,181.4181;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;626.6182,305.0493;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;674.4863,1183.309;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;116;381.3712,459.0574;Inherit;False;Constant;_Float4;Float 4;18;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;863.7276,290.6189;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1414.661,6.305622;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;MyroP/EyeShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Standard;-1;-1;-1;-1;1;LTCGI=ALWAYS;False;0;0;False;;-1;0;False;;1;Include;Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;197;5;182;0
WireConnection;197;2;185;0
WireConnection;197;18;188;0
WireConnection;197;17;189;0
WireConnection;197;24;190;0
WireConnection;202;0;182;0
WireConnection;203;0;202;3
WireConnection;203;2;197;0
WireConnection;193;0;192;0
WireConnection;193;1;194;0
WireConnection;198;0;203;0
WireConnection;198;1;199;0
WireConnection;114;0;100;0
WireConnection;112;18;115;0
WireConnection;112;21;114;0
WireConnection;196;5;162;0
WireConnection;196;2;154;0
WireConnection;196;18;155;0
WireConnection;196;17;189;0
WireConnection;196;24;190;0
WireConnection;195;0;193;0
WireConnection;195;1;198;0
WireConnection;195;2;184;0
WireConnection;109;0;160;0
WireConnection;109;1;112;0
WireConnection;113;0;112;16
WireConnection;113;1;112;17
WireConnection;113;2;204;0
WireConnection;172;0;196;0
WireConnection;172;1;195;0
WireConnection;110;0;109;0
WireConnection;110;1;113;0
WireConnection;110;2;172;0
WireConnection;0;0;160;0
WireConnection;0;2;110;0
WireConnection;0;3;204;0
WireConnection;0;4;100;0
ASEEND*/
//CHKSM=0ACD6213EE04A9C96A7688085DC4EDB5E703ADC6