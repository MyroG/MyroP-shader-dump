// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/EyeShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Specular("Specular", Range( 0 , 1)) = 0.08
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_EmissionTex("EmissionTex", 2D) = "white" {}
		_Emissioncolor("Emission color", Color) = (0,0,0,0)
		_RaveMode("Rave Mode", Range( 0 , 1)) = 0
		[Toggle(_LTCGI_ON)] _LTCGI("LTCGI", Float) = 0
		_EffectMask("Effect Mask", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowSpeed("Flow Speed", Float) = 0.2
		_FlowStrength("Flow Strength", Vector) = (0.1,0.1,0,0)
		_AudioLinkEmissiveboost("Emissive boost", Range( 0 , 20)) = 1
		_VideoscreenLerp("Video screen - Lerp", Range( 0 , 1)) = 0
		[Toggle(_RETROREFLECTION_ON)] _Retroreflection("Retroreflection", Float) = 0
		_RetroreflectionEyezones("Retroreflection Eye zones", 2D) = "white" {}
		_Retroreflectioncolor1("Retroreflection color 1", Color) = (0,0,0,0)
		_Retroreflectioncolor2("Retroreflection color 2", Color) = (0,0,0,0)
		_Retroreflectiondepth("Retroreflection depth", Range( 0 , 1)) = 0
		_Retroreflectionsize("Retroreflection size", Range( 0 , 10)) = 0
		_Retroreflectionminimumlightintensity("Retroreflection minimum light intensity", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "LTCGI"="ALWAYS" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _LTCGI_ON
		#pragma shader_feature_local _RETROREFLECTION_ON
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
			half ASEIsFrontFacing : VFACE;
			float2 uv2_texcoord2;
			float3 viewDir;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _Smoothness;
		uniform float _Specular;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform float4 _Emissioncolor;
		uniform sampler2D _EffectMask;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float2 _FlowStrength;
		uniform float _FlowSpeed;
		uniform sampler2D _Udon_VideoTex;
		float4 _Udon_VideoTex_TexelSize;
		uniform float _VideoscreenLerp;
		uniform float _AudioLinkEmissiveboost;
		uniform float _RaveMode;
		uniform float _Retroreflectionsize;
		uniform float _Retroreflectionminimumlightintensity;
		uniform sampler2D _RetroreflectionEyezones;
		uniform float4 _RetroreflectionEyezones_ST;
		uniform float4 _Retroreflectioncolor1;
		uniform float _Retroreflectiondepth;
		uniform float4 _Retroreflectioncolor2;


		float IfAudioLinkv2Exists1_g141(  )
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


		inline float AudioLinkLerp3_g138( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g140( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g134( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g136( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		float IfAudioLinkv2Exists1_g159(  )
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


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			SurfaceOutputStandardSpecular s304 = (SurfaceOutputStandardSpecular ) 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 paramAlbedo207 = tex2D( _MainTex, uv_MainTex );
			s304.Albedo = paramAlbedo207.rgb;
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			s304.Normal = normalize( WorldNormalVector( i , UnpackNormal( tex2D( _Normal, uv_Normal ) ) ) );
			float localLTCGI15_g131 = ( 0.0 );
			float3 ase_worldPos = i.worldPos;
			float3 worldPos15_g131 = ase_worldPos;
			float3 newWorldNormal7_g131 = normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _Normal, uv_Normal ) ) )) );
			float3 switchResult23_g131 = (((i.ASEIsFrontFacing>0)?(newWorldNormal7_g131):(-newWorldNormal7_g131)));
			float3 worldNorm15_g131 = switchResult23_g131;
			float3 normalizeResult12_g131 = normalize( ( _WorldSpaceCameraPos - ase_worldPos ) );
			float3 cameraDir15_g131 = normalizeResult12_g131;
			float paramSmoothness338 = _Smoothness;
			float roughness15_g131 = ( 1.0 - paramSmoothness338 );
			float2 lightmapUV15_g131 = i.uv2_texcoord2;
			float3 diffuse15_g131 = float3( 0,0,0 );
			float3 specular15_g131 = float3( 0,0,0 );
			float specularIntensity15_g131 = 0;
			{
			LTCGI_Contribution(worldPos15_g131, worldNorm15_g131, cameraDir15_g131, roughness15_g131, lightmapUV15_g131, diffuse15_g131, specular15_g131, specularIntensity15_g131);
			}
			float paramSpecular337 = _Specular;
			#ifdef _LTCGI_ON
				float4 staticSwitch346 = ( ( paramAlbedo207 * float4( diffuse15_g131 , 0.0 ) ) + float4( ( specular15_g131 * specularIntensity15_g131 * paramSpecular337 ) , 0.0 ) );
			#else
				float4 staticSwitch346 = float4( 0,0,0,0 );
			#endif
			float4 LTCGI345 = staticSwitch346;
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float2 temp_output_4_0_g142 = (( i.uv_texcoord / 1.0 )).xy;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 temp_output_17_0_g142 = _FlowStrength;
			float mulTime22_g142 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g142 = frac( mulTime22_g142 );
			float2 temp_output_11_0_g142 = ( temp_output_4_0_g142 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g142 * temp_output_27_0_g142 ) );
			float2 temp_output_12_0_g142 = ( temp_output_4_0_g142 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g142 * frac( ( mulTime22_g142 + 0.5 ) ) ) );
			float4 lerpResult9_g142 = lerp( tex2D( _EffectMask, temp_output_11_0_g142 ) , tex2D( _EffectMask, temp_output_12_0_g142 ) , ( abs( ( temp_output_27_0_g142 - 0.5 ) ) / 0.5 ));
			float localIfAudioLinkv2Exists1_g141 = IfAudioLinkv2Exists1_g141();
			int Band3_g138 = (int)0.0;
			float temp_output_16_0_g132 = 1.0;
			float2 temp_output_34_0_g132 = float2( 1,0 );
			float2 break16_g137 = temp_output_34_0_g132;
			float Delay3_g138 = ( temp_output_16_0_g132 * ( ( i.uv_texcoord.x * break16_g137.x ) + ( i.uv_texcoord.y * break16_g137.y ) ) );
			float localAudioLinkLerp3_g138 = AudioLinkLerp3_g138( Band3_g138 , Delay3_g138 );
			float4 color21_g132 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			int Band3_g140 = (int)1.0;
			float2 break16_g139 = temp_output_34_0_g132;
			float Delay3_g140 = ( temp_output_16_0_g132 * ( ( i.uv_texcoord.x * break16_g139.x ) + ( i.uv_texcoord.y * break16_g139.y ) ) );
			float localAudioLinkLerp3_g140 = AudioLinkLerp3_g140( Band3_g140 , Delay3_g140 );
			float4 color27_g132 = IsGammaSpace() ? float4(1,0.5767992,0,0) : float4(1,0.2921353,0,0);
			int Band3_g134 = (int)2.0;
			float2 break16_g133 = temp_output_34_0_g132;
			float Delay3_g134 = ( temp_output_16_0_g132 * ( ( i.uv_texcoord.x * break16_g133.x ) + ( i.uv_texcoord.y * break16_g133.y ) ) );
			float localAudioLinkLerp3_g134 = AudioLinkLerp3_g134( Band3_g134 , Delay3_g134 );
			float4 color28_g132 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
			int Band3_g136 = (int)3.0;
			float2 break16_g135 = temp_output_34_0_g132;
			float Delay3_g136 = ( temp_output_16_0_g132 * ( ( i.uv_texcoord.x * break16_g135.x ) + ( i.uv_texcoord.y * break16_g135.y ) ) );
			float localAudioLinkLerp3_g136 = AudioLinkLerp3_g136( Band3_g136 , Delay3_g136 );
			float4 color29_g132 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
			float2 temp_output_4_0_g118 = (( i.uv_texcoord / 1.0 )).xy;
			float2 temp_output_17_0_g118 = _FlowStrength;
			float mulTime22_g118 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g118 = frac( mulTime22_g118 );
			float2 temp_output_11_0_g118 = ( temp_output_4_0_g118 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g118 * temp_output_27_0_g118 ) );
			float2 temp_output_12_0_g118 = ( temp_output_4_0_g118 + ( -(tex2D( _FlowMap, uv_FlowMap ).rg*2.0 + -1.0) * temp_output_17_0_g118 * frac( ( mulTime22_g118 + 0.5 ) ) ) );
			float4 lerpResult9_g118 = lerp( tex2D( _Udon_VideoTex, temp_output_11_0_g118 ) , tex2D( _Udon_VideoTex, temp_output_12_0_g118 ) , ( abs( ( temp_output_27_0_g118 - 0.5 ) ) / 0.5 ));
			float4 lerpResult195 = lerp( ( localIfAudioLinkv2Exists1_g141 * min( ( ( localAudioLinkLerp3_g138 * color21_g132 ) + ( localAudioLinkLerp3_g140 * color27_g132 ) + ( localAudioLinkLerp3_g134 * color28_g132 ) + ( localAudioLinkLerp3_g136 * color29_g132 ) ) , float4( 1,1,1,0 ) ) ) , ( _Udon_VideoTex_TexelSize.z > 16.0 ? lerpResult9_g118 : float4( 0,0,0,0 ) ) , _VideoscreenLerp);
			float localIfAudioLinkv2Exists1_g159 = IfAudioLinkv2Exists1_g159();
			float4 lerpResult367 = lerp( ( lerpResult9_g142 * lerpResult195 * _AudioLinkEmissiveboost ) , float4( 0,0,0,0 ) , ( localIfAudioLinkv2Exists1_g159 * _RaveMode ));
			float4 eyeEffect350 = lerpResult367;
			s304.Emission = ( LTCGI345 + ( tex2D( _EmissionTex, uv_EmissionTex ) * _Emissioncolor ) + eyeEffect350 ).rgb;
			float3 temp_cast_10 = (paramSpecular337).xxx;
			s304.Specular = temp_cast_10;
			s304.Smoothness = paramSmoothness338;
			s304.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi304 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g304 = UnityGlossyEnvironmentSetup( s304.Smoothness, data.worldViewDir, s304.Normal, float3(0,0,0));
			gi304 = UnityGlobalIllumination( data, s304.Occlusion, s304.Normal, g304 );
			#endif

			float3 surfResult304 = LightingStandardSpecular ( s304, viewDir, gi304 ).rgb;
			surfResult304 += s304.Emission;

			#ifdef UNITY_PASS_FORWARDADD//304
			surfResult304 -= s304.Emission;
			#endif//304
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform292 = mul(unity_ObjectToWorld,ase_vertex4Pos);
			float3 appendResult294 = (float3(transform292.x , transform292.y , transform292.z));
			float3 normalizeResult301 = normalize( ( ( ( _WorldSpaceLightPos0.xyz - appendResult294 ) * _WorldSpaceLightPos0.w ) + ( _WorldSpaceLightPos0.xyz * ( 1.0 - _WorldSpaceLightPos0.w ) ) ) );
			float3 light_direction329 = normalizeResult301;
			float fresnelNdotV251 = dot( light_direction329, ase_worldViewDir );
			float fresnelNode251 = ( 0.0 + 5.0 * pow( 1.0 - fresnelNdotV251, _Retroreflectionsize ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_RetroreflectionEyezones = i.uv_texcoord * _RetroreflectionEyezones_ST.xy + _RetroreflectionEyezones_ST.zw;
			float2 Offset227 = ( ( 0.0 - 1 ) * ( i.viewDir.xy / i.viewDir.z ) * _Retroreflectiondepth ) + i.uv_texcoord;
			float4 tex2DNode320 = tex2D( _RetroreflectionEyezones, Offset227 );
			#ifdef _RETROREFLECTION_ON
				float4 staticSwitch333 = ( saturate( ( 1.0 - fresnelNode251 ) ) * ( float4( ase_lightColor.rgb , 0.0 ) * ( ase_lightColor.a - _Retroreflectionminimumlightintensity ) * tex2D( _RetroreflectionEyezones, uv_RetroreflectionEyezones ).r * ( ( _Retroreflectioncolor1 * tex2DNode320.g ) + ( tex2DNode320.b * _Retroreflectioncolor2 ) ) ) * saturate( ase_lightAtten ) );
			#else
				float4 staticSwitch333 = float4( 0,0,0,0 );
			#endif
			float4 eyeShine232 = staticSwitch333;
			c.rgb = ( float4( surfResult304 , 0.0 ) + eyeShine232 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
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
Node;AmplifyShaderEditor.CommentaryNode;334;-1889.834,-2263.476;Inherit;False;3225.311;1492.894;Retroreflection;6;232;333;258;260;328;369;Retroreflection;0,0.754717,0.08787119,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;328;-1866.086,-2212.115;Inherit;False;1537.833;680.8367;Calculating the light direction;6;301;329;300;293;295;314;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;314;-1834.087,-2169.115;Inherit;False;1106.376;379.5121;Point light;5;298;296;294;292;291;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;291;-1784.087,-2114.809;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;292;-1573.668,-2093.117;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;295;-1174.427,-1773.738;Inherit;False;446;236;Directional light;2;299;302;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;293;-1585.191,-1745.142;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;294;-1326.8,-2053.083;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;296;-1097.733,-2015.002;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;302;-1139.137,-1652.535;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;335;-3202.363,-676.2567;Inherit;False;701.3298;761.716;Inputs;8;207;211;160;115;204;337;100;338;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;-906.4219,-1723.738;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-869.6995,-1912.605;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-3117.625,-55.56429;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;260;-1862.653,-1518.431;Inherit;False;1628.399;724.8843;Rendering the inside of the pupil, I am also using the "Parallax mapping" node to have some depth;16;254;362;231;253;361;327;326;324;230;325;320;321;227;224;221;223;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;115;-3081.363,-425.5407;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;210;-1891.905,-670.7226;Inherit;False;1732.832;417.6312;LTCGI;11;345;344;212;109;209;343;113;112;114;342;346;LTCGI;0.1664293,0.6415094,0.2614454,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;338;-2797.102,-54.41379;Inherit;False;paramSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;-661.6627,-1906.973;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;220;-2338.116,-163.1246;Inherit;False;2647.201;1377.841;Eye Effects (Flow, AudioLink etc.);22;350;172;194;196;195;184;162;155;154;203;206;202;197;190;189;188;185;182;365;366;367;368;Eye Effects (Flow, AudioLink etc.);0,0.4150943,0.06580332,1;0;0
Node;AmplifyShaderEditor.SamplerNode;160;-3152.363,-626.2566;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;e8e479c7c37997a44b26bbf346ef112e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;204;-3106.636,-204.3657;Inherit;False;Property;_Specular;Specular;2;0;Create;True;0;0;0;False;0;False;0.08;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-2763.324,-425.7926;Inherit;False;paramNormal;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;342;-1862.642,-406.1666;Inherit;False;338;paramSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-1847.057,-1107.571;Inherit;False;Property;_Retroreflectiondepth;Retroreflection depth;21;0;Create;True;0;0;0;False;0;False;0;0.316;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;221;-1782.105,-1243.209;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;224;-1747.323,-1015.162;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;301;-622.5068,-1791.339;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;182;-2211.899,676.0399;Inherit;True;Global;_Udon_VideoTex;_Udon_VideoTex;12;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;185;-2225.699,866.9754;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;188;-2288.116,984.4016;Inherit;True;Property;_FlowMap2;FlowMap;11;0;Create;True;0;0;0;False;0;False;-1;None;59cea2e54c710d447b163f9fff15adf8;True;0;False;white;Auto;False;Instance;155;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;189;-2104.718,251.7691;Inherit;False;Property;_FlowStrength;Flow Strength;14;0;Create;True;0;0;0;False;0;False;0.1,0.1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;190;-2096.724,404.8005;Inherit;False;Property;_FlowSpeed;Flow Speed;13;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;258;-292.1773,-2207.476;Inherit;False;909.998;288.6764;Calculating the retroreflection mask;5;360;250;252;251;330;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-2762.032,-623.3353;Inherit;False;paramAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;337;-2801.005,-204.6192;Inherit;False;paramSpecular;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;114;-1636.906,-406.1107;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;-1714.445,-497.78;Inherit;False;211;paramNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ParallaxMappingNode;227;-1538.068,-1155.775;Inherit;False;Planar;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;321;-1556.707,-1470.425;Inherit;True;Property;_RetroreflectionEyezones;Retroreflection Eye zones;18;0;Create;True;0;0;0;False;0;False;None;bdf2fd130023a1443af8c801da212af8;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-533.9736,-1704.976;Inherit;False;light direction;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;197;-1732.396,613.2784;Inherit;True;Flow;9;;118;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;7;56;FLOAT;1;False;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.TexelSizeNode;202;-1727.481,853.0454;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;112;-1489.676,-490.7168;Inherit;False;LTCGI_Contribution;-1;;131;d3ea6060590627141a6e856295f0e87c;0;2;18;SAMPLER2D;_Sampler18112;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;343;-1432.642,-371.1664;Inherit;False;337;paramSpecular;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-1355.353,-614.1223;Inherit;False;207;paramAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-262.5388,-2150.779;Inherit;False;329;light direction;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;320;-1304.425,-1147.17;Inherit;True;Property;_regionMask2;region Mask;0;0;Create;True;0;0;0;False;0;False;-1;dea87864c7ad02a4fa6c748cdd1b6247;bdf2fd130023a1443af8c801da212af8;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;325;-1239.65,-959.8121;Inherit;False;Property;_Retroreflectioncolor2;Retroreflection color 2;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5529411,0.9700156,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;230;-1239.718,-1317.336;Inherit;False;Property;_Retroreflectioncolor1;Retroreflection color 1;19;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2499996,1,0.6746323,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;360;-259.1566,-2046.884;Inherit;False;Property;_Retroreflectionsize;Retroreflection size;22;0;Create;True;0;0;0;False;0;False;0;0.42;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;206;-1667.63,407.2955;Inherit;False;M_GetRainbowTrack;-1;;132;a14bfb64767603a449f9acd9d7712fd0;0;2;34;FLOAT2;1,0;False;16;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;203;-1342.483,624.0446;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;16;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;154;-1477.03,171.4677;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;155;-1820.097,-113.1244;Inherit;True;Property;_FlowMap;FlowMap;11;0;Create;True;0;0;0;False;0;False;-1;59cea2e54c710d447b163f9fff15adf8;ca8d6a95b37f62a4db3559f71ae00a27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;162;-1472.399,-53.34839;Inherit;True;Property;_EffectMask;Effect Mask;8;0;Create;True;0;0;0;False;0;False;a0a1d596e870a8e43a7322c0e568730c;81658265a1a34024780dfa921a038bac;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;184;-1239.133,788.0833;Inherit;False;Property;_VideoscreenLerp;Video screen - Lerp;16;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;369;136.3041,-1848.832;Inherit;False;689.1002;588.229;Just to make sure the effect doesn't show up in shadows;3;363;364;228;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-1083.082,-490.0925;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1104.073,-614.723;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;251;24.69779,-2149.559;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;-947.4214,-1107.174;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;-943.9409,-999.8407;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;195;-927.4413,568.5558;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;196;-1046.176,188.1226;Inherit;True;Flow;9;;142;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;7;56;FLOAT;1;False;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-927.2742,733.2735;Inherit;False;Property;_AudioLinkEmissiveboost;Emissive boost;15;0;Create;False;0;0;0;False;0;False;1;5.49;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;365;-573.48,410.7081;Inherit;False;IsAudioLink;-1;;159;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;368;-582.2889,543.2401;Inherit;False;Property;_RaveMode;Rave Mode;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;361;-903.9047,-1364.465;Inherit;False;Property;_Retroreflectionminimumlightintensity;Retroreflection minimum light intensity;23;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;253;-739.6335,-1480.894;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;344;-828.6408,-528.1658;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;252;309.5518,-2149.038;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;327;-636.2055,-1076.401;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-555.9216,187.3808;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;366;-266.4793,460.7092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;363;191.5381,-1487.603;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;231;-789.7204,-1282.201;Inherit;True;Property;_regionMask;region Mask;1;0;Create;True;0;0;0;False;0;False;-1;dea87864c7ad02a4fa6c748cdd1b6247;bdf2fd130023a1443af8c801da212af8;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;362;-580.9941,-1389.719;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;346;-663.5332,-554.6316;Inherit;False;Property;_LTCGI;LTCGI;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;250;458.8231,-2152.281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;367;-189.7845,189.6776;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;364;438.4246,-1605.161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;-393.7556,-1414.337;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;345;-440.6418,-557.1655;Inherit;False;LTCGI;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;728.7875,-471.9373;Inherit;False;211;paramNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;219;381.5354,-282.1726;Inherit;True;Property;_EmissionTex;EmissionTex;4;0;Create;True;0;0;0;False;0;False;-1;None;68057ef887af6dd44b13ea8f161de3f2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;348;460.6326,-84.67957;Inherit;False;Property;_Emissioncolor;Emission color;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3679244,0.3679244,0.3679244,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;350;-4.274078,190.8564;Inherit;False;eyeEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;657.8721,-1794.645;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;214;917.9197,-366.8608;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;349;735.6328,-155.6796;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;347;888.6065,-192.2863;Inherit;False;345;LTCGI;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;351;926.0103,-82.46832;Inherit;False;350;eyeEffect;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;333;851.5908,-1819.287;Inherit;False;Property;_Retroreflection;Retroreflection;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;1545.772,-428.4938;Inherit;False;207;paramAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;215;1264.321,-387.6964;Inherit;True;Property;_Normalinput;Normal input;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;110;1185.542,-187.6327;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;339;1603.98,-232.4824;Inherit;False;337;paramSpecular;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;340;1601.979,-159.4824;Inherit;False;338;paramSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;232;1123.667,-1817.052;Inherit;False;eyeShine;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;304;1866.435,-304.2345;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;1817.13,-88.09698;Inherit;False;232;eyeShine;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;318;2089.923,-172.8804;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2220.415,-412.3609;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;MyroP/EyeShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;Standard;-1;-1;-1;-1;1;LTCGI=ALWAYS;False;0;0;False;;-1;0;False;;1;Include;Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;292;0;291;0
WireConnection;294;0;292;1
WireConnection;294;1;292;2
WireConnection;294;2;292;3
WireConnection;296;0;293;1
WireConnection;296;1;294;0
WireConnection;302;0;293;2
WireConnection;299;0;293;1
WireConnection;299;1;302;0
WireConnection;298;0;296;0
WireConnection;298;1;293;2
WireConnection;338;0;100;0
WireConnection;300;0;298;0
WireConnection;300;1;299;0
WireConnection;211;0;115;0
WireConnection;301;0;300;0
WireConnection;207;0;160;0
WireConnection;337;0;204;0
WireConnection;114;0;342;0
WireConnection;227;0;221;0
WireConnection;227;2;223;0
WireConnection;227;3;224;0
WireConnection;329;0;301;0
WireConnection;197;5;182;0
WireConnection;197;2;185;0
WireConnection;197;18;188;0
WireConnection;197;17;189;0
WireConnection;197;24;190;0
WireConnection;202;0;182;0
WireConnection;112;18;212;0
WireConnection;112;21;114;0
WireConnection;320;0;321;0
WireConnection;320;1;227;0
WireConnection;203;0;202;3
WireConnection;203;2;197;0
WireConnection;113;0;112;16
WireConnection;113;1;112;17
WireConnection;113;2;343;0
WireConnection;109;0;209;0
WireConnection;109;1;112;0
WireConnection;251;0;330;0
WireConnection;251;3;360;0
WireConnection;324;0;230;0
WireConnection;324;1;320;2
WireConnection;326;0;320;3
WireConnection;326;1;325;0
WireConnection;195;0;206;0
WireConnection;195;1;203;0
WireConnection;195;2;184;0
WireConnection;196;5;162;0
WireConnection;196;2;154;0
WireConnection;196;18;155;0
WireConnection;196;17;189;0
WireConnection;196;24;190;0
WireConnection;344;0;109;0
WireConnection;344;1;113;0
WireConnection;252;0;251;0
WireConnection;327;0;324;0
WireConnection;327;1;326;0
WireConnection;172;0;196;0
WireConnection;172;1;195;0
WireConnection;172;2;194;0
WireConnection;366;0;365;0
WireConnection;366;1;368;0
WireConnection;231;0;321;0
WireConnection;362;0;253;2
WireConnection;362;1;361;0
WireConnection;346;0;344;0
WireConnection;250;0;252;0
WireConnection;367;0;172;0
WireConnection;367;2;366;0
WireConnection;364;0;363;0
WireConnection;254;0;253;1
WireConnection;254;1;362;0
WireConnection;254;2;231;1
WireConnection;254;3;327;0
WireConnection;345;0;346;0
WireConnection;350;0;367;0
WireConnection;228;0;250;0
WireConnection;228;1;254;0
WireConnection;228;2;364;0
WireConnection;214;2;213;0
WireConnection;349;0;219;0
WireConnection;349;1;348;0
WireConnection;333;0;228;0
WireConnection;215;0;213;0
WireConnection;215;1;214;0
WireConnection;110;0;347;0
WireConnection;110;1;349;0
WireConnection;110;2;351;0
WireConnection;232;0;333;0
WireConnection;304;0;208;0
WireConnection;304;1;215;0
WireConnection;304;2;110;0
WireConnection;304;3;339;0
WireConnection;304;4;340;0
WireConnection;318;0;304;0
WireConnection;318;1;233;0
WireConnection;0;13;318;0
ASEEND*/
//CHKSM=07A4179D676D867B5C1A3254270EEB96145C56AD