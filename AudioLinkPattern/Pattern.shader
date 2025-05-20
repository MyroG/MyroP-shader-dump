// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/Pattern"
{
	Properties
	{
		_TilingMask1("Tiling Mask 1", Vector) = (1,1,0,0)
		_PannerMask1("Panner Mask 1", Vector) = (0,0,0,0)
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
		_Opacity("Opacity", Float) = 0.5
		_Emissiveboost("Emissive boost", Range( 0 , 20)) = 0
		_Trippyness("Trippyness", Range( 1 , 200)) = 1
		_RaveMode("RaveMode", Range( 0 , 1)) = 0
		_VideoscreenAnimationspeed("Video screen - Animation speed", Range( -1 , 1)) = 0
		_VideoscreenLerp("Video screen - Lerp", Range( 0 , 1)) = 0
		_Mask2("Mask 2", 2D) = "white" {}
		[Toggle(_PULSATING_ON)] _Pulsating("Pulsating", Float) = 1
		_Mask1("Mask1", 2D) = "white" {}
		_Float4("Float 4", Range( 0 , 10)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  "LTCGI"="ALWAYS" }
		Cull Off
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha DstAlpha
		
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
		uniform float _Float4;
		uniform sampler2D _Mask1;
		uniform float2 _PannerMask1;
		uniform float2 _TilingMask1;
		float4 _Mask1_TexelSize;
		uniform sampler2D _Mask2;
		uniform float2 _PannerMask2;
		uniform float2 _TilingMask2;
		uniform float4 _MaincolorRedchannel2;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _SmoothnessRedChannel1;
		uniform float _SmoothnessRedChannel2;
		uniform float _Emissiveboost;
		uniform float _NoAudioLinkHUE;
		uniform float _NoAudioLinkSaturation;
		uniform float _Trippyness;
		uniform float _RaveMode;
		uniform sampler2D _Udon_VideoTex;
		uniform float _VideoscreenAnimationspeed;
		uniform float _VideoscreenLerp;
		uniform float _Metallic;
		uniform float _Opacity;


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
			float2 uv_TexCoord340 = i.uv_texcoord * _TilingMask1;
			float2 panner339 = ( 1.0 * _Time.y * _PannerMask1 + uv_TexCoord340);
			float2 Input_UV100_g143 = panner339;
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
			float2 uv_TexCoord343 = i.uv_texcoord * _TilingMask2;
			float2 panner342 = ( 1.0 * _Time.y * _PannerMask2 + uv_TexCoord343);
			float4 tex2DNode2 = tex2D( _Mask2, panner342 );
			float4 MainMask310 = ( saturate( CalculateContrast(_Float4,temp_cast_0) ) * tex2DNode2.r );
			float4 Albedo355 = ( ( _MaincolorRedchannel1 * ( 1.0 - MainMask310 ) ) + ( MainMask310 * _MaincolorRedchannel2 ) );
			o.Albedo = Albedo355.rgb;
			float localLTCGI15_g161 = ( 0.0 );
			float3 ase_positionWS = i.worldPos;
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
			float localIfAudioLinkv2Exists1_g156 = IfAudioLinkv2Exists1_g156();
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
			float4 temp_cast_12 = (AudioLinkMask311).xxxx;
			float4 temp_output_3_0_g154 = ( temp_cast_12 * temp_output_322_0 );
			float grayscale4_g154 = (temp_output_3_0_g154.xyz.r + temp_output_3_0_g154.xyz.g + temp_output_3_0_g154.xyz.b) / 3;
			float Trippyness325 = _Trippyness;
			float localIfAudioLinkv2Exists1_g157 = IfAudioLinkv2Exists1_g157();
			float4 lerpResult359 = lerp( ( ( saturate( switchResult4_g159 ) * float4( hsvTorgb174 , 0.0 ) * 2.0 ) + float4( ( hsvTorgb174 * NoAudioLinkMask312 ) , 0.0 ) ) , ( localIfAudioLinkv2Exists1_g156 * ( ( saturate( switchResult4_g155 ) * temp_output_322_0 * 2.0 ) + ( temp_output_3_0_g154 * saturate( sin( ( grayscale4_g154 * Trippyness325 ) ) ) ) ) ) , ( _RaveMode * localIfAudioLinkv2Exists1_g157 ));
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
			float4 temp_cast_16 = (AudioLinkMask311).xxxx;
			float4 temp_output_3_0_g158 = ( temp_cast_16 * tex2DNode223 );
			float grayscale4_g158 = (temp_output_3_0_g158.xyz.r + temp_output_3_0_g158.xyz.g + temp_output_3_0_g158.xyz.b) / 3;
			float4 lerpResult309 = lerp( lerpResult359 , ( ( saturate( switchResult4_g160 ) * tex2DNode223 * 2.0 ) + ( temp_output_3_0_g158 * saturate( sin( ( grayscale4_g158 * Trippyness325 ) ) ) ) ) , _VideoscreenLerp);
			float3 normalizeResult385 = normalize( ase_viewDirWS );
			float3 ase_normalOS = mul( unity_WorldToObject, float4( ase_normalWS, 0 ) );
			ase_normalOS = normalize( ase_normalOS );
			float3 switchResult390 = (((i.ASEIsFrontFacing>0)?(ase_normalOS):(-ase_normalOS)));
			float4 transform368 = mul(unity_ObjectToWorld,float4( switchResult390 , 0.0 ));
			float3 appendResult369 = (float3(transform368.x , transform368.y , transform368.z));
			float3 normalizeResult384 = normalize( appendResult369 );
			float dotResult370 = dot( normalizeResult385 , normalizeResult384 );
			float mulTime373 = _Time.y * 20.0;
			#ifdef _PULSATING_ON
				float staticSwitch404 = ( ( saturate( ( ( sin( ( ( ( dotResult370 * 20.0 ) + mulTime373 ) * 0.09782609 ) ) - 0.93 ) * ( 0.93 * 10.0 ) ) ) * 3.0 ) + 1.0 );
			#else
				float staticSwitch404 = 1.0;
			#endif
			float middleToEdgeIntensity387 = staticSwitch404;
			float4 temp_output_5_0 = ( MainMask310 * _Emissiveboost * lerpResult309 * middleToEdgeIntensity387 );
			o.Emission = ( ( ( float4( diffuse15_g161 , 0.0 ) * Albedo355 ) + float4( ( specular15_g161 * specularIntensity15_g161 ) , 0.0 ) ) + temp_output_5_0 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = Smoothness333.r;
			float grayscale178 = (saturate( temp_output_5_0 ).rgb.r + saturate( temp_output_5_0 ).rgb.g + saturate( temp_output_5_0 ).rgb.b) / 3;
			o.Alpha = saturate( ( ( 1.0 - ( MainMask310 * ( 1.0 - grayscale178 ) ) ) + _Opacity ) ).r;
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
			sampler3D _DitherMaskLOD;
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
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
Node;AmplifyShaderEditor.NormalVertexDataNode;367;-2612.882,2420.243;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;391;-2444.327,2506.354;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;390;-2319.327,2422.354;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;368;-2079.882,2424.243;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;369;-1903.882,2424.243;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;386;-1878.316,2235.111;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;384;-1670.316,2411.111;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;385;-1638.316,2283.111;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;370;-1439.882,2424.243;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;371;-1599.882,2536.243;Inherit;False;Constant;_Tiling;Tiling;0;0;Create;True;0;0;0;False;0;False;20;15.66522;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;346;-4148.377,-459.8883;Inherit;False;Property;_TilingMask1;Tiling Mask 1;1;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;345;-4184.01,49.53236;Inherit;False;Property;_TilingMask2;Tiling Mask 2;3;0;Create;True;0;0;0;False;0;False;1,1;9.923,9.923;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;-1263.882,2424.243;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;373;-1471.882,2664.243;Inherit;False;1;0;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-3930.097,-450.0465;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;341;-3908.921,-276.4027;Inherit;False;Property;_PannerMask1;Panner Mask 1;2;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;343;-3942.45,44.76797;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;344;-3921.274,218.4118;Inherit;False;Property;_PannerMask2;Panner Mask 2;4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;374;-1103.882,2424.243;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;375;-1471.882,2776.244;Inherit;False;Constant;_middleEdgeThickness;middleEdgeThickness;23;0;Create;True;0;0;0;False;0;False;0.09782609;0.2634824;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;265;-3345.092,-404.641;Inherit;False;807.8257;834.0303;Masks;6;291;2;17;266;267;268;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;339;-3628.338,-338.8721;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;394;-3592.116,-595.5279;Inherit;True;Property;_Mask1;Mask1;23;0;Create;True;0;0;0;False;0;False;None;8d44a859d64aa854ab00f05f5655a95e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;342;-3640.691,155.9424;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;392;-3617.173,378.7357;Inherit;True;Property;_Mask2;Mask 2;21;0;Create;True;0;0;0;False;0;False;None;22cff25f0026c6c4491db57e47153802;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;376;-991.8818,2424.243;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3255.193,153.7893;Inherit;True;Property;_Mask222;Mask222;3;0;Create;True;0;0;0;False;0;False;-1;22cff25f0026c6c4491db57e47153802;22cff25f0026c6c4491db57e47153802;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;267;-2795.562,-153.5596;Inherit;False;212;185;G;1;263;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;395;-3254.116,-652.9277;Inherit;True;Bicubic Sample;-1;;143;ce0e14d5ad5eac645b2e5892ab3506ff;2,92,0,72,0;7;99;SAMPLER2D;0;False;91;SAMPLER2DARRAY;0;False;93;FLOAT;0;False;97;FLOAT2;0,0;False;198;FLOAT4;0,0,0,0;False;199;FLOAT2;0,0;False;94;SAMPLERSTATE;0;False;5;COLOR;86;FLOAT;84;FLOAT;85;FLOAT;82;FLOAT;83
Node;AmplifyShaderEditor.SinOpNode;377;-847.8818,2424.243;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;378;-1023.882,2696.244;Inherit;False;Constant;_spacing;spacing;23;0;Create;True;0;0;0;False;0;False;0.93;0.9940453;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;268;-2797.241,41.85443;Inherit;False;212;185;B;1;264;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-3081.716,1098.973;Inherit;False;1781.816;772.3745;Video Player;12;301;302;326;319;223;248;246;250;244;252;249;251;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-2753.396,-101.6009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;324;-3314.801,-1174.885;Inherit;False;Property;_Trippyness;Trippyness;17;0;Create;True;0;0;0;False;0;False;1;1;1;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;398;-3345.894,-766.9459;Inherit;False;Property;_Float4;Float 4;24;0;Create;True;0;0;0;False;0;False;0;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;379;-671.8818,2424.243;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;380;-591.8818,2712.244;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-2757.035,95.77187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;273;-2179.926,-113.8984;Inherit;False;1164.916;492.7913;No AudioLink color;7;272;129;321;174;177;176;175;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;251;-2931.899,1528.139;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;249;-3047.363,1291.149;Inherit;False;Constant;_VideoScreen_Offset;VideoScreen_Offset;14;0;Create;True;0;0;0;False;0;False;0.156,0.156;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;252;-3044.719,1429.097;Inherit;False;Property;_VideoscreenAnimationspeed;Video screen - Animation speed;19;0;Create;False;0;0;0;False;0;False;0;0.2;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;244;-3046.363,1169.148;Inherit;False;Constant;_VideoScreen_Tiling;VideoScreen_Tiling;11;0;Create;True;0;0;0;False;0;False;0.69,0.69;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;323;-2911.948,487.9987;Inherit;False;1609.159;490.3383;AudioLink;7;320;322;297;271;327;145;357;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;-2480.971,-93.1853;Inherit;False;AudioLinkMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;-2877.801,-1135.885;Inherit;False;Trippyness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;400;-2954.807,-714.9492;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;402;-3200,576;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;-353.1244,2487.094;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;-2501.631,84.24023;Inherit;False;NoAudioLinkMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;250;-2771.227,1241.149;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;-2708.721,1477.097;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-2157.926,-56.645;Inherit;False;Property;_NoAudioLinkHUE;No AudioLink - HUE;13;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-2173.926,30.35519;Inherit;False;Property;_NoAudioLinkSaturation;No AudioLink - Saturation;14;0;Create;False;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2163.926,115.3547;Inherit;False;Constant;_Brightness;Brightness;14;0;Create;True;0;0;0;False;0;False;1;1;0;21;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;266;-2798.993,-349.9491;Inherit;False;212;185;R;1;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-2514.415,692.8453;Inherit;False;325;Trippyness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;320;-2667.892,820.7022;Inherit;False;311;AudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;401;-2822.807,-578.9492;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;322;-2825.085,594.961;Inherit;False;M_GetRainbowTrack;-1;;144;a14bfb64767603a449f9acd9d7712fd0;0;7;87;FLOAT2;0,0;False;79;COLOR;1,0,0,0;False;80;COLOR;1,0.7058535,0,0;False;81;COLOR;0.1067042,1,0,0;False;82;COLOR;0,0.1044993,1,0;False;34;FLOAT2;1,0;False;16;FLOAT;128;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;382;-127.8818,2504.243;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;248;-2449.448,1298.442;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.HSVToRGBNode;174;-1858.335,-58.8985;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.81;False;2;FLOAT;0.57;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2748.993,-299.9491;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;297;-2324.774,797.0206;Inherit;False;M_Trippyness;-1;;154;d2f7279fe4c1992449d3442abc89e184;0;3;12;FLOAT;0;False;10;FLOAT4;0,0,0,0;False;11;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;-2161.764,197.005;Inherit;False;312;NoAudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;92.80054,2511.867;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;223;-2209.709,1411.369;Inherit;True;Global;_Udon_VideoTex;_Udon_VideoTex;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;319;-2186.952,1751.427;Inherit;False;311;AudioLinkMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;-2227.136,1653.998;Inherit;False;325;Trippyness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1631.336,102.627;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;290;-1663.203,-767.7565;Inherit;False;685.5624;405.3629;Smoothness;8;286;287;288;285;118;289;318;316;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;271;-2021.926,577.5217;Inherit;True;M_RimLight;-1;;155;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;145;-1895.809,514.8334;Inherit;False;IsAudioLink;-1;;156;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;-974.7972,206.9196;Inherit;False;Property;_RaveMode;RaveMode;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;360;-919.0027,393.5789;Inherit;False;IsAudioLink;-1;;157;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;310;-2490.482,-293.5471;Inherit;False;MainMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;383;272,2512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;403;176,2256;Inherit;False;Constant;_Float5;Float 5;22;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;302;-1861.656,1665.311;Inherit;False;M_Trippyness;-1;;158;d2f7279fe4c1992449d3442abc89e184;0;3;12;FLOAT;0;False;10;FLOAT4;0,0,0,0;False;11;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;316;-1630.035,-716.9571;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;272;-1244.425,72.62145;Inherit;False;M_RimLight;-1;;159;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;-1609.591,603.9607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;-749.5781,253.3754;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;404;544,2496;Inherit;False;Property;_Pulsating;Pulsating;22;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;301;-1555.008,1438.112;Inherit;True;M_RimLight;-1;;160;26ae409e1ec093248b15d35e7f32a10d;0;2;7;FLOAT4;1,0,0,0;False;8;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;318;-1527.772,-537.9583;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;286;-1458.192,-716.7566;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;347;629.7979,-813.698;Inherit;False;869.5521;647.1727;Albedo color;8;348;349;350;351;352;353;354;355;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-1618.203,-629.1384;Inherit;False;Property;_SmoothnessRedChannel1;Smoothness - Red Channel 1;11;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-1624.795,-461.3936;Inherit;False;Property;_SmoothnessRedChannel2;Smoothness - Red Channel 2;12;0;Create;True;0;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;359;-626.5707,92.60951;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-496.3149,311.2111;Inherit;False;Property;_VideoscreenLerp;Video screen - Lerp;20;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;387;848,2528;Inherit;False;middleToEdgeIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-1299.591,-713.3566;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-1285.591,-511.9566;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;647.2451,-537.8275;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;309;-69.95221,84.74734;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;331;477.1373,-5.100448;Inherit;False;Property;_Emissiveboost;Emissive boost;16;0;Create;True;0;0;0;False;0;False;0;0.73;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;694.9876,-76.32484;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;388;533.7993,134.5412;Inherit;False;387;middleToEdgeIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;289;-1129.641,-591.1735;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;350;823.2451,-537.8275;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;351;679.2451,-345.8276;Inherit;False;Property;_MaincolorRedchannel2;Main color - Red channel 2;9;0;Create;True;0;0;0;False;0;False;0.2264151,0.2264151,0.2264151,0;0.08627395,0.08627395,0.08627395,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;348;679.2451,-761.8275;Inherit;False;Property;_MaincolorRedchannel1;Main color - Red channel 1;7;0;Create;True;0;0;0;False;0;False;0.5754717,0.5754717,0.5754717,0;0.6792453,0.6792453,0.6792453,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;1063.756,-38.34581;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;161;1457.231,78.17384;Inherit;False;751.566;223.6805;Opacity;5;133;172;173;178;317;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;-1010.961,-578.5338;Inherit;False;Smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;330;1770.454,-626.0853;Inherit;False;1004.88;491.4049;LTCGI;7;329;281;278;338;277;284;334;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;983.2451,-457.8276;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;353;979.4684,-567.6733;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;356;1239.933,141.9214;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;178;1488.562,206.974;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;354;1154.406,-533.5263;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;334;1785.015,-493.7934;Inherit;False;333;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;173;1677.465,207.1081;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;317;1624.904,127.6151;Inherit;False;310;MainMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;284;1890.958,-370.4574;Inherit;True;Property;_BumpMap;BumpMap;6;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.OneMinusNode;277;1975.458,-497.1453;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;355;1284.52,-533.1145;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1836.269,182.1738;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;2240.311,-560.0279;Inherit;False;355;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;362;2144.033,-480.2368;Inherit;False;LTCGI_Contribution;-1;;161;d3ea6060590627141a6e856295f0e87c;0;2;18;SAMPLER2D;0;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;172;2010.613,169.9093;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;2515.431,-426.3637;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;2494.126,-571.2236;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;180;1999.866,355.2408;Inherit;False;Property;_Opacity;Opacity;15;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;291;-2802.132,234.8902;Inherit;False;212;185;A;1;292;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;329;2657.278,-493.1125;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;2277.01,172.4911;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-2757.132,285.8903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;2851.358,-72.80032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;335;2901.517,48.48311;Inherit;False;333;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;2959.812,-109.7514;Inherit;False;355;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;181;2571.615,170.7205;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;115;2979.603,-24.1529;Inherit;False;Property;_Metallic;Metallic;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-3338.831,-347.641;Inherit;True;Property;_Mask14694;Mask14694;0;0;Create;True;0;0;0;False;0;False;-1;ba199f114fe44dd4d915e0e53d91c0f7;8d44a859d64aa854ab00f05f5655a95e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3730.16,-67.20901;Float;False;True;-1;2;AmplifyShaderEditor.MaterialInspector;0;0;Standard;MyroP/Pattern;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;1;5;False;;7;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;5;-1;-1;-1;1;LTCGI=ALWAYS;False;0;0;False;;-1;0;False;;1;Include;Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;391;0;367;0
WireConnection;390;0;367;0
WireConnection;390;1;391;0
WireConnection;368;0;390;0
WireConnection;369;0;368;1
WireConnection;369;1;368;2
WireConnection;369;2;368;3
WireConnection;384;0;369;0
WireConnection;385;0;386;0
WireConnection;370;0;385;0
WireConnection;370;1;384;0
WireConnection;372;0;370;0
WireConnection;372;1;371;0
WireConnection;340;0;346;0
WireConnection;343;0;345;0
WireConnection;374;0;372;0
WireConnection;374;1;373;0
WireConnection;339;0;340;0
WireConnection;339;2;341;0
WireConnection;342;0;343;0
WireConnection;342;2;344;0
WireConnection;376;0;374;0
WireConnection;376;1;375;0
WireConnection;2;0;392;0
WireConnection;2;1;342;0
WireConnection;2;7;392;1
WireConnection;395;99;394;0
WireConnection;395;97;339;0
WireConnection;395;94;394;1
WireConnection;377;0;376;0
WireConnection;263;0;395;85
WireConnection;263;1;2;2
WireConnection;379;0;377;0
WireConnection;379;1;378;0
WireConnection;380;0;378;0
WireConnection;264;0;395;82
WireConnection;264;1;2;3
WireConnection;311;0;263;0
WireConnection;325;0;324;0
WireConnection;400;1;395;84
WireConnection;400;0;398;0
WireConnection;381;0;379;0
WireConnection;381;1;380;0
WireConnection;312;0;264;0
WireConnection;250;0;244;0
WireConnection;250;1;249;0
WireConnection;246;0;252;0
WireConnection;246;1;251;0
WireConnection;401;0;400;0
WireConnection;322;87;402;0
WireConnection;382;0;381;0
WireConnection;248;0;250;0
WireConnection;248;2;246;0
WireConnection;174;0;175;0
WireConnection;174;1;176;0
WireConnection;174;2;177;0
WireConnection;18;0;401;0
WireConnection;18;1;2;1
WireConnection;297;12;327;0
WireConnection;297;10;320;0
WireConnection;297;11;322;0
WireConnection;389;0;382;0
WireConnection;223;1;248;0
WireConnection;129;0;174;0
WireConnection;129;1;321;0
WireConnection;271;7;322;0
WireConnection;271;8;297;0
WireConnection;310;0;18;0
WireConnection;383;0;389;0
WireConnection;302;12;326;0
WireConnection;302;10;319;0
WireConnection;302;11;223;0
WireConnection;272;7;174;0
WireConnection;272;8;129;0
WireConnection;357;0;145;0
WireConnection;357;1;271;0
WireConnection;361;0;358;0
WireConnection;361;1;360;0
WireConnection;404;1;403;0
WireConnection;404;0;383;0
WireConnection;301;7;223;0
WireConnection;301;8;302;0
WireConnection;286;0;316;0
WireConnection;359;0;272;0
WireConnection;359;1;357;0
WireConnection;359;2;361;0
WireConnection;387;0;404;0
WireConnection;287;0;286;0
WireConnection;287;1;118;0
WireConnection;288;0;318;0
WireConnection;288;1;285;0
WireConnection;309;0;359;0
WireConnection;309;1;301;0
WireConnection;309;2;235;0
WireConnection;289;0;287;0
WireConnection;289;1;288;0
WireConnection;350;0;349;0
WireConnection;5;0;315;0
WireConnection;5;1;331;0
WireConnection;5;2;309;0
WireConnection;5;3;388;0
WireConnection;333;0;289;0
WireConnection;352;0;349;0
WireConnection;352;1;351;0
WireConnection;353;0;348;0
WireConnection;353;1;350;0
WireConnection;356;0;5;0
WireConnection;178;0;356;0
WireConnection;354;0;353;0
WireConnection;354;1;352;0
WireConnection;173;0;178;0
WireConnection;277;0;334;0
WireConnection;355;0;354;0
WireConnection;133;0;317;0
WireConnection;133;1;173;0
WireConnection;362;18;284;0
WireConnection;362;21;277;0
WireConnection;172;0;133;0
WireConnection;278;0;362;16
WireConnection;278;1;362;17
WireConnection;281;0;362;0
WireConnection;281;1;338;0
WireConnection;329;0;281;0
WireConnection;329;1;278;0
WireConnection;179;0;172;0
WireConnection;179;1;180;0
WireConnection;292;0;395;83
WireConnection;292;1;2;4
WireConnection;282;0;329;0
WireConnection;282;1;5;0
WireConnection;181;0;179;0
WireConnection;17;1;339;0
WireConnection;0;0;337;0
WireConnection;0;2;282;0
WireConnection;0;3;115;0
WireConnection;0;4;335;0
WireConnection;0;9;181;0
ASEEND*/
//CHKSM=3D11CDD9829747B66E449567F7B3F1B578A9EAF3