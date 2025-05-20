// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/SomnaGlass"
{
	Properties
	{
		_Glasscolor("Glass color", Color) = (0,0,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_EmissiveTexture("Emissive Texture", 2D) = "black" {}
		[HDR]_EmissiveTextureColor("Emissive Texture Color", Color) = (0,0,0,0)
		_SomnaMask("Somna Mask", 2D) = "black" {}
		_SomnaMaskTiling("Somna Mask Tiling", Vector) = (1,1,0,0)
		[HDR]_SomnaForegroundColor("Somna Foreground Color", Color) = (0,0,0,0)
		_SomnaForegroundScrollSpeed("Somna Foreground Scroll Speed", Range( -1 , 1)) = -0.015
		_SomnaForegroundDistance("Somna Foreground Distance", Float) = 0.8
		_SomnaForegroundAnimationSpeed("Somna Foreground Animation Speed", Range( 0 , 1)) = 0
		[HDR]_SomnaBackgroundColor("Somna Background Color", Color) = (0,0,0,0)
		_SomnaBackgroundScrollSpeed("Somna Background Scroll Speed", Range( -1 , 1)) = -0.012
		_SomnaBackgroundDistance("Somna Background Distance", Float) = 0.13
		_SomnaBackgroundAnimationSpeed("Somna Background Animation Speed", Range( 0 , 1)) = 0
		[Toggle(_SOMNAEDGEFADE_ON)] _SomnaEdgeFade("Somna Edge Fade", Float) = 1
		_SomnaEdgeFadeBias("Somna Edge Fade Bias", Range( 0 , 10)) = 0
		_SomnaEdgeFadeScale("Somna Edge Fade Scale", Range( 0 , 20)) = 20
		_SomnaEdgeFadePower("Somna Edge Fade Power", Range( 0 , 10)) = 5
		_SomnaCameraDistanceFade("Somna Camera Distance Fade", Range( 0 , 100)) = 5
		[Toggle(_FRESNEL_ON)] _Fresnel("Fresnel", Float) = 1
		[HDR]_FresnelColor("Fresnel Color", Color) = (0,0,0,0)
		_FresnelBias("Fresnel Bias", Range( 0 , 10)) = 0
		_FresnelScale("Fresnel Scale", Range( 0 , 10)) = 1
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 5
		[Toggle(_AUDIOLINK_ON)] _AUDIOLINK("AudioLink", Float) = 0
		_AudioLinkintensity("AudioLink intensity", Range( 0 , 5)) = 0
		_AudioLinkcolorLow("AudioLink color - Low", Color) = (1,0,0,0)
		_AudioLinkcolorMid1("AudioLink color -  Mid 1", Color) = (1,0.5767992,0,0)
		_AudioLinkcolorMid2("AudioLink color - Mid 2", Color) = (0,1,0,0)
		_AudioLinkcolorHigh("AudioLink color - High", Color) = (0,0,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _FRESNEL_ON
		#pragma shader_feature_local _SOMNAEDGEFADE_ON
		#pragma shader_feature_local _AUDIOLINK_ON
		#define ASE_VERSION 19801
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
			float3 viewDir;
			float eyeDepth;
		};

		uniform float4 _Glasscolor;
		uniform float4 _EmissiveTextureColor;
		uniform sampler2D _EmissiveTexture;
		uniform float4 _EmissiveTexture_ST;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _FresnelColor;
		uniform sampler2D _SomnaMask;
		uniform float2 _SomnaMaskTiling;
		uniform float _SomnaForegroundScrollSpeed;
		uniform float _SomnaForegroundDistance;
		uniform float _SomnaForegroundAnimationSpeed;
		uniform float4 _SomnaForegroundColor;
		uniform float _SomnaBackgroundScrollSpeed;
		uniform float _SomnaBackgroundDistance;
		uniform float _SomnaBackgroundAnimationSpeed;
		uniform float4 _SomnaBackgroundColor;
		uniform float _SomnaEdgeFadeBias;
		uniform float _SomnaEdgeFadeScale;
		uniform float _SomnaEdgeFadePower;
		uniform float _SomnaCameraDistanceFade;
		uniform float4 _AudioLinkcolorLow;
		uniform float4 _AudioLinkcolorMid1;
		uniform float4 _AudioLinkcolorMid2;
		uniform float4 _AudioLinkcolorHigh;
		uniform float _AudioLinkintensity;
		uniform float _Metallic;
		uniform float _Smoothness;


		float SmoothFract381( float x, float edgeWidth )
		{
			float fx = frac(x);
			float t = saturate((1.0 - fx) / edgeWidth); 
			float smoothFx = fx * fx * (3.0 - 2.0 * fx); // 
			return smoothFx * t;
		}


		float SmoothFract383( float x, float edgeWidth )
		{
			float fx = frac(x);
			float t = saturate((1.0 - fx) / edgeWidth); 
			float smoothFx = fx * fx * (3.0 - 2.0 * fx); // 
			return smoothFx * t;
		}


		float IfAudioLinkv2Exists1_g92(  )
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


		float IfAudioLinkv2Exists1_g294(  )
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


		inline float AudioLinkLerp3_g298( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g300( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g302( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g296( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float4 Glass_color398 = _Glasscolor;
			float4 temp_output_2_0_g146 = Glass_color398;
			o.Albedo = (temp_output_2_0_g146).rgb;
			float2 uv_EmissiveTexture = i.uv_texcoord * _EmissiveTexture_ST.xy + _EmissiveTexture_ST.zw;
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV51 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode51 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV51, _FresnelPower ) );
			#ifdef _FRESNEL_ON
				float staticSwitch406 = saturate( fresnelNode51 );
			#else
				float staticSwitch406 = 0.0;
			#endif
			float RimLight53 = staticSwitch406;
			float mulTime385 = _Time.y * _SomnaForegroundScrollSpeed;
			float2 appendResult387 = (float2(0.0 , mulTime385));
			float2 uv_TexCoord333 = i.uv_texcoord * _SomnaMaskTiling + appendResult387;
			float2 Offset335 = ( ( _SomnaForegroundDistance - 1 ) * ( i.viewDir.xy / i.viewDir.z ) * 1.0 ) + uv_TexCoord333;
			float4 tex2DNode336 = tex2D( _SomnaMask, Offset335 );
			float mulTime365 = _Time.y * _SomnaForegroundAnimationSpeed;
			float x381 = ( tex2DNode336.g * frac( ( tex2DNode336.r + mulTime365 ) ) );
			float edgeWidth381 = 0.1;
			float localSmoothFract381 = SmoothFract381( x381 , edgeWidth381 );
			float mulTime390 = _Time.y * _SomnaBackgroundScrollSpeed;
			float2 appendResult389 = (float2(3.0 , mulTime390));
			float2 uv_TexCoord372 = i.uv_texcoord * _SomnaMaskTiling + appendResult389;
			float2 Offset375 = ( ( _SomnaBackgroundDistance - 1 ) * ( i.viewDir.xy / i.viewDir.z ) * 1.0 ) + uv_TexCoord372;
			float4 tex2DNode376 = tex2D( _SomnaMask, Offset375 );
			float mulTime368 = _Time.y * _SomnaBackgroundAnimationSpeed;
			float x383 = ( tex2DNode376.g * frac( ( tex2DNode376.r + mulTime368 ) ) );
			float edgeWidth383 = 0.1;
			float localSmoothFract383 = SmoothFract383( x383 , edgeWidth383 );
			float fresnelNdotV341 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode341 = ( _SomnaEdgeFadeBias + _SomnaEdgeFadeScale * pow( 1.0 - fresnelNdotV341, _SomnaEdgeFadePower ) );
			#ifdef _SOMNAEDGEFADE_ON
				float staticSwitch417 = saturate( fresnelNode341 );
			#else
				float staticSwitch417 = 0.0;
			#endif
			float cameraDepthFade420 = (( i.eyeDepth -_ProjectionParams.y - _SomnaCameraDistanceFade ) / 1.0);
			float Somna_Fade428 = ( ( 1.0 - staticSwitch417 ) * ( 1.0 - saturate( cameraDepthFade420 ) ) );
			float3 constellation_colored431 = ( ( ( localSmoothFract381 * _SomnaForegroundColor.rgb ) + ( localSmoothFract383 * _SomnaBackgroundColor.rgb ) ) * Somna_Fade428 );
			float localIfAudioLinkv2Exists1_g92 = IfAudioLinkv2Exists1_g92();
			float localIfAudioLinkv2Exists1_g294 = IfAudioLinkv2Exists1_g294();
			int Band3_g298 = (int)0.0;
			float temp_output_16_0_g293 = 128.0;
			float3 normalizeResult454 = normalize( ase_viewDirWS );
			float3 ase_normalOS = mul( unity_WorldToObject, float4( ase_normalWS, 0 ) );
			ase_normalOS = normalize( ase_normalOS );
			float4 transform463 = mul(unity_ObjectToWorld,float4( ase_normalOS , 0.0 ));
			float3 appendResult464 = (float3(transform463.x , transform463.y , transform463.z));
			float3 normalizeResult453 = normalize( appendResult464 );
			float dotResult455 = dot( normalizeResult454 , normalizeResult453 );
			float temp_output_456_0 = ( 1.0 - dotResult455 );
			float2 appendResult458 = (float2(temp_output_456_0 , temp_output_456_0));
			float2 temp_output_87_0_g293 = appendResult458;
			float2 break18_g297 = temp_output_87_0_g293;
			float2 temp_output_34_0_g293 = float2( 1,0 );
			float2 break16_g297 = temp_output_34_0_g293;
			float Delay3_g298 = ( temp_output_16_0_g293 * ( ( break18_g297.x * break16_g297.x ) + ( break18_g297.y * break16_g297.y ) ) );
			float localAudioLinkLerp3_g298 = AudioLinkLerp3_g298( Band3_g298 , Delay3_g298 );
			int Band3_g300 = (int)1.0;
			float2 break18_g299 = temp_output_87_0_g293;
			float2 break16_g299 = temp_output_34_0_g293;
			float Delay3_g300 = ( temp_output_16_0_g293 * ( ( break18_g299.x * break16_g299.x ) + ( break18_g299.y * break16_g299.y ) ) );
			float localAudioLinkLerp3_g300 = AudioLinkLerp3_g300( Band3_g300 , Delay3_g300 );
			int Band3_g302 = (int)2.0;
			float2 break18_g301 = temp_output_87_0_g293;
			float2 break16_g301 = temp_output_34_0_g293;
			float Delay3_g302 = ( temp_output_16_0_g293 * ( ( break18_g301.x * break16_g301.x ) + ( break18_g301.y * break16_g301.y ) ) );
			float localAudioLinkLerp3_g302 = AudioLinkLerp3_g302( Band3_g302 , Delay3_g302 );
			int Band3_g296 = (int)3.0;
			float2 break18_g295 = temp_output_87_0_g293;
			float2 break16_g295 = temp_output_34_0_g293;
			float Delay3_g296 = ( temp_output_16_0_g293 * ( ( break18_g295.x * break16_g295.x ) + ( break18_g295.y * break16_g295.y ) ) );
			float localAudioLinkLerp3_g296 = AudioLinkLerp3_g296( Band3_g296 , Delay3_g296 );
			#ifdef _AUDIOLINK_ON
				float4 staticSwitch211 = ( ( localIfAudioLinkv2Exists1_g294 * min( ( ( localAudioLinkLerp3_g298 * _AudioLinkcolorLow ) + ( localAudioLinkLerp3_g300 * _AudioLinkcolorMid1 ) + ( localAudioLinkLerp3_g302 * _AudioLinkcolorMid2 ) + ( localAudioLinkLerp3_g296 * _AudioLinkcolorHigh ) ) , float4( 1,1,1,0 ) ) ) * _AudioLinkintensity );
			#else
				float4 staticSwitch211 = float4( 0,0,0,0 );
			#endif
			float4 audioLinkColors234 = staticSwitch211;
			float4 Emission80 = ( float4( ( _EmissiveTextureColor.rgb * tex2D( _EmissiveTexture, uv_EmissiveTexture ).rgb ) , 0.0 ) + float4( ( RimLight53 * _FresnelColor.rgb ) , 0.0 ) + float4( constellation_colored431 , 0.0 ) + ( localIfAudioLinkv2Exists1_g92 * audioLinkColors234 ) );
			o.Emission = Emission80.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float4 temp_output_2_0_g145 = Glass_color398;
			float4 temp_output_2_0_g147 = Glass_color398;
			float constellation_BnW337 = ( ( localSmoothFract381 + localSmoothFract383 ) * Somna_Fade428 * (temp_output_2_0_g147).a );
			float Opacity61 = saturate( ( (temp_output_2_0_g145).a + RimLight53 + constellation_BnW337 ) );
			o.Alpha = Opacity61;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
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
				vertexDataFunc( v, customInputData );
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
				o.customPack1.z = customInputData.eyeDepth;
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
				surfIN.eyeDepth = IN.customPack1.z;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "VRChat/Mobile/Standard Lite"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.CommentaryNode;391;-5664,752;Inherit;False;3691.329;1244.319;Somna;44;337;378;393;384;381;383;367;382;370;369;366;377;364;336;368;365;376;335;375;397;396;331;374;345;333;334;372;371;403;387;389;390;385;394;395;405;425;429;430;431;432;433;435;436;Somna;0.6593885,0,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;395;-5568,1456;Inherit;False;Property;_SomnaBackgroundScrollSpeed;Somna Background Scroll Speed;12;0;Create;True;0;0;0;False;0;False;-0.012;-0.012;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;394;-5552,1088;Inherit;False;Property;_SomnaForegroundScrollSpeed;Somna Foreground Scroll Speed;8;0;Create;True;0;0;0;False;0;False;-0.015;-0.015;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;385;-5200,1088;Inherit;False;1;0;FLOAT;-0.015;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;390;-5152,1456;Inherit;False;1;0;FLOAT;-0.012;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;232;-7114.693,-1296;Inherit;False;3006.908;839.1199;AudioLink colors;18;445;234;211;237;242;458;217;220;219;218;456;455;454;453;464;452;463;460;AudioLink colors;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;389;-4944,1424;Inherit;False;FLOAT2;4;0;FLOAT;3;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;387;-4992,1056;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;403;-5168,1264;Inherit;False;Property;_SomnaMaskTiling;Somna Mask Tiling;6;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NormalVertexDataNode;460;-7040,-976;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;371;-4688,1696;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;372;-4720,1456;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,1;False;1;FLOAT2;3.35,0.06;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;334;-4688,1264;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;333;-4720,1024;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;345;-4800,1152;Inherit;False;Property;_SomnaForegroundDistance;Somna Foreground Distance;9;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;374;-4864,1584;Inherit;False;Property;_SomnaBackgroundDistance;Somna Background Distance;13;0;Create;True;0;0;0;False;0;False;0.13;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;414;-7984,960;Inherit;False;Property;_SomnaEdgeFadeBias;Somna Edge Fade Bias;16;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;415;-7984,1024;Inherit;False;Property;_SomnaEdgeFadeScale;Somna Edge Fade Scale;17;0;Create;True;0;0;0;False;0;False;20;10.31;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;416;-7984,1120;Inherit;False;Property;_SomnaEdgeFadePower;Somna Edge Fade Power;18;0;Create;True;0;0;0;False;0;False;5;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;463;-6848,-976;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;331;-4512,1328;Inherit;True;Property;_SomnaMask;Somna Mask;5;0;Create;True;0;0;0;False;0;False;cb701384da82d404285664108c017f56;cb701384da82d404285664108c017f56;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ParallaxMappingNode;375;-4480,1552;Inherit;False;Planar;4;0;FLOAT2;0,0;False;1;FLOAT;0.95;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;335;-4480,1120;Inherit;False;Planar;4;0;FLOAT2;0,0;False;1;FLOAT;0.95;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;341;-7648,960;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;26.93;False;3;FLOAT;5.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;421;-7392,1184;Inherit;False;Property;_SomnaCameraDistanceFade;Somna Camera Distance Fade;19;0;Create;True;0;0;0;False;0;False;5;5.7;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;396;-4464,1744;Inherit;False;Property;_SomnaForegroundAnimationSpeed;Somna Foreground Animation Speed;10;0;Create;True;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;397;-4464,1824;Inherit;False;Property;_SomnaBackgroundAnimationSpeed;Somna Background Animation Speed;14;0;Create;True;0;0;0;False;0;False;0;0.13;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;452;-6720,-1168;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;464;-6672,-976;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;376;-4240,1520;Inherit;True;Property;_TextureSample2;Texture Sample 1;39;0;Create;True;0;0;0;False;0;False;-1;cb701384da82d404285664108c017f56;cb701384da82d404285664108c017f56;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleTimeNode;365;-4160,1328;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;368;-4128,1744;Inherit;False;1;0;FLOAT;0.13;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;336;-4240,1088;Inherit;True;Property;_TextureSample1;Texture Sample 1;39;0;Create;True;0;0;0;False;0;False;-1;cb701384da82d404285664108c017f56;cb701384da82d404285664108c017f56;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode;342;-7360,960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;420;-7040,1120;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;453;-6480,-960;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;454;-6480,-1136;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;364;-3936,1136;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;377;-3920,1552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;417;-7184,992;Inherit;False;Property;_SomnaEdgeFade;Somna Edge Fade;15;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;422;-6800,1120;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;195;-4384,192;Inherit;False;666.5237;426.0569;Local variables definitions;2;398;7;Local variables definitions;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;455;-6288,-1072;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;366;-3760,1168;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;369;-3776,1568;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-5632,-336;Inherit;False;1495.156;322.9141;Rim light;7;408;85;407;51;52;406;53;Rim light;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;343;-6880,1024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;424;-6640,1152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-4320,352;Inherit;False;Property;_Glasscolor;Glass color;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.02242791,0.0573204,0.2264151,0.5058824;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;456;-6064,-1056;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;370;-3568,1584;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;382;-3568,1408;Inherit;False;Constant;_Float7;Float 7;42;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;-3568,1136;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-5600,-272;Inherit;False;Property;_FresnelBias;Fresnel Bias;22;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;407;-5600,-192;Inherit;False;Property;_FresnelScale;Fresnel Scale;23;0;Create;True;0;0;0;False;0;False;1;5.96;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-5600,-112;Inherit;False;Property;_FresnelPower;Fresnel Power;24;0;Create;True;0;0;0;False;0;False;5;5.8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;-6480,1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;398;-4016,400;Inherit;False;Glass color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;218;-5632,-864;Inherit;False;Property;_AudioLinkcolorMid2;AudioLink color - Mid 2;29;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;219;-5616,-672;Inherit;False;Property;_AudioLinkcolorHigh;AudioLink color - High;30;0;Create;True;0;0;0;False;0;False;0,0,1,0;1,0.5019608,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;220;-5632,-1056;Inherit;False;Property;_AudioLinkcolorMid1;AudioLink color -  Mid 1;28;0;Create;True;0;0;0;False;0;False;1,0.5767992,0,0;0.2862744,0.003921569,0.7254902,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;217;-5632,-1248;Inherit;False;Property;_AudioLinkcolorLow;AudioLink color - Low;27;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.DynamicAppendNode;458;-5840,-1024;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;383;-3328,1536;Inherit;False;float fx = frac(x)@$float t = saturate((1.0 - fx) / edgeWidth)@ $float smoothFx = fx * fx * (3.0 - 2.0 * fx)@ // $return smoothFx * t@;1;Create;2;True;x;FLOAT;0;In;;Inherit;False;True;edgeWidth;FLOAT;0.01;In;;Inherit;False;Smooth Fract;True;False;0;;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;381;-3360,1216;Inherit;False;float fx = frac(x)@$float t = saturate((1.0 - fx) / edgeWidth)@ $float smoothFx = fx * fx * (3.0 - 2.0 * fx)@ // $return smoothFx * t@;1;Create;2;True;x;FLOAT;0;In;;Inherit;False;True;edgeWidth;FLOAT;0.01;In;;Inherit;False;Smooth Fract;True;False;0;;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;51;-5312,-288;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;428;-6272,1024;Inherit;False;Somna Fade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;435;-2944,896;Inherit;False;398;Glass color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;425;-3360,1776;Inherit;False;Property;_SomnaBackgroundColor;Somna Background Color;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.4485051,0.06359598,1.498039,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;405;-3376,1328;Inherit;False;Property;_SomnaForegroundColor;Somna Foreground Color;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.2666667,0.3900052,1.498039,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;242;-5136,-528;Inherit;False;Property;_AudioLinkintensity;AudioLink intensity;26;0;Create;True;0;0;0;False;0;False;0;2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;466;-5184,-960;Inherit;False;M_GetRainbowTrack;-1;;293;a14bfb64767603a449f9acd9d7712fd0;0;7;87;FLOAT2;0,0;False;79;COLOR;1,0,0,0;False;80;COLOR;1,0.7058535,0,0;False;81;COLOR;0.1067042,1,0,0;False;82;COLOR;0,0.1044993,1,0;False;34;FLOAT2;1,0;False;16;FLOAT;128;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;52;-4976,-288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;432;-2848,1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;430;-2832,1232;Inherit;False;428;Somna Fade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;436;-2752,880;Inherit;False;Alpha Split;-1;;147;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;-3104,1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;384;-3088,1664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;-4864,-928;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;63;-5654,160;Inherit;False;1084.218;450.7841;Opacity;7;61;60;59;56;404;401;400;Opacity;0,0.5943396,0.04592577,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;406;-4768,-304;Inherit;False;Property;_Fresnel;Fresnel;20;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;433;-2528,1040;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;378;-2848,1392;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;211;-4656,-960;Inherit;False;Property;_AUDIOLINK;AudioLink;25;0;Create;False;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-4512,-288;Inherit;False;RimLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;337;-2256,1040;Inherit;False;constellation BnW;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;400;-5616,208;Inherit;False;398;Glass color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;39;-3952,-1056;Inherit;False;1333.399;1021.683;Emission;13;434;80;43;338;245;419;410;427;229;409;3;418;411;Emission;0,0.7169812,0.0712801,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;429;-2480,1392;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-4384,-928;Inherit;False;audioLinkColors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-5504,336;Inherit;False;53;RimLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;404;-5536,448;Inherit;False;337;constellation BnW;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;401;-5424,192;Inherit;False;Alpha Split;-1;;145;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.ColorNode;411;-3856,-464;Inherit;False;Property;_FresnelColor;Fresnel Color;21;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.69886,0.3382292,0.08900577,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;418;-3744,-960;Inherit;False;Property;_EmissiveTextureColor;Emissive Texture Color;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;3;-3760,-752;Inherit;True;Property;_EmissiveTexture;Emissive Texture;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;409;-3824,-544;Inherit;False;53;RimLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;229;-3568,-336;Inherit;False;IsAudioLink;-1;;92;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;431;-2288,1392;Inherit;False;constellation colored;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;427;-3616,-240;Inherit;False;234;audioLinkColors;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-5216,208;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;-3632,-544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;-3440,-784;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;-3312,-336;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;-3392,-480;Inherit;False;431;constellation colored;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;60;-5008,208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;189;-1472,912;Inherit;False;495;379.8715;Albedo;2;190;399;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-3056,-656;Inherit;True;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-4816,208;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-1440,1008;Inherit;False;398;Glass color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;-2848,-656;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;399;-1184,1040;Inherit;False;Alpha Split;-1;;146;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.RangedFloatNode;2;-1232,1424;Inherit;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1024,1616;Inherit;False;61;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-1232,1504;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;0;0.904;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-1088,1344;Inherit;False;80;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;445;-5328,-1232;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;434;-3568,-144;Inherit;False;61;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-688,1296;Float;False;True;-1;2;AmplifyShaderEditor.MaterialInspector;0;0;Standard;MyroP/SomnaGlass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;VRChat/Mobile/Standard Lite;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;385;0;394;0
WireConnection;390;0;395;0
WireConnection;389;1;390;0
WireConnection;387;1;385;0
WireConnection;372;0;403;0
WireConnection;372;1;389;0
WireConnection;333;0;403;0
WireConnection;333;1;387;0
WireConnection;463;0;460;0
WireConnection;375;0;372;0
WireConnection;375;1;374;0
WireConnection;375;3;371;0
WireConnection;335;0;333;0
WireConnection;335;1;345;0
WireConnection;335;3;334;0
WireConnection;341;1;414;0
WireConnection;341;2;415;0
WireConnection;341;3;416;0
WireConnection;464;0;463;1
WireConnection;464;1;463;2
WireConnection;464;2;463;3
WireConnection;376;0;331;0
WireConnection;376;1;375;0
WireConnection;365;0;396;0
WireConnection;368;0;397;0
WireConnection;336;0;331;0
WireConnection;336;1;335;0
WireConnection;342;0;341;0
WireConnection;420;1;421;0
WireConnection;453;0;464;0
WireConnection;454;0;452;0
WireConnection;364;0;336;1
WireConnection;364;1;365;0
WireConnection;377;0;376;1
WireConnection;377;1;368;0
WireConnection;417;0;342;0
WireConnection;422;0;420;0
WireConnection;455;0;454;0
WireConnection;455;1;453;0
WireConnection;366;0;364;0
WireConnection;369;0;377;0
WireConnection;343;0;417;0
WireConnection;424;0;422;0
WireConnection;456;0;455;0
WireConnection;370;0;376;2
WireConnection;370;1;369;0
WireConnection;367;0;336;2
WireConnection;367;1;366;0
WireConnection;344;0;343;0
WireConnection;344;1;424;0
WireConnection;398;0;7;0
WireConnection;458;0;456;0
WireConnection;458;1;456;0
WireConnection;383;0;370;0
WireConnection;383;1;382;0
WireConnection;381;0;367;0
WireConnection;381;1;382;0
WireConnection;51;1;85;0
WireConnection;51;2;407;0
WireConnection;51;3;408;0
WireConnection;428;0;344;0
WireConnection;466;87;458;0
WireConnection;466;79;217;0
WireConnection;466;80;220;0
WireConnection;466;81;218;0
WireConnection;466;82;219;0
WireConnection;52;0;51;0
WireConnection;432;0;381;0
WireConnection;432;1;383;0
WireConnection;436;2;435;0
WireConnection;393;0;381;0
WireConnection;393;1;405;5
WireConnection;384;0;383;0
WireConnection;384;1;425;5
WireConnection;237;0;466;0
WireConnection;237;1;242;0
WireConnection;406;0;52;0
WireConnection;433;0;432;0
WireConnection;433;1;430;0
WireConnection;433;2;436;6
WireConnection;378;0;393;0
WireConnection;378;1;384;0
WireConnection;211;0;237;0
WireConnection;53;0;406;0
WireConnection;337;0;433;0
WireConnection;429;0;378;0
WireConnection;429;1;430;0
WireConnection;234;0;211;0
WireConnection;401;2;400;0
WireConnection;431;0;429;0
WireConnection;59;0;401;6
WireConnection;59;1;56;0
WireConnection;59;2;404;0
WireConnection;410;0;409;0
WireConnection;410;1;411;5
WireConnection;419;0;418;5
WireConnection;419;1;3;5
WireConnection;245;0;229;0
WireConnection;245;1;427;0
WireConnection;60;0;59;0
WireConnection;43;0;419;0
WireConnection;43;1;410;0
WireConnection;43;2;338;0
WireConnection;43;3;245;0
WireConnection;61;0;60;0
WireConnection;80;0;43;0
WireConnection;399;2;190;0
WireConnection;0;0;399;0
WireConnection;0;2;81;0
WireConnection;0;3;2;0
WireConnection;0;4;1;0
WireConnection;0;9;62;0
ASEEND*/
//CHKSM=C019B655C77208F1BA0B490B3D16B1CB27C2FDD5