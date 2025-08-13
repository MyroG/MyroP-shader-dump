// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/MusicVisualizer"
{
	Properties
	{
		[Toggle]_AudioLinkDebug("AudioLink Debug", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Logo("Logo", 2D) = "black" {}
		_LogoSize("Logo Size", Range( 0 , 5)) = 2.06
		_LowZoomIntensity("Low Zoom Intensity", Range( 0 , 2)) = 1
		_LowShakeStart("Low Shake Start", Range( 0 , 1)) = 0
		_LowShakeIntensity("Low Shake Intensity", Range( 0 , 1)) = 0
		_LowMidChromaticStart("LowMid Chromatic Start", Range( 0 , 1)) = 0
		_LowMidChromaticIntensity("LowMid Chromatic Intensity", Range( 0 , 1)) = 0
		_MidHighShakeSpeed("MidHigh Shake Speed", Range( 0 , 100)) = 0
		_HighGlitchIntensity("High Glitch Intensity", Range( 0 , 0.1)) = 0
		_MidHighShakeIntensity("MidHigh Shake Intensity", Range( 0 , 1)) = 1
		_Spectrograminnerradius("Spectrogram inner radius", Range( 0 , 1)) = 0
		_Spectrogramouterradius("Spectrogram outer radius", Range( 0 , 1)) = 0.09176044
		_SpectrogramOrigin("Spectrogram Origin ", Vector) = (0.5,0.5,0,0)
		[HDR]_Spectogramoutercolor("Spectogram outer color", Color) = (0,0,0,0)
		[HDR]_Spectograminnercolor("Spectogram inner color", Color) = (1,1,1,1)
		_Debug_Low("Debug_Low", Range( 0 , 1)) = 0
		_Debug_LowMid("Debug_LowMid", Range( 0 , 1)) = 0
		_Debug_HighMid("Debug_HighMid", Range( 0 , 1)) = 0
		_Debug_High("Debug_High", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#define ASE_VERSION 19801
		#include "Packages/com.llealloo.audiolink/Runtime/Shaders/AudioLink.cginc"
		struct Input
		{
			float2 uv_texcoord;
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

		uniform float _Spectrograminnerradius;
		uniform float2 _SpectrogramOrigin;
		uniform float _LogoSize;
		uniform float _AudioLinkDebug;
		uniform float _Debug_Low;
		uniform float _LowZoomIntensity;
		uniform float _LowShakeIntensity;
		uniform float _LowShakeStart;
		uniform float _Debug_High;
		uniform float _MidHighShakeSpeed;
		uniform float _MidHighShakeIntensity;
		uniform float _Debug_HighMid;
		uniform float4 _Spectograminnercolor;
		uniform float4 _Spectogramoutercolor;
		uniform float _Spectrogramouterradius;
		uniform sampler2D _Logo;
		uniform float _HighGlitchIntensity;
		uniform float _LowMidChromaticIntensity;
		uniform float _Debug_LowMid;
		uniform float _LowMidChromaticStart;
		uniform float _Cutoff = 0.5;


		inline float AudioLinkData3_g680( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g686( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g679( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		float MyCustomExpression1_g693( float x )
		{
			return AudioLinkLerpMultiline( ALPASS_DFT + float2( x * AUDIOLINK_ETOTALBINS, 0.0f ) ).rrrr;
		}


		inline float AudioLinkData3_g684( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float temp_output_115_0_g678 = _Spectrograminnerradius;
			float2 temp_output_114_0_g678 = _SpectrogramOrigin;
			int Band3_g680 = 0;
			int Delay3_g680 = 0;
			float localAudioLinkData3_g680 = AudioLinkData3_g680( Band3_g680 , Delay3_g680 );
			float Bass19_g678 = (( _AudioLinkDebug )?( _Debug_Low ):( localAudioLinkData3_g680 ));
			float temp_output_3_0_g683 = ( _LogoSize - ( Bass19_g678 * _LowZoomIntensity ) );
			float temp_output_110_0_g678 = _LowShakeIntensity;
			float2 temp_cast_5 = (_Time.y).xx;
			float dotResult4_g681 = dot( temp_cast_5 , float2( 12.9898,78.233 ) );
			float lerpResult10_g681 = lerp( -temp_output_110_0_g678 , temp_output_110_0_g678 , frac( ( sin( dotResult4_g681 ) * 43758.55 ) ));
			float mulTime23_g678 = _Time.y * 0.5;
			float2 temp_cast_6 = (mulTime23_g678).xx;
			float dotResult4_g682 = dot( temp_cast_6 , float2( 12.9898,78.233 ) );
			float lerpResult10_g682 = lerp( -temp_output_110_0_g678 , temp_output_110_0_g678 , frac( ( sin( dotResult4_g682 ) * 43758.55 ) ));
			float2 appendResult39_g678 = (float2(lerpResult10_g681 , lerpResult10_g682));
			int Band3_g686 = 3;
			int Delay3_g686 = 0;
			float localAudioLinkData3_g686 = AudioLinkData3_g686( Band3_g686 , Delay3_g686 );
			float High10_g678 = (( _AudioLinkDebug )?( _Debug_High ):( localAudioLinkData3_g686 ));
			float temp_output_112_0_g678 = _MidHighShakeSpeed;
			float mulTime30_g678 = _Time.y * ( High10_g678 * temp_output_112_0_g678 );
			float temp_output_113_0_g678 = _MidHighShakeIntensity;
			int Band3_g679 = 2;
			int Delay3_g679 = 0;
			float localAudioLinkData3_g679 = AudioLinkData3_g679( Band3_g679 , Delay3_g679 );
			float HighMid11_g678 = (( _AudioLinkDebug )?( _Debug_HighMid ):( localAudioLinkData3_g679 ));
			float mulTime29_g678 = _Time.y * ( HighMid11_g678 * temp_output_112_0_g678 );
			float2 appendResult47_g678 = (float2(( cos( mulTime30_g678 ) * temp_output_113_0_g678 ) , ( sin( mulTime29_g678 ) * temp_output_113_0_g678 )));
			float2 TransformedUV50_g678 = ( (i.uv_texcoord*temp_output_3_0_g683 + ( ( 1.0 - temp_output_3_0_g683 ) / 2.0 )) + ( appendResult39_g678 * saturate( ( Bass19_g678 - _LowShakeStart ) ) ) + appendResult47_g678 );
			float temp_output_68_0_g678 = distance( temp_output_114_0_g678 , TransformedUV50_g678 );
			float4 temp_output_2_0_g687 = _Spectogramoutercolor;
			float2 normalizeResult54_g678 = normalize( ( TransformedUV50_g678 - temp_output_114_0_g678 ) );
			float2 break55_g678 = normalizeResult54_g678;
			float x1_g693 = ( ( ( atan2( abs( break55_g678.x ) , break55_g678.y ) + UNITY_PI ) % UNITY_PI ) / UNITY_PI );
			float localMyCustomExpression1_g693 = MyCustomExpression1_g693( x1_g693 );
			float ifLocalVar80_g678 = 0;
			if( ( _Spectrogramouterradius * localMyCustomExpression1_g693 ) <= ( temp_output_68_0_g678 - temp_output_115_0_g678 ) )
				ifLocalVar80_g678 = 0.0;
			else
				ifLocalVar80_g678 = 1.0;
			float4 appendResult4_g685 = (float4(( (temp_output_2_0_g687).rgb * ifLocalVar80_g678 ) , ifLocalVar80_g678));
			float4 temp_output_85_0_g678 = appendResult4_g685;
			float4 ifLocalVar90_g678 = 0;
			if( temp_output_115_0_g678 <= temp_output_68_0_g678 )
				ifLocalVar90_g678 = temp_output_85_0_g678;
			else
				ifLocalVar90_g678 = _Spectograminnercolor;
			float4 SpectogramColor92_g678 = ifLocalVar90_g678;
			float mulTime123_g678 = _Time.y * 0.04;
			float2 appendResult125_g678 = (float2(i.uv_texcoord.y , mulTime123_g678));
			float dotResult4_g688 = dot( appendResult125_g678 , float2( 12.9898,78.233 ) );
			float lerpResult10_g688 = lerp( -1.0 , 1.0 , frac( ( sin( dotResult4_g688 ) * 43758.55 ) ));
			float2 appendResult130_g678 = (float2(( lerpResult10_g688 * High10_g678 * _HighGlitchIntensity ) , 0.0));
			float2 temp_output_11_0_g689 = ( TransformedUV50_g678 + appendResult130_g678 );
			int Band3_g684 = 1;
			int Delay3_g684 = 0;
			float localAudioLinkData3_g684 = AudioLinkData3_g684( Band3_g684 , Delay3_g684 );
			float LowMid67_g678 = (( _AudioLinkDebug )?( _Debug_LowMid ):( localAudioLinkData3_g684 ));
			float temp_output_1_0_g689 = ( _LowMidChromaticIntensity * saturate( ( LowMid67_g678 - _LowMidChromaticStart ) ) );
			float temp_output_3_0_g690 = ( 1.0 - temp_output_1_0_g689 );
			float4 tex2DNode14_g689 = tex2D( _Logo, (temp_output_11_0_g689*temp_output_3_0_g690 + ( ( 1.0 - temp_output_3_0_g690 ) / 2.0 )) );
			float temp_output_3_0_g691 = ( 1.0 - ( temp_output_1_0_g689 / 2.0 ) );
			float4 tex2DNode18_g689 = tex2D( _Logo, (temp_output_11_0_g689*temp_output_3_0_g691 + ( ( 1.0 - temp_output_3_0_g691 ) / 2.0 )) );
			float4 tex2DNode19_g689 = tex2D( _Logo, temp_output_11_0_g689 );
			float4 appendResult21_g689 = (float4(tex2DNode14_g689.r , tex2DNode18_g689.g , tex2DNode19_g689.b , ( ( tex2DNode14_g689.a + tex2DNode18_g689.a + tex2DNode19_g689.a ) / 3.0 )));
			float4 temp_output_138_0_g678 = appendResult21_g689;
			float4 temp_output_2_0_g692 = temp_output_138_0_g678;
			float4 lerpResult98_g678 = lerp( SpectogramColor92_g678 , temp_output_138_0_g678 , (temp_output_2_0_g692).w);
			float4 temp_output_2_0_g677 = lerpResult98_g678;
			c.rgb = 0;
			c.a = 1;
			clip( (temp_output_2_0_g677).w - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float temp_output_115_0_g678 = _Spectrograminnerradius;
			float2 temp_output_114_0_g678 = _SpectrogramOrigin;
			int Band3_g680 = 0;
			int Delay3_g680 = 0;
			float localAudioLinkData3_g680 = AudioLinkData3_g680( Band3_g680 , Delay3_g680 );
			float Bass19_g678 = (( _AudioLinkDebug )?( _Debug_Low ):( localAudioLinkData3_g680 ));
			float temp_output_3_0_g683 = ( _LogoSize - ( Bass19_g678 * _LowZoomIntensity ) );
			float temp_output_110_0_g678 = _LowShakeIntensity;
			float2 temp_cast_0 = (_Time.y).xx;
			float dotResult4_g681 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
			float lerpResult10_g681 = lerp( -temp_output_110_0_g678 , temp_output_110_0_g678 , frac( ( sin( dotResult4_g681 ) * 43758.55 ) ));
			float mulTime23_g678 = _Time.y * 0.5;
			float2 temp_cast_1 = (mulTime23_g678).xx;
			float dotResult4_g682 = dot( temp_cast_1 , float2( 12.9898,78.233 ) );
			float lerpResult10_g682 = lerp( -temp_output_110_0_g678 , temp_output_110_0_g678 , frac( ( sin( dotResult4_g682 ) * 43758.55 ) ));
			float2 appendResult39_g678 = (float2(lerpResult10_g681 , lerpResult10_g682));
			int Band3_g686 = 3;
			int Delay3_g686 = 0;
			float localAudioLinkData3_g686 = AudioLinkData3_g686( Band3_g686 , Delay3_g686 );
			float High10_g678 = (( _AudioLinkDebug )?( _Debug_High ):( localAudioLinkData3_g686 ));
			float temp_output_112_0_g678 = _MidHighShakeSpeed;
			float mulTime30_g678 = _Time.y * ( High10_g678 * temp_output_112_0_g678 );
			float temp_output_113_0_g678 = _MidHighShakeIntensity;
			int Band3_g679 = 2;
			int Delay3_g679 = 0;
			float localAudioLinkData3_g679 = AudioLinkData3_g679( Band3_g679 , Delay3_g679 );
			float HighMid11_g678 = (( _AudioLinkDebug )?( _Debug_HighMid ):( localAudioLinkData3_g679 ));
			float mulTime29_g678 = _Time.y * ( HighMid11_g678 * temp_output_112_0_g678 );
			float2 appendResult47_g678 = (float2(( cos( mulTime30_g678 ) * temp_output_113_0_g678 ) , ( sin( mulTime29_g678 ) * temp_output_113_0_g678 )));
			float2 TransformedUV50_g678 = ( (i.uv_texcoord*temp_output_3_0_g683 + ( ( 1.0 - temp_output_3_0_g683 ) / 2.0 )) + ( appendResult39_g678 * saturate( ( Bass19_g678 - _LowShakeStart ) ) ) + appendResult47_g678 );
			float temp_output_68_0_g678 = distance( temp_output_114_0_g678 , TransformedUV50_g678 );
			float4 temp_output_2_0_g687 = _Spectogramoutercolor;
			float2 normalizeResult54_g678 = normalize( ( TransformedUV50_g678 - temp_output_114_0_g678 ) );
			float2 break55_g678 = normalizeResult54_g678;
			float x1_g693 = ( ( ( atan2( abs( break55_g678.x ) , break55_g678.y ) + UNITY_PI ) % UNITY_PI ) / UNITY_PI );
			float localMyCustomExpression1_g693 = MyCustomExpression1_g693( x1_g693 );
			float ifLocalVar80_g678 = 0;
			if( ( _Spectrogramouterradius * localMyCustomExpression1_g693 ) <= ( temp_output_68_0_g678 - temp_output_115_0_g678 ) )
				ifLocalVar80_g678 = 0.0;
			else
				ifLocalVar80_g678 = 1.0;
			float4 appendResult4_g685 = (float4(( (temp_output_2_0_g687).rgb * ifLocalVar80_g678 ) , ifLocalVar80_g678));
			float4 temp_output_85_0_g678 = appendResult4_g685;
			float4 ifLocalVar90_g678 = 0;
			if( temp_output_115_0_g678 <= temp_output_68_0_g678 )
				ifLocalVar90_g678 = temp_output_85_0_g678;
			else
				ifLocalVar90_g678 = _Spectograminnercolor;
			float4 SpectogramColor92_g678 = ifLocalVar90_g678;
			float mulTime123_g678 = _Time.y * 0.04;
			float2 appendResult125_g678 = (float2(i.uv_texcoord.y , mulTime123_g678));
			float dotResult4_g688 = dot( appendResult125_g678 , float2( 12.9898,78.233 ) );
			float lerpResult10_g688 = lerp( -1.0 , 1.0 , frac( ( sin( dotResult4_g688 ) * 43758.55 ) ));
			float2 appendResult130_g678 = (float2(( lerpResult10_g688 * High10_g678 * _HighGlitchIntensity ) , 0.0));
			float2 temp_output_11_0_g689 = ( TransformedUV50_g678 + appendResult130_g678 );
			int Band3_g684 = 1;
			int Delay3_g684 = 0;
			float localAudioLinkData3_g684 = AudioLinkData3_g684( Band3_g684 , Delay3_g684 );
			float LowMid67_g678 = (( _AudioLinkDebug )?( _Debug_LowMid ):( localAudioLinkData3_g684 ));
			float temp_output_1_0_g689 = ( _LowMidChromaticIntensity * saturate( ( LowMid67_g678 - _LowMidChromaticStart ) ) );
			float temp_output_3_0_g690 = ( 1.0 - temp_output_1_0_g689 );
			float4 tex2DNode14_g689 = tex2D( _Logo, (temp_output_11_0_g689*temp_output_3_0_g690 + ( ( 1.0 - temp_output_3_0_g690 ) / 2.0 )) );
			float temp_output_3_0_g691 = ( 1.0 - ( temp_output_1_0_g689 / 2.0 ) );
			float4 tex2DNode18_g689 = tex2D( _Logo, (temp_output_11_0_g689*temp_output_3_0_g691 + ( ( 1.0 - temp_output_3_0_g691 ) / 2.0 )) );
			float4 tex2DNode19_g689 = tex2D( _Logo, temp_output_11_0_g689 );
			float4 appendResult21_g689 = (float4(tex2DNode14_g689.r , tex2DNode18_g689.g , tex2DNode19_g689.b , ( ( tex2DNode14_g689.a + tex2DNode18_g689.a + tex2DNode19_g689.a ) / 3.0 )));
			float4 temp_output_138_0_g678 = appendResult21_g689;
			float4 temp_output_2_0_g692 = temp_output_138_0_g678;
			float4 lerpResult98_g678 = lerp( SpectogramColor92_g678 , temp_output_138_0_g678 , (temp_output_2_0_g692).w);
			float4 temp_output_2_0_g677 = lerpResult98_g678;
			o.Emission = (temp_output_2_0_g677).xyz;
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
			#pragma target 3.5
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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
Node;AmplifyShaderEditor.RangedFloatNode;40;960,112;Inherit;False;Property;_LowShakeStart;Low Shake Start;9;0;Create;True;0;0;0;False;0;False;0;0.751;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;960,192;Inherit;False;Property;_LowShakeIntensity;Low Shake Intensity;10;0;Create;True;0;0;0;False;0;False;0;0.025;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;960,272;Inherit;False;Property;_LowZoomIntensity;Low Zoom Intensity;8;0;Create;True;0;0;0;False;0;False;1;0.417;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;960,352;Inherit;False;Property;_LowMidChromaticStart;LowMid Chromatic Start;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;960,432;Inherit;False;Property;_LowMidChromaticIntensity;LowMid Chromatic Intensity;12;0;Create;True;0;0;0;False;0;False;0;0.168;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;114;1024,720;Inherit;False;Property;_SpectrogramOrigin;Spectrogram Origin ;18;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.475;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;127;928,832;Inherit;False;Property;_Spectrograminnerradius;Spectrogram inner radius;16;0;Create;True;0;0;0;False;0;False;0;0.263;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;928,1088;Inherit;False;Property;_Spectrogramouterradius;Spectrogram outer radius;17;0;Create;True;0;0;0;False;0;False;0.09176044;0.6678309;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;1392,1040;Inherit;False;Property;_Debug_High;Debug_High;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;1392,1120;Inherit;False;Property;_Debug_HighMid;Debug_HighMid;23;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;1392,1200;Inherit;False;Property;_Debug_LowMid;Debug_LowMid;22;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;1392,1280;Inherit;False;Property;_Debug_Low;Debug_Low;21;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;960,32;Inherit;False;Property;_LogoSize;Logo Size;7;0;Create;True;0;0;0;False;0;False;2.06;1.82;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;960,528;Inherit;False;Property;_MidHighShakeIntensity;MidHigh Shake Intensity;15;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;193;1296,-240;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;98;960,592;Inherit;False;Property;_MidHighShakeSpeed;MidHigh Shake Speed;13;0;Create;True;0;0;0;False;0;False;0;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;960,656;Inherit;False;Property;_HighGlitchIntensity;High Glitch Intensity;14;0;Create;True;0;0;0;False;0;False;0;0.0163;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;1248,-64;Inherit;True;Property;_Logo;Logo;6;0;Create;True;0;0;0;False;0;False;None;62f36c08f92a3c64ba09a34c409ad3fe;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;150;960,896;Inherit;False;Property;_Spectograminnercolor;Spectogram inner color;20;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;136;960,1168;Inherit;False;Property;_Spectogramoutercolor;Spectogram outer color;19;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FunctionNode;227;1568,336;Inherit;False;M_MusicVisualizer;0;;678;aae0baf1667c3fa44bf9aa9beb3c4b54;0;20;120;FLOAT2;0,0;False;105;SAMPLER2D;0;False;103;FLOAT;0;False;111;FLOAT;0;False;110;FLOAT;0;False;104;FLOAT;0;False;101;FLOAT;0;False;102;FLOAT;0;False;113;FLOAT;0;False;112;FLOAT;0;False;129;FLOAT;0;False;114;FLOAT2;0,0;False;115;FLOAT;0;False;119;COLOR;0,0,0,0;False;116;FLOAT;0;False;117;COLOR;0,0,0,0;False;106;FLOAT;0;False;107;FLOAT;0;False;108;FLOAT;0;False;109;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;191;1984,336;Inherit;False;Alpha Split;-1;;677;07dab7960105b86429ac8eebd729ed6d;0;1;2;FLOAT4;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2304,224;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;CustomLighting;MyroP/MusicVisualizer;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;5;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;227;120;193;0
WireConnection;227;105;1;0
WireConnection;227;103;27;0
WireConnection;227;111;40;0
WireConnection;227;110;56;0
WireConnection;227;104;31;0
WireConnection;227;101;75;0
WireConnection;227;102;74;0
WireConnection;227;113;104;0
WireConnection;227;112;98;0
WireConnection;227;129;196;0
WireConnection;227;114;114;0
WireConnection;227;115;127;0
WireConnection;227;119;150;0
WireConnection;227;116;129;0
WireConnection;227;117;136;0
WireConnection;227;106;2;0
WireConnection;227;107;3;0
WireConnection;227;108;4;0
WireConnection;227;109;5;0
WireConnection;191;2;227;0
WireConnection;0;2;191;0
WireConnection;0;10;191;6
ASEEND*/
//CHKSM=E7507389478BFC7017F679FB656514A724D02FB1