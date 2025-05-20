// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/PatternOpaque"
{
	Properties
	{
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
		_LCD("LCD", 2D) = "white" {}
		_RaveMode("RaveMode", Range( 0 , 1)) = 0
		_VideoscreenLerp("Video screen - Lerp", Range( 0 , 1)) = 0
		_Mask1("Mask1", 2D) = "white" {}
		[Toggle(_PULSATING_ON)] _Pulsating("Pulsating", Float) = 1
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
		#pragma shader_feature_local _PULSATING_ON
		#define ASE_VERSION 19801
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
		float4 _Mask1_TexelSize;
		uniform sampler2D _Mask2;
		uniform float2 _PannerMask2;
		uniform float2 _TilingMask2;
		uniform float4 _MaincolorRedchannel2;
		uniform sampler2D _LCD;
		uniform float4 _LCD_ST;
		uniform float _Emissiveboost;
		uniform float _NoAudioLinkHUE;
		uniform float _NoAudioLinkSaturation;
		uniform float _Trippyness;
		uniform float _RaveMode;
		uniform sampler2D _Udon_VideoTex;
		uniform float _VideoscreenAnimationspeed;
		uniform float _VideoscreenLerp;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _SmoothnessRedChannel1;
		uniform float _SmoothnessRedChannel2;
		uniform float _Metallic;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float IfAudioLinkv2Exists1_g145(  )
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


		inline float AudioLinkLerp3_g149( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g151( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g153( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		inline float AudioLinkLerp3_g147( int Band, float Delay )
		{
			return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
		}


		float IfAudioLinkv2Exists1_g156(  )
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


		float IfAudioLinkv2Exists1_g157(  )
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float localBicubicPrepare2_g143 = ( 0.0 );
			float2 uv_TexCoord343 = i.uv_texcoord * _TilingMask1;
			float2 panner347 = ( 1.0 * _Time.y * _PannerMask1 + uv_TexCoord343);
			float2 Input_UV100_g143 = panner347;
			float2 UV2_g143 = Input_UV100_g143;
			float4 TexelSize2_g143 = _Mask1_TexelSize;
			float2 UV02_g143 = float2( 0,0 );
			float2 UV12_g143 = float2( 0,0 );
			float2 UV22_g143 = float2( 0,0 );
			float2 UV32_g143 = float2( 0,0 );
			float W02_g143 = 0;
			float W12_g143 = 0;
			{
			{
			 UV2_g143 = UV2_g143 * TexelSize2_g143.zw - 0.5;
			    float2 f = frac( UV2_g143 );
			    UV2_g143 -= f;
			    float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
			    float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
			    float4 xs = xn * xn * xn;
			    float4 ys = yn * yn * yn;
			    float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
			    float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
			    float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
			 float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
			    float4 c = float4( UV2_g143.x - 0.5, UV2_g143.x + 1.5, UV2_g143.y - 0.5, UV2_g143.y + 1.5 );
			    float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
			    float4 off = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g143.xyxy;
			    UV02_g143 = off.xz;
			    UV12_g143 = off.yz;
			    UV22_g143 = off.xw;
			    UV32_g143 = off.yw;
			    W02_g143 = s.x / ( s.x + s.y );
			 W12_g143 = s.z / ( s.z + s.w );
			}
			}
			float4 lerpResult46_g143 = lerp( tex2D( _Mask1, UV32_g143 ) , tex2D( _Mask1, UV22_g143 ) , W02_g143);
			float4 lerpResult45_g143 = lerp( tex2D( _Mask1, UV12_g143 ) , tex2D( _Mask1, UV02_g143 ) , W02_g143);
			float4 lerpResult44_g143 = lerp( lerpResult46_g143 , lerpResult45_g143 , W12_g143);
			float4 Output_2D131_g143 = lerpResult44_g143;
			float4 break74_g143 = Output_2D131_g143;
			float4 temp_cast_0 = (break74_g143.r).xxxx;
			float2 uv_TexCoord345 = i.uv_texcoord * _TilingMask2;
			float2 panner348 = ( 1.0 * _Time.y * _PannerMask2 + uv_TexCoord345);
			float4 tex2DNode2 = tex2D( _Mask2, panner348 );
			float4 MainMask310 = ( saturate( CalculateContrast(5.0,temp_cast_0) ) * tex2DNode2.r );
			float4 Albedo336 = ( ( _MaincolorRedchannel1 * ( 1.0 - MainMask310 ) ) + ( MainMask310 * _MaincolorRedchannel2 ) );
			o.Albedo = Albedo336.rgb;
			float2 uv_LCD = i.uv_texcoord * _LCD_ST.xy + _LCD_ST.zw;
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV1_g159 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode1_g159 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1_g159, 7.0 ) );
			float fresnelNdotV2_g159 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode2_g159 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV2_g159 , 0.0001 ), -12.0 ) );
			float switchResult4_g159 = (((i.ASEIsFrontFacing>0)?(fresnelNode1_g159):(fresnelNode2_g159)));
			float3 hsvTorgb174 = HSVToRGB( float3(_NoAudioLinkHUE,_NoAudioLinkSaturation,1.0) );
			float NoAudioLinkMask312 = ( break74_g143.b * tex2DNode2.b );
			float fresnelNdotV1_g155 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode1_g155 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1_g155, 7.0 ) );
			float fresnelNdotV2_g155 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode2_g155 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV2_g155 , 0.0001 ), -12.0 ) );
			float switchResult4_g155 = (((i.ASEIsFrontFacing>0)?(fresnelNode1_g155):(fresnelNode2_g155)));
			float localIfAudioLinkv2Exists1_g145 = IfAudioLinkv2Exists1_g145();
			int Band3_g149 = (int)0.0;
			float temp_output_16_0_g144 = 128.0;
			float2 temp_output_87_0_g144 = i.uv_texcoord;
			float2 break18_g148 = temp_output_87_0_g144;
			float2 temp_output_34_0_g144 = float2( 1,0 );
			float2 break16_g148 = temp_output_34_0_g144;
			float Delay3_g149 = ( temp_output_16_0_g144 * ( ( break18_g148.x * break16_g148.x ) + ( break18_g148.y * break16_g148.y ) ) );
			float localAudioLinkLerp3_g149 = AudioLinkLerp3_g149( Band3_g149 , Delay3_g149 );
			int Band3_g151 = (int)1.0;
			float2 break18_g150 = temp_output_87_0_g144;
			float2 break16_g150 = temp_output_34_0_g144;
			float Delay3_g151 = ( temp_output_16_0_g144 * ( ( break18_g150.x * break16_g150.x ) + ( break18_g150.y * break16_g150.y ) ) );
			float localAudioLinkLerp3_g151 = AudioLinkLerp3_g151( Band3_g151 , Delay3_g151 );
			int Band3_g153 = (int)2.0;
			float2 break18_g152 = temp_output_87_0_g144;
			float2 break16_g152 = temp_output_34_0_g144;
			float Delay3_g153 = ( temp_output_16_0_g144 * ( ( break18_g152.x * break16_g152.x ) + ( break18_g152.y * break16_g152.y ) ) );
			float localAudioLinkLerp3_g153 = AudioLinkLerp3_g153( Band3_g153 , Delay3_g153 );
			int Band3_g147 = (int)3.0;
			float2 break18_g146 = temp_output_87_0_g144;
			float2 break16_g146 = temp_output_34_0_g144;
			float Delay3_g147 = ( temp_output_16_0_g144 * ( ( break18_g146.x * break16_g146.x ) + ( break18_g146.y * break16_g146.y ) ) );
			float localAudioLinkLerp3_g147 = AudioLinkLerp3_g147( Band3_g147 , Delay3_g147 );
			float4 temp_output_322_0 = ( localIfAudioLinkv2Exists1_g145 * min( ( ( localAudioLinkLerp3_g149 * float4( 1,0,0,0 ) ) + ( localAudioLinkLerp3_g151 * float4( 1,0.7058535,0,0 ) ) + ( localAudioLinkLerp3_g153 * float4( 0.1067042,1,0,0 ) ) + ( localAudioLinkLerp3_g147 * float4( 0,0.1044993,1,0 ) ) ) , float4( 1,1,1,0 ) ) );
			float AudioLinkMask311 = ( break74_g143.g * tex2DNode2.g );
			float4 temp_cast_9 = (AudioLinkMask311).xxxx;
			float4 temp_output_3_0_g154 = ( temp_cast_9 * temp_output_322_0 );
			float grayscale4_g154 = (temp_output_3_0_g154.xyz.r + temp_output_3_0_g154.xyz.g + temp_output_3_0_g154.xyz.b) / 3;
			float Trippyness325 = _Trippyness;
			float localIfAudioLinkv2Exists1_g156 = IfAudioLinkv2Exists1_g156();
			float localIfAudioLinkv2Exists1_g157 = IfAudioLinkv2Exists1_g157();
			float4 lerpResult357 = lerp( ( ( saturate( switchResult4_g159 ) * float4( hsvTorgb174 , 0.0 ) * 2.0 ) + float4( ( hsvTorgb174 * NoAudioLinkMask312 ) , 0.0 ) ) , ( ( ( saturate( switchResult4_g155 ) * temp_output_322_0 * 2.0 ) + ( temp_output_3_0_g154 * saturate( sin( ( grayscale4_g154 * Trippyness325 ) ) ) ) ) * localIfAudioLinkv2Exists1_g156 ) , ( _RaveMode * localIfAudioLinkv2Exists1_g157 ));
			float fresnelNdotV1_g160 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode1_g160 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1_g160, 7.0 ) );
			float fresnelNdotV2_g160 = dot( ase_normalWS, ase_viewDirWS );
			float fresnelNode2_g160 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV2_g160 , 0.0001 ), -12.0 ) );
			float switchResult4_g160 = (((i.ASEIsFrontFacing>0)?(fresnelNode1_g160):(fresnelNode2_g160)));
			float2 uv_TexCoord250 = i.uv_texcoord * float2( 0.69,0.69 ) + float2( 0.156,0.156 );
			float cos248 = cos( ( _VideoscreenAnimationspeed * _Time.y ) );
			float sin248 = sin( ( _VideoscreenAnimationspeed * _Time.y ) );
			float2 rotator248 = mul( uv_TexCoord250 - float2( 0.5,0.5 ) , float2x2( cos248 , -sin248 , sin248 , cos248 )) + float2( 0.5,0.5 );
			float4 tex2DNode223 = tex2D( _Udon_VideoTex, rotator248 );
			float4 temp_cast_13 = (AudioLinkMask311).xxxx;
			float4 temp_output_3_0_g158 = ( temp_cast_13 * tex2DNode223 );
			float grayscale4_g158 = (temp_output_3_0_g158.xyz.r + temp_output_3_0_g158.xyz.g + temp_output_3_0_g158.xyz.b) / 3;
			float4 lerpResult359 = lerp( lerpResult357 , ( ( saturate( switchResult4_g160 ) * tex2DNode223 * 2.0 ) + ( temp_output_3_0_g158 * saturate( sin( ( grayscale4_g158 * Trippyness325 ) ) ) ) ) , _VideoscreenLerp);
			float3 normalizeResult373 = normalize( ase_viewDirWS );
			float3 ase_normalOS = mul( unity_WorldToObject, float4( ase_normalWS, 0 ) );
			ase_normalOS = normalize( ase_normalOS );
			float3 switchResult392 = (((i.ASEIsFrontFacing>0)?(ase_normalOS):(-ase_normalOS)));
			float4 transform369 = mul(unity_ObjectToWorld,float4( switchResult392 , 0.0 ));
			float3 appendResult370 = (float3(transform369.x , transform369.y , transform369.z));
			float3 normalizeResult372 = normalize( appendResult370 );
			float dotResult374 = dot( normalizeResult373 , normalizeResult372 );
			float mulTime377 = _Time.y * 20.0;
			#ifdef _PULSATING_ON
				float staticSwitch402 = ( ( saturate( ( ( sin( ( ( ( dotResult374 * 20.0 ) + mulTime377 ) * 0.09782609 ) ) - 0.93 ) * ( 0.93 * 10.0 ) ) ) * 3.0 ) + 1.0 );
			#else
				float staticSwitch402 = 1.0;
			#endif
			float middleToEdgeIntensity388 = staticSwitch402;
			float localLTCGI15_g161 = ( 0.0 );
			float3 worldPos15_g161 = ase_positionWS;
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 newWorldNormal7_g161 = normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) ) )) );
			float3 switchResult23_g161 = (((i.ASEIsFrontFacing>0)?(newWorldNormal7_g161):(-newWorldNormal7_g161)));
			float3 worldNorm15_g161 = switchResult23_g161;
			float3 normalizeResult12_g161 = normalize( ( _WorldSpaceCameraPos - ase_positionWS ) );
			float3 cameraDir15_g161 = normalizeResult12_g161;
			float4 Smoothness333 = ( ( ( 1.0 - MainMask310 ) * _SmoothnessRedChannel1 ) + ( MainMask310 * _SmoothnessRedChannel2 ) );
			float roughness15_g161 = ( 1.0 - Smoothness333 ).r;
			float2 lightmapUV15_g161 = i.uv2_texcoord2;
			float3 diffuse15_g161 = float3( 0,0,0 );
			float3 specular15_g161 = float3( 0,0,0 );
			float specularIntensity15_g161 = 0;
			{
			LTCGI_Contribution(worldPos15_g161, worldNorm15_g161, cameraDir15_g161, roughness15_g161, lightmapUV15_g161, diffuse15_g161, specular15_g161, specularIntensity15_g161);
			}
			o.Emission = ( ( tex2D( _LCD, uv_LCD ) * ( MainMask310 * _Emissiveboost * lerpResult359 * middleToEdgeIntensity388 ) ) + ( ( float4( diffuse15_g161 , 0.0 ) * Albedo336 ) + float4( ( specular15_g161 * specularIntensity15_g161 ) , 0.0 ) ) ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = Smoothness333.r;
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
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.NormalVertexDataNode;391;-1060.008,2680.885;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;393;-891.4531,2766.996;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;392;-766.4531,2682.996;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;342;-4223.359,-448.8231;Inherit;False;Property;_TilingMask1;Tiling Mask 1;0;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;369;-566.7314,2493.209;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;343;-4005.081,-438.9813;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;344;-3983.905,-265.3372;Inherit;False;Property;_PannerMask1;Panner Mask 1;1;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;370;-390.7313,2493.209;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;371;-365.1654,2304.077;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;341;-4258.992,60.59779;Inherit;False;Property;_TilingMask2;Tiling Mask 2;3;0;Create;True;0;0;0;False;0;False;1,1;9.923,9.923;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;265;-3345.092,-404.641;Inherit;False;807.8257;834.0303;Masks;9;291;2;266;267;268;394;398;399;400;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;347;-3703.322,-327.8067;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;395;-3495.075,-319.3131;Inherit;True;Property;_Mask1;Mask1;20;0;Create;True;0;0;0;False;0;False;8d44a859d64aa854ab00f05f5655a95e;8d44a859d64aa854ab00f05f5655a95e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.NormalizeNode;372;-157.1654,2480.077;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;373;-125.1654,2352.077;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;345;-4017.433,55.83345;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;346;-3996.258,229.4772;Inherit;False;Property;_PannerMask2;Panner Mask 2;4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;394;-3226.075,-142.3131;Inherit;True;Bicubic Sample;-1;;143;ce0e14d5ad5eac645b2e5892ab3506ff;2,92,0,72,0;7;99;SAMPLER2D;0;False;91;SAMPLER2DARRAY;0;False;93;FLOAT;0;False;97;FLOAT2;0,0;False;198;FLOAT4;0,0,0,0;False;199;FLOAT2;0,0;False;94;SAMPLERSTATE;0;False;5;COLOR;86;FLOAT;84;FLOAT;85;FLOAT;82;FLOAT;83
Node;AmplifyShaderEditor.RangedFloatNode;398;-3424.833,-387.6261;Inherit;False;Constant;_Float4;Float 4;25;0;Create;True;0;0;0;False;0;False;5;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;374;73.26868,2493.209;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;375;-86.73132,2605.209;Inherit;False;Constant;_Tiling;Tiling;0;0;Create;True;0;0;0;False;0;False;20;15.66522;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;348;-3715.675,167.0078;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;399;-3091.382,-317.8144;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;376;249.2687,2493.209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;377;41.26868,2733.209;Inherit;False;1;0;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3255.193,153.7893;Inherit;True;Property;_Mask2;Mask2;2;0;Create;True;0;0;0;False;0;False;-1;22cff25f0026c6c4491db57e47153802;22cff25f0026c6c4491db57e47153802;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;266;-2798.993,-349.9491;Inherit;False;212;185;R;1;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;400;-2913.274,-265.6498;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;378;409.2687,2493.209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;379;41.26868,2845.21;Inherit;False;Constant;_middleEdgeThickness;middleEdgeThickness;23;0;Create;True;0;0;0;False;0;False;0.09782609;0.2634824;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2748.993,-299.9491;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;380;521.2689,2493.209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;290;-1663.203,-767.7565;Inherit;False;685.5624;405.3629;Smoothness;8;286;287;288;285;118;289;318;316;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;310;-2490.482,-293.5471;Inherit;False;MainMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;267;-2795.562,-153.5596;Inherit;False;212;185;G;1;263;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;381;665.2689,2493.209;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;382;489.2686,2765.21;Inherit;False;Constant;_spacing;spacing;23;0;Create;True;0;0;0;False;0;False;0.93;0.9940453;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;308;-2108.762,1056.69;Inherit;False;2401.488;804.4845;Video Player;12;246;250;251;248;249;244;252;301;302;223;319;326;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;268;-2797.241,41.85443;Inherit;False;212;185;B;1;264;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;316;-1630.035,-716.9571;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-2753.396,-101.6009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;324;-3278.401,-604.2853;Inherit;False;Property;_Trippyness;Trippyness;15;0;Create;True;0;0;0;False;0;False;1;1;1;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;383;841.2689,2493.209;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;384;921.2689,2781.21;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;251;-1360.165,1485.856;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;249;-1475.63,1248.866;Inherit;False;Constant;_VideoScreen_Offset;VideoScreen_Offset;14;0;Create;True;0;0;0;False;0;False;0.156,0.156;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;252;-1472.986,1386.814;Inherit;False;Property;_VideoscreenAnimationspeed;Video screen - Animation speed;16;0;Create;False;0;0;0;False;0;False;0;0.2;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;244;-1474.63,1126.865;Inherit;False;Constant;_VideoScreen_Tiling;VideoScreen_Tiling;11;0;Create;True;0;0;0;False;0;False;0.69,0.69;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;273;-2179.926,-113.8984;Inherit;False;775.953;483.9513;No AudioLink color;6;174;129;175;176;177;321;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-2757.035,95.77187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;318;-1527.772,-537.9583;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;286;-1458.192,-716.7566;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;124;180.6715,-914.9078;Inherit;False;869.5521;647.1727;Albedo color;8;336;351;350;117;349;123;116;314;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-1618.203,-629.1384;Inherit;False;Property;_SmoothnessRedChannel1;Smoothness - Red Channel 1;10;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-1624.795,-461.3936;Inherit;False;Property;_SmoothnessRedChannel2;Smoothness - Red Channel 2;11;0;Create;True;0;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;323;-2911.948,487.9987;Inherit;False;1609.159;490.3383;AudioLink;7;320;322;297;271;327;356;145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;-2841.401,-566.2852;Inherit;False;Trippyness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;-2480.971,-93.1853;Inherit;False;AudioLinkMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;401;-3152,624;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;385;1177.269,2557.209;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;250;-1199.493,1198.866;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;-1136.986,1434.814;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-2157.926,-56.645;Inherit;False;Property;_NoAudioLinkHUE;No AudioLink - HUE;12;0;Create;True;0;0;0;False;0;False;0;0.037;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-2173.926,30.35519;Inherit;False;Property;_NoAudioLinkSaturation;No AudioLink - Saturation;13;0;Create;False;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2163.926,115.3547;Inherit;False;Constant;_Brightness;Brightness;14;0;Create;True;0;0;0;False;0;False;1;1;0;21;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;-2501.631,84.24023;Inherit;False;NoAudioLinkMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-1299.591,-713.3566;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-1285.591,-511.9566;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;314;192,-640;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;322;-2833.658,635.7137;Inherit;False;M_GetRainbowTrack;-1;;144;a14bfb64767603a449f9acd9d7712fd0;0;7;87;FLOAT2;0,0;False;79;COLOR;1,0,0,0;False;80;COLOR;1,0.7058535,0,0;False;81;COLOR;0.1067042,1,0,0;False;82;COLOR;0,0.1044993,1,0;False;34;FLOAT2;1,0;False;16;FLOAT;128;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-2522.987,733.598;Inherit;False;325;Trippyness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;320;-2676.465,861.455;Inherit;False;311;AudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;386;1382.269,2557.209;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;248;-877.7134,1256.159;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.HSVToRGBNode;174;-1858.335,-58.8985;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.81;False;2;FLOAT;0.57;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;321;-1861.764,128.005;Inherit;False;312;NoAudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;289;-1129.641,-591.1735;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;123;368,-640;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;349;224,-448;Inherit;False;Property;_MaincolorRedchannel2;Main color - Red channel 2;8;0;Create;True;0;0;0;False;0;False;0.2264151,0.2264151,0.2264151,0;0.08627433,0.08627433,0.08627433,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;116;224,-864;Inherit;False;Property;_MaincolorRedchannel1;Main color - Red channel 1;7;0;Create;True;0;0;0;False;0;False;0.5754717,0.5754717,0.5754717,0;0.6784314,0.6784314,0.6784314,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode;297;-2333.347,837.7733;Inherit;False;M_Trippyness;-1;;154;d2f7279fe4c1992449d3442abc89e184;0;3;12;FLOAT;0;False;10;FLOAT4;0,0,0,0;False;11;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;390;1558.029,2571.792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;223;-637.9742,1369.086;Inherit;True;Global;_Udon_VideoTex;_Udon_VideoTex;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;319;-615.2173,1709.144;Inherit;False;311;AudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;-655.4014,1611.715;Inherit;False;325;Trippyness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1631.336,102.627;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;-1010.961,-578.5338;Inherit;False;Smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;330;1746.376,226.2112;Inherit;False;1106.412;484.4373;LTCGI;8;329;281;278;338;276;277;284;334;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;528,-560;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;524.2233,-669.8458;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;271;-2030.5,618.2744;Inherit;True;M_RimLight;-1;;155;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;145;-2002.149,884.4707;Inherit;False;IsAudioLink;-1;;156;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;361;-1021.077,470.8717;Inherit;False;Property;_RaveMode;RaveMode;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;362;-946.8696,589.2898;Inherit;False;IsAudioLink;-1;;157;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;1748.268,2574.209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;403;1514.835,2312.759;Inherit;False;Constant;_Float5;Float 5;22;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;302;-289.9211,1623.028;Inherit;False;M_Trippyness;-1;;158;d2f7279fe4c1992449d3442abc89e184;0;3;12;FLOAT;0;False;10;FLOAT4;0,0,0,0;False;11;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;272;-1303.504,75.24719;Inherit;False;M_RimLight;-1;;159;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;334;1779.824,364.3146;Inherit;False;333;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;351;699.163,-635.6988;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;-1728.146,703.937;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;360;-669.445,450.0863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;402;1872,2544;Inherit;False;Property;_Pulsating;Pulsating;21;0;Create;True;0;0;0;False;0;False;0;1;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;301;16.72701,1395.829;Inherit;True;M_RimLight;-1;;160;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;284;1887.101,486.3164;Inherit;True;Property;_BumpMap;BumpMap;5;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;277;1971.601,359.6286;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;336;829.2767,-635.287;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;357;-546.4376,289.3204;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;358;-415.1818,507.9221;Inherit;False;Property;_VideoscreenLerp;Video screen - Lerp;19;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;388;2144,2576;Inherit;False;middleToEdgeIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;276;2140.176,376.5371;Inherit;False;LTCGI_Contribution;-1;;161;d3ea6060590627141a6e856295f0e87c;0;2;18;SAMPLER2D;_Sampler18276;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;2236.454,296.7459;Inherit;False;336;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;331;1026.082,-33.30939;Inherit;False;Property;_Emissiveboost;Emissive boost;14;0;Create;True;0;0;0;False;0;False;1;2;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;359;10.18083,281.4583;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;1343.369,-140.7598;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;389;1235.656,191.8207;Inherit;False;388;middleToEdgeIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;1575.995,-48.67325;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;339;1681.201,-340.6763;Inherit;True;Property;_LCD;LCD;17;0;Create;True;0;0;0;False;0;False;-1;315db4ad6ec2f844690ad4fcc041a7cb;315db4ad6ec2f844690ad4fcc041a7cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;2511.573,430.4101;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;2490.269,285.5502;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;291;-2802.132,234.8902;Inherit;False;212;185;A;1;292;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;2109.342,-73.17719;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;329;2653.421,363.6614;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2757.132,285.8903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;2998.761,-66.51657;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;335;3048.92,54.7669;Inherit;False;333;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;115;3216.547,-0.2329187;Inherit;False;Property;_Metallic;Metallic;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;3107.215,-103.4677;Inherit;False;336;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3435.782,-104.9525;Float;False;True;-1;2;AmplifyShaderEditor.MaterialInspector;0;0;Standard;MyroP/PatternOpaque;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;5;False;;7;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;-1;1;LTCGI=ALWAYS;False;0;0;False;;-1;0;False;;1;Include;Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;393;0;391;0
WireConnection;392;0;391;0
WireConnection;392;1;393;0
WireConnection;369;0;392;0
WireConnection;343;0;342;0
WireConnection;370;0;369;1
WireConnection;370;1;369;2
WireConnection;370;2;369;3
WireConnection;347;0;343;0
WireConnection;347;2;344;0
WireConnection;372;0;370;0
WireConnection;373;0;371;0
WireConnection;345;0;341;0
WireConnection;394;99;395;0
WireConnection;394;97;347;0
WireConnection;374;0;373;0
WireConnection;374;1;372;0
WireConnection;348;0;345;0
WireConnection;348;2;346;0
WireConnection;399;1;394;84
WireConnection;399;0;398;0
WireConnection;376;0;374;0
WireConnection;376;1;375;0
WireConnection;2;1;348;0
WireConnection;400;0;399;0
WireConnection;378;0;376;0
WireConnection;378;1;377;0
WireConnection;18;0;400;0
WireConnection;18;1;2;1
WireConnection;380;0;378;0
WireConnection;380;1;379;0
WireConnection;310;0;18;0
WireConnection;381;0;380;0
WireConnection;263;0;394;85
WireConnection;263;1;2;2
WireConnection;383;0;381;0
WireConnection;383;1;382;0
WireConnection;384;0;382;0
WireConnection;264;0;394;82
WireConnection;264;1;2;3
WireConnection;286;0;316;0
WireConnection;325;0;324;0
WireConnection;311;0;263;0
WireConnection;385;0;383;0
WireConnection;385;1;384;0
WireConnection;250;0;244;0
WireConnection;250;1;249;0
WireConnection;246;0;252;0
WireConnection;246;1;251;0
WireConnection;312;0;264;0
WireConnection;287;0;286;0
WireConnection;287;1;118;0
WireConnection;288;0;318;0
WireConnection;288;1;285;0
WireConnection;322;87;401;0
WireConnection;386;0;385;0
WireConnection;248;0;250;0
WireConnection;248;2;246;0
WireConnection;174;0;175;0
WireConnection;174;1;176;0
WireConnection;174;2;177;0
WireConnection;289;0;287;0
WireConnection;289;1;288;0
WireConnection;123;0;314;0
WireConnection;297;12;327;0
WireConnection;297;10;320;0
WireConnection;297;11;322;0
WireConnection;390;0;386;0
WireConnection;223;1;248;0
WireConnection;129;0;174;0
WireConnection;129;1;321;0
WireConnection;333;0;289;0
WireConnection;350;0;314;0
WireConnection;350;1;349;0
WireConnection;117;0;116;0
WireConnection;117;1;123;0
WireConnection;271;7;322;0
WireConnection;271;8;297;0
WireConnection;387;0;390;0
WireConnection;302;12;326;0
WireConnection;302;10;319;0
WireConnection;302;11;223;0
WireConnection;272;7;174;0
WireConnection;272;8;129;0
WireConnection;351;0;117;0
WireConnection;351;1;350;0
WireConnection;356;0;271;0
WireConnection;356;1;145;0
WireConnection;360;0;361;0
WireConnection;360;1;362;0
WireConnection;402;1;403;0
WireConnection;402;0;387;0
WireConnection;301;7;223;0
WireConnection;301;8;302;0
WireConnection;277;0;334;0
WireConnection;336;0;351;0
WireConnection;357;0;272;0
WireConnection;357;1;356;0
WireConnection;357;2;360;0
WireConnection;388;0;402;0
WireConnection;276;18;284;0
WireConnection;276;21;277;0
WireConnection;359;0;357;0
WireConnection;359;1;301;0
WireConnection;359;2;358;0
WireConnection;5;0;315;0
WireConnection;5;1;331;0
WireConnection;5;2;359;0
WireConnection;5;3;389;0
WireConnection;278;0;276;16
WireConnection;278;1;276;17
WireConnection;281;0;276;0
WireConnection;281;1;338;0
WireConnection;340;0;339;0
WireConnection;340;1;5;0
WireConnection;329;0;281;0
WireConnection;329;1;278;0
WireConnection;292;0;394;83
WireConnection;292;1;2;4
WireConnection;282;0;340;0
WireConnection;282;1;329;0
WireConnection;0;0;337;0
WireConnection;0;2;282;0
WireConnection;0;3;115;0
WireConnection;0;4;335;0
ASEEND*/
//CHKSM=14DBE1DB29693F65A627AE278617DEF57BE1837A