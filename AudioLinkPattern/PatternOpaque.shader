// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/PatternOpaque"
{
	Properties
	{
		_Mask1("Mask1", 2D) = "white" {}
		_TilingMask1("Tiling Mask 1", Vector) = (1,1,0,0)
		_PannerMask1("Panner Mask 1", Vector) = (0,0,0,0)
		_Mask2("Mask2", 2D) = "white" {}
		_TilingMask2("Tiling Mask 2", Vector) = (1,1,0,0)
		_PannerMask2("Panner Mask 2", Vector) = (0,0,0,0)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_MaincolorRedchannel1("Main color - Red channel 1", Color) = (0.5754717,0.5754717,0.5754717,0)
		_MaincolorRedchannel2("Main color - Red channel 2", Color) = (0.2264151,0.2264151,0.2264151,0)
		_Metallic("Metallic", Float) = 1
		_SmoothnessRedChannel1("Smoothness - Red Channel 1", Float) = 0.8
		_SmoothnessRedChannel2("Smoothness - Red Channel 2", Float) = 0.8
		_NoAudioLinkHUE("No AudioLink - HUE", Range( 0 , 1)) = 0
		_NoAudioLinkSaturation("No AudioLink - Saturation", Range( 0 , 1)) = 0
		_Emissiveboost("Emissive boost", Range( 0 , 20)) = 1
		_Trippyness("Trippyness", Range( 1 , 200)) = 1
		_VideoscreenAnimationspeed("Video screen - Animation speed", Range( -1 , 1)) = 0
		_VideoscreenLerp("Video screen - Lerp", Range( 0 , 1)) = 0
		_LCD("LCD", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  "LTCGI"="ALWAYS" }
		Cull Off
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
			half ASEIsFrontFacing : VFACE;
			float2 uv2_texcoord2;
		};

		uniform float4 _MaincolorRedchannel1;
		uniform sampler2D _Mask1;
		uniform float2 _PannerMask1;
		uniform float2 _TilingMask1;
		uniform sampler2D _Mask2;
		uniform float2 _PannerMask2;
		uniform float2 _TilingMask2;
		uniform float4 _MaincolorRedchannel2;
		uniform sampler2D _LCD;
		uniform float4 _LCD_ST;
		uniform float _Emissiveboost;
		uniform float _VideoscreenLerp;
		uniform float _Trippyness;
		uniform float _NoAudioLinkHUE;
		uniform float _NoAudioLinkSaturation;
		uniform sampler2D _Udon_VideoTex;
		uniform float _VideoscreenAnimationspeed;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _SmoothnessRedChannel1;
		uniform float _SmoothnessRedChannel2;
		uniform float _Metallic;


		float IfAudioLinkv2Exists1_g124(  )
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


		float IfAudioLinkv2Exists1_g33(  )
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


		inline float AudioLinkLerp3_g30( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g32( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g26( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g28( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord343 = i.uv_texcoord * _TilingMask1;
			float2 panner347 = ( 1.0 * _Time.y * _PannerMask1 + uv_TexCoord343);
			float4 tex2DNode17 = tex2D( _Mask1, panner347 );
			float2 uv_TexCoord345 = i.uv_texcoord * _TilingMask2;
			float2 panner348 = ( 1.0 * _Time.y * _PannerMask2 + uv_TexCoord345);
			float4 tex2DNode2 = tex2D( _Mask2, panner348 );
			float MainMask310 = ( tex2DNode17.r * tex2DNode2.r );
			float4 Albedo336 = ( ( _MaincolorRedchannel1 * ( 1.0 - MainMask310 ) ) + ( MainMask310 * _MaincolorRedchannel2 ) );
			o.Albedo = Albedo336.rgb;
			float2 uv_LCD = i.uv_texcoord * _LCD_ST.xy + _LCD_ST.zw;
			float localIfAudioLinkv2Exists1_g124 = IfAudioLinkv2Exists1_g124();
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV1_g127 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g127 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1_g127, 7.0 ) );
			float fresnelNdotV2_g127 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2_g127 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV2_g127 , 0.0001 ), -12.0 ) );
			float switchResult4_g127 = (((i.ASEIsFrontFacing>0)?(fresnelNode1_g127):(fresnelNode2_g127)));
			float localIfAudioLinkv2Exists1_g33 = IfAudioLinkv2Exists1_g33();
			int Band3_g30 = (int)0.0;
			float temp_output_16_0_g1 = 128.0;
			float2 temp_output_34_0_g1 = float2( 1,0 );
			float2 break16_g29 = temp_output_34_0_g1;
			float Delay3_g30 = ( temp_output_16_0_g1 * ( ( i.uv_texcoord.x * break16_g29.x ) + ( i.uv_texcoord.y * break16_g29.y ) ) );
			float localAudioLinkLerp3_g30 = AudioLinkLerp3_g30( Band3_g30 , Delay3_g30 );
			float4 color21_g1 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			int Band3_g32 = (int)1.0;
			float2 break16_g31 = temp_output_34_0_g1;
			float Delay3_g32 = ( temp_output_16_0_g1 * ( ( i.uv_texcoord.x * break16_g31.x ) + ( i.uv_texcoord.y * break16_g31.y ) ) );
			float localAudioLinkLerp3_g32 = AudioLinkLerp3_g32( Band3_g32 , Delay3_g32 );
			float4 color27_g1 = IsGammaSpace() ? float4(1,0.5767992,0,0) : float4(1,0.2921353,0,0);
			int Band3_g26 = (int)2.0;
			float2 break16_g25 = temp_output_34_0_g1;
			float Delay3_g26 = ( temp_output_16_0_g1 * ( ( i.uv_texcoord.x * break16_g25.x ) + ( i.uv_texcoord.y * break16_g25.y ) ) );
			float localAudioLinkLerp3_g26 = AudioLinkLerp3_g26( Band3_g26 , Delay3_g26 );
			float4 color28_g1 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
			int Band3_g28 = (int)3.0;
			float2 break16_g27 = temp_output_34_0_g1;
			float Delay3_g28 = ( temp_output_16_0_g1 * ( ( i.uv_texcoord.x * break16_g27.x ) + ( i.uv_texcoord.y * break16_g27.y ) ) );
			float localAudioLinkLerp3_g28 = AudioLinkLerp3_g28( Band3_g28 , Delay3_g28 );
			float4 color29_g1 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
			float4 temp_output_322_0 = ( localIfAudioLinkv2Exists1_g33 * min( ( ( localAudioLinkLerp3_g30 * color21_g1 ) + ( localAudioLinkLerp3_g32 * color27_g1 ) + ( localAudioLinkLerp3_g26 * color28_g1 ) + ( localAudioLinkLerp3_g28 * color29_g1 ) ) , float4( 1,1,1,0 ) ) );
			float AudioLinkMask311 = ( tex2DNode17.g * tex2DNode2.g );
			float4 temp_cast_6 = (AudioLinkMask311).xxxx;
			float4 temp_output_3_0_g121 = ( temp_cast_6 * temp_output_322_0 );
			float grayscale4_g121 = (temp_output_3_0_g121.xyz.r + temp_output_3_0_g121.xyz.g + temp_output_3_0_g121.xyz.b) / 3;
			float Trippyness325 = _Trippyness;
			float fresnelNdotV1_g126 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g126 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1_g126, 7.0 ) );
			float fresnelNdotV2_g126 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2_g126 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV2_g126 , 0.0001 ), -12.0 ) );
			float switchResult4_g126 = (((i.ASEIsFrontFacing>0)?(fresnelNode1_g126):(fresnelNode2_g126)));
			float3 hsvTorgb174 = HSVToRGB( float3(_NoAudioLinkHUE,_NoAudioLinkSaturation,1.0) );
			float NoAudioLinkMask312 = ( tex2DNode17.b * tex2DNode2.b );
			float4 ifLocalVar202 = 0;
			if( localIfAudioLinkv2Exists1_g124 > 0.5 )
				ifLocalVar202 = ( ( saturate( switchResult4_g127 ) * temp_output_322_0 * 2.0 ) + ( temp_output_3_0_g121 * saturate( sin( ( grayscale4_g121 * Trippyness325 ) ) ) ) );
			else if( localIfAudioLinkv2Exists1_g124 < 0.5 )
				ifLocalVar202 = ( ( saturate( switchResult4_g126 ) * float4( hsvTorgb174 , 0.0 ) * 2.0 ) + float4( ( hsvTorgb174 * NoAudioLinkMask312 ) , 0.0 ) );
			float fresnelNdotV1_g128 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g128 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1_g128, 7.0 ) );
			float fresnelNdotV2_g128 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2_g128 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV2_g128 , 0.0001 ), -12.0 ) );
			float switchResult4_g128 = (((i.ASEIsFrontFacing>0)?(fresnelNode1_g128):(fresnelNode2_g128)));
			float2 uv_TexCoord250 = i.uv_texcoord * float2( 0.69,0.69 ) + float2( 0.156,0.156 );
			float cos248 = cos( ( _VideoscreenAnimationspeed * _Time.y ) );
			float sin248 = sin( ( _VideoscreenAnimationspeed * _Time.y ) );
			float2 rotator248 = mul( uv_TexCoord250 - float2( 0.5,0.5 ) , float2x2( cos248 , -sin248 , sin248 , cos248 )) + float2( 0.5,0.5 );
			float4 tex2DNode223 = tex2D( _Udon_VideoTex, rotator248 );
			float4 temp_cast_12 = (AudioLinkMask311).xxxx;
			float4 temp_output_3_0_g125 = ( temp_cast_12 * tex2DNode223 );
			float grayscale4_g125 = (temp_output_3_0_g125.xyz.r + temp_output_3_0_g125.xyz.g + temp_output_3_0_g125.xyz.b) / 3;
			float4 lerpResult309 = lerp( ifLocalVar202 , ( ( saturate( switchResult4_g128 ) * tex2DNode223 * 2.0 ) + ( temp_output_3_0_g125 * saturate( sin( ( grayscale4_g125 * Trippyness325 ) ) ) ) ) , _VideoscreenLerp);
			float4 ifLocalVar293 = 0;
			if( _VideoscreenLerp <= 0.01 )
				ifLocalVar293 = ifLocalVar202;
			else
				ifLocalVar293 = lerpResult309;
			float localLTCGI15_g129 = ( 0.0 );
			float3 worldPos15_g129 = ase_worldPos;
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 normalizeResult9_g129 = normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) ) )) );
			float3 worldNorm15_g129 = normalizeResult9_g129;
			float3 normalizeResult12_g129 = normalize( ( _WorldSpaceCameraPos - ase_worldPos ) );
			float3 cameraDir15_g129 = normalizeResult12_g129;
			float Smoothness333 = ( ( ( 1.0 - MainMask310 ) * _SmoothnessRedChannel1 ) + ( MainMask310 * _SmoothnessRedChannel2 ) );
			float roughness15_g129 = ( 1.0 - Smoothness333 );
			float2 lightmapUV15_g129 = i.uv2_texcoord2;
			float3 diffuse15_g129 = float3( 0,0,0 );
			float3 specular15_g129 = float3( 0,0,0 );
			float specularIntensity15_g129 = 0;
			{
			LTCGI_Contribution(worldPos15_g129, worldNorm15_g129, cameraDir15_g129, roughness15_g129, lightmapUV15_g129, diffuse15_g129, specular15_g129, specularIntensity15_g129);
			}
			o.Emission = ( ( tex2D( _LCD, uv_LCD ) * ( MainMask310 * _Emissiveboost * ifLocalVar293 ) ) + ( ( float4( diffuse15_g129 , 0.0 ) * Albedo336 ) + float4( ( specular15_g129 * specularIntensity15_g129 ) , 0.0 ) ) ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = Smoothness333;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.Vector2Node;341;-4258.992,60.59779;Inherit;False;Property;_TilingMask2;Tiling Mask 2;4;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;342;-4223.359,-448.8231;Inherit;False;Property;_TilingMask1;Tiling Mask 1;1;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;343;-4005.081,-438.9813;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;344;-3983.905,-265.3372;Inherit;False;Property;_PannerMask1;Panner Mask 1;2;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;345;-4017.433,55.83345;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;346;-3996.258,229.4772;Inherit;False;Property;_PannerMask2;Panner Mask 2;5;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;265;-3345.092,-404.641;Inherit;False;807.8257;834.0303;Masks;6;291;2;17;266;267;268;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;348;-3715.675,167.0078;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;347;-3703.322,-327.8067;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;17;-3253.831,-354.641;Inherit;True;Property;_Mask1;Mask1;0;0;Create;True;0;0;0;False;0;False;-1;ba199f114fe44dd4d915e0e53d91c0f7;22cff25f0026c6c4491db57e47153802;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-3255.193,153.7893;Inherit;True;Property;_Mask2;Mask2;3;0;Create;True;0;0;0;False;0;False;-1;22cff25f0026c6c4491db57e47153802;22cff25f0026c6c4491db57e47153802;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;266;-2798.993,-349.9491;Inherit;False;212;185;R;1;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2748.993,-299.9491;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;290;-1663.203,-767.7565;Inherit;False;685.5624;405.3629;Smoothness;8;286;287;288;285;118;289;318;316;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;267;-2795.562,-153.5596;Inherit;False;212;185;G;1;263;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-2108.762,1056.69;Inherit;False;2401.488;804.4845;Video Player;12;246;250;251;248;249;244;252;301;302;223;319;326;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;268;-2797.241,41.85443;Inherit;False;212;185;B;1;264;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;310;-2490.482,-293.5471;Inherit;False;MainMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;316;-1630.035,-716.9571;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-2753.396,-101.6009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;273;-2179.926,-113.8984;Inherit;False;775.953;483.9513;No AudioLink color;6;174;129;175;176;177;321;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-2757.035,95.77187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;251;-1360.165,1485.856;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;249;-1475.63,1248.866;Inherit;False;Constant;_VideoScreen_Offset;VideoScreen_Offset;14;0;Create;True;0;0;0;False;0;False;0.156,0.156;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;252;-1472.986,1386.814;Inherit;False;Property;_VideoscreenAnimationspeed;Video screen - Animation speed;17;0;Create;False;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;244;-1474.63,1126.865;Inherit;False;Constant;_VideoScreen_Tiling;VideoScreen_Tiling;11;0;Create;True;0;0;0;False;0;False;0.69,0.69;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;324;-3278.401,-604.2853;Inherit;False;Property;_Trippyness;Trippyness;16;0;Create;True;0;0;0;False;0;False;1;1;1;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;318;-1527.772,-537.9583;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;286;-1458.192,-716.7566;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;323;-2911.948,487.9987;Inherit;False;1609.159;490.3383;AudioLink;5;320;322;297;271;327;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-2157.926,-56.645;Inherit;False;Property;_NoAudioLinkHUE;No AudioLink - HUE;13;0;Create;True;0;0;0;False;0;False;0;0.498;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;250;-1199.493,1198.866;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;-1136.986,1434.814;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;-2841.401,-566.2852;Inherit;False;Trippyness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-2173.926,30.35519;Inherit;False;Property;_NoAudioLinkSaturation;No AudioLink - Saturation;14;0;Create;False;0;0;0;False;0;False;0;0.49;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2163.926,115.3547;Inherit;False;Constant;_Brightness;Brightness;14;0;Create;True;0;0;0;False;0;False;1;1;0;21;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;-2501.631,84.24023;Inherit;False;NoAudioLinkMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;-2480.971,-93.1853;Inherit;False;AudioLinkMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;124;180.6715,-914.9078;Inherit;False;869.5521;647.1727;Albedo color;8;336;351;350;117;349;123;116;314;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-1618.203,-629.1384;Inherit;False;Property;_SmoothnessRedChannel1;Smoothness - Red Channel 1;11;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-1624.795,-461.3936;Inherit;False;Property;_SmoothnessRedChannel2;Smoothness - Red Channel 2;12;0;Create;True;0;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-1299.591,-713.3566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-1285.591,-511.9566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;174;-1858.335,-58.8985;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.81;False;2;FLOAT;0.57;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;321;-1861.764,128.005;Inherit;False;312;NoAudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;248;-877.7134,1256.159;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;322;-2376.948,594.9608;Inherit;False;M_GetRainbowTrack;-1;;1;a14bfb64767603a449f9acd9d7712fd0;0;2;34;FLOAT2;1,0;False;16;FLOAT;128;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-2066.277,692.8451;Inherit;False;325;Trippyness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;320;-2219.755,820.702;Inherit;False;311;AudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;314;192,-640;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;289;-1129.641,-591.1735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1631.336,102.627;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;223;-637.9742,1369.086;Inherit;True;Global;_Udon_VideoTex;_Udon_VideoTex;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;319;-615.2173,1709.144;Inherit;False;311;AudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;-655.4014,1611.715;Inherit;False;325;Trippyness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;297;-1876.637,797.0204;Inherit;False;M_Trippyness;-1;;121;d2f7279fe4c1992449d3442abc89e184;0;3;12;FLOAT;0;False;10;FLOAT4;0,0,0,0;False;11;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;123;368,-640;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;349;224,-448;Inherit;False;Property;_MaincolorRedchannel2;Main color - Red channel 2;9;0;Create;True;0;0;0;False;0;False;0.2264151,0.2264151,0.2264151,0;0.7075471,0.7075471,0.7075471,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;116;224,-864;Inherit;False;Property;_MaincolorRedchannel1;Main color - Red channel 1;8;0;Create;True;0;0;0;False;0;False;0.5754717,0.5754717,0.5754717,0;0.7075471,0.7075471,0.7075471,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;-1010.961,-578.5338;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;145;-1268.602,540.1812;Inherit;False;IsAudioLink;-1;;124;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;302;-289.9211,1623.028;Inherit;False;M_Trippyness;-1;;125;d2f7279fe4c1992449d3442abc89e184;0;3;12;FLOAT;0;False;10;FLOAT4;0,0,0,0;False;11;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;272;-1303.504,75.24719;Inherit;False;M_RimLight;-1;;126;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;271;-1573.79,577.5215;Inherit;True;M_RimLight;-1;;127;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;330;1746.376,226.2112;Inherit;False;1106.412;484.4373;LTCGI;8;329;281;278;338;276;277;284;334;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;528,-560;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;524.2233,-669.8458;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;202;-977.3711,545.7344;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;301;16.72701,1395.829;Inherit;True;M_RimLight;-1;;128;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;235;217.6817,472.006;Inherit;False;Property;_VideoscreenLerp;Video screen - Lerp;18;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;334;1779.824,364.3146;Inherit;False;333;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;351;699.163,-635.6988;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;309;612.854,901.2347;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;294;550.6734,593.5511;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;284;1887.101,486.3164;Inherit;True;Property;_BumpMap;BumpMap;6;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;277;1971.601,359.6286;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;336;829.2767,-635.287;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;293;879.0586,565.1937;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;1343.369,-140.7598;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;331;1055.082,7.690613;Inherit;False;Property;_Emissiveboost;Emissive boost;15;0;Create;True;0;0;0;False;0;False;1;1.96;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;276;2140.176,376.5371;Inherit;False;LTCGI_Contribution;-1;;129;d3ea6060590627141a6e856295f0e87c;0;2;18;SAMPLER2D;_Sampler18276;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;2236.454,296.7459;Inherit;False;336;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;1575.995,-48.67325;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;339;1681.201,-340.6763;Inherit;True;Property;_LCD;LCD;19;0;Create;True;0;0;0;False;0;False;-1;315db4ad6ec2f844690ad4fcc041a7cb;315db4ad6ec2f844690ad4fcc041a7cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;2511.573,430.4101;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;2490.269,285.5502;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;291;-2802.132,234.8902;Inherit;False;212;185;A;1;292;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;2109.342,-73.17719;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;329;2653.421,363.6614;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2757.132,285.8903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;2998.761,-66.51657;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;335;3048.92,54.7669;Inherit;False;333;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;3216.547,-0.2329187;Inherit;False;Property;_Metallic;Metallic;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;3107.215,-103.4677;Inherit;False;336;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3435.782,-104.9525;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyroP/PatternOpaque;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;5;False;;7;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;1;LTCGI=ALWAYS;False;0;0;False;;-1;0;False;;1;Include;Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;343;0;342;0
WireConnection;345;0;341;0
WireConnection;348;0;345;0
WireConnection;348;2;346;0
WireConnection;347;0;343;0
WireConnection;347;2;344;0
WireConnection;17;1;347;0
WireConnection;2;1;348;0
WireConnection;18;0;17;1
WireConnection;18;1;2;1
WireConnection;310;0;18;0
WireConnection;263;0;17;2
WireConnection;263;1;2;2
WireConnection;264;0;17;3
WireConnection;264;1;2;3
WireConnection;286;0;316;0
WireConnection;250;0;244;0
WireConnection;250;1;249;0
WireConnection;246;0;252;0
WireConnection;246;1;251;0
WireConnection;325;0;324;0
WireConnection;312;0;264;0
WireConnection;311;0;263;0
WireConnection;287;0;286;0
WireConnection;287;1;118;0
WireConnection;288;0;318;0
WireConnection;288;1;285;0
WireConnection;174;0;175;0
WireConnection;174;1;176;0
WireConnection;174;2;177;0
WireConnection;248;0;250;0
WireConnection;248;2;246;0
WireConnection;289;0;287;0
WireConnection;289;1;288;0
WireConnection;129;0;174;0
WireConnection;129;1;321;0
WireConnection;223;1;248;0
WireConnection;297;12;327;0
WireConnection;297;10;320;0
WireConnection;297;11;322;0
WireConnection;123;0;314;0
WireConnection;333;0;289;0
WireConnection;302;12;326;0
WireConnection;302;10;319;0
WireConnection;302;11;223;0
WireConnection;272;7;174;0
WireConnection;272;8;129;0
WireConnection;271;7;322;0
WireConnection;271;8;297;0
WireConnection;350;0;314;0
WireConnection;350;1;349;0
WireConnection;117;0;116;0
WireConnection;117;1;123;0
WireConnection;202;0;145;0
WireConnection;202;2;271;0
WireConnection;202;4;272;0
WireConnection;301;7;223;0
WireConnection;301;8;302;0
WireConnection;351;0;117;0
WireConnection;351;1;350;0
WireConnection;309;0;202;0
WireConnection;309;1;301;0
WireConnection;309;2;235;0
WireConnection;277;0;334;0
WireConnection;336;0;351;0
WireConnection;293;0;235;0
WireConnection;293;1;294;0
WireConnection;293;2;309;0
WireConnection;293;3;202;0
WireConnection;293;4;202;0
WireConnection;276;18;284;0
WireConnection;276;21;277;0
WireConnection;5;0;315;0
WireConnection;5;1;331;0
WireConnection;5;2;293;0
WireConnection;278;0;276;16
WireConnection;278;1;276;17
WireConnection;281;0;276;0
WireConnection;281;1;338;0
WireConnection;340;0;339;0
WireConnection;340;1;5;0
WireConnection;329;0;281;0
WireConnection;329;1;278;0
WireConnection;292;0;17;4
WireConnection;292;1;2;4
WireConnection;282;0;340;0
WireConnection;282;1;329;0
WireConnection;0;0;337;0
WireConnection;0;2;282;0
WireConnection;0;3;115;0
WireConnection;0;4;335;0
ASEEND*/
//CHKSM=8A3B0BB3549E941207CA8388DEC644E3638332C5