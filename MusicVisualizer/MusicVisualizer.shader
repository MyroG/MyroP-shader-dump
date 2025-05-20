// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/MusicVisualizer"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Logo("Logo", 2D) = "white" {}
		_DefaultLogoZoom("DefaultLogoZoom", Range( 0 , 5)) = 2.06
		_BassIntensity("Bass Intensity", Range( 0 , 2)) = 1
		_BassShakeStart("Bass Shake Start", Range( 0 , 1)) = 0
		_BassShakeIntensity("Bass Shake Intensity", Range( 0 , 1)) = 0
		_LowMidChromaticStart("LowMid Chromatic Start", Range( 0 , 1)) = 0
		_LowMidChromaticIntensity("LowMid Chromatic Intensity", Range( 0 , 1)) = 0
		_ShakeSpeed("Shake Speed", Range( 0 , 500)) = 0
		_ShakeIntensity("Shake Intensity", Range( 0 , 1)) = 1
		_Spectrograminnercircle("Spectrogram inner circle", Range( 0 , 1)) = 0
		_Spectrogramoutercircle("Spectrogram outer circle", Range( 0 , 1)) = 0.09176044
		_SpectrogramOrigin("Spectrogram Origin ", Vector) = (0.5,0.5,0,0)
		[HDR]_Spectogramcolor("Spectogram color", Color) = (0,0,0,0)
		[HDR]_Innercirclecolor("Inner circle color", Color) = (1,1,1,1)
		_Spectrogramrotationinrad("Spectrogram rotation in rad", Range( 0 , 6.16)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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

		uniform sampler2D _Logo;
		uniform float _DefaultLogoZoom;
		uniform float _BassIntensity;
		uniform float _BassShakeIntensity;
		uniform float _BassShakeStart;
		uniform float _ShakeSpeed;
		uniform float _ShakeIntensity;
		uniform float _LowMidChromaticIntensity;
		uniform float _LowMidChromaticStart;
		uniform float _Spectrograminnercircle;
		uniform float2 _SpectrogramOrigin;
		uniform float4 _Innercirclecolor;
		uniform float4 _Spectogramcolor;
		uniform float _Spectrogramoutercircle;
		uniform float _Spectrogramrotationinrad;
		uniform float _Cutoff = 0.5;


		inline float AudioLinkData3_g39( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g38( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g37( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g43( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		float MyCustomExpression1_g44( float x )
		{
			return AudioLinkLerpMultiline( ALPASS_DFT + float2( x * AUDIOLINK_ETOTALBINS, 0.0f ) ).rrrr;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			int Band3_g39 = 0;
			int Delay3_g39 = 0;
			float localAudioLinkData3_g39 = AudioLinkData3_g39( Band3_g39 , Delay3_g39 );
			float Bass41 = localAudioLinkData3_g39;
			float temp_output_3_0_g42 = ( _DefaultLogoZoom - ( Bass41 * _BassIntensity ) );
			float2 temp_cast_4 = (_Time.y).xx;
			float dotResult4_g40 = dot( temp_cast_4 , float2( 12.9898,78.233 ) );
			float lerpResult10_g40 = lerp( -_BassShakeIntensity , _BassShakeIntensity , frac( ( sin( dotResult4_g40 ) * 43758.55 ) ));
			float mulTime52 = _Time.y * 0.5;
			float2 temp_cast_5 = (mulTime52).xx;
			float dotResult4_g41 = dot( temp_cast_5 , float2( 12.9898,78.233 ) );
			float lerpResult10_g41 = lerp( -_BassShakeIntensity , _BassShakeIntensity , frac( ( sin( dotResult4_g41 ) * 43758.55 ) ));
			float2 appendResult53 = (float2(lerpResult10_g40 , lerpResult10_g41));
			int Band3_g38 = 2;
			int Delay3_g38 = 0;
			float localAudioLinkData3_g38 = AudioLinkData3_g38( Band3_g38 , Delay3_g38 );
			float HighMid94 = localAudioLinkData3_g38;
			float mulTime92 = _Time.y * ( HighMid94 * _ShakeSpeed );
			int Band3_g37 = 3;
			int Delay3_g37 = 0;
			float localAudioLinkData3_g37 = AudioLinkData3_g37( Band3_g37 , Delay3_g37 );
			float High113 = localAudioLinkData3_g37;
			float mulTime108 = _Time.y * ( High113 * _ShakeSpeed );
			float2 appendResult100 = (float2(( sin( mulTime92 ) * _ShakeIntensity ) , ( cos( mulTime108 ) * _ShakeIntensity )));
			float2 TransformedUV148 = ( ( (i.uv_texcoord*temp_output_3_0_g42 + ( ( 1.0 - temp_output_3_0_g42 ) / 2.0 )) + ( appendResult53 * saturate( ( Bass41 - _BassShakeStart ) ) ) ) + appendResult100 );
			float2 temp_output_11_0_g46 = TransformedUV148;
			int Band3_g43 = 1;
			int Delay3_g43 = 0;
			float localAudioLinkData3_g43 = AudioLinkData3_g43( Band3_g43 , Delay3_g43 );
			float LowMid77 = localAudioLinkData3_g43;
			float temp_output_1_0_g46 = ( _LowMidChromaticIntensity * saturate( ( LowMid77 - _LowMidChromaticStart ) ) );
			float temp_output_3_0_g47 = ( 1.0 - temp_output_1_0_g46 );
			float4 tex2DNode14_g46 = tex2D( _Logo, (temp_output_11_0_g46*temp_output_3_0_g47 + ( ( 1.0 - temp_output_3_0_g47 ) / 2.0 )) );
			float temp_output_3_0_g48 = ( 1.0 - ( temp_output_1_0_g46 / 2.0 ) );
			float4 tex2DNode18_g46 = tex2D( _Logo, (temp_output_11_0_g46*temp_output_3_0_g48 + ( ( 1.0 - temp_output_3_0_g48 ) / 2.0 )) );
			float4 tex2DNode19_g46 = tex2D( _Logo, temp_output_11_0_g46 );
			float4 appendResult21_g46 = (float4(tex2DNode14_g46.r , tex2DNode18_g46.g , tex2DNode19_g46.b , ( tex2DNode14_g46.a + tex2DNode18_g46.a + tex2DNode19_g46.a )));
			float4 temp_output_2_0_g49 = appendResult21_g46;
			float temp_output_73_6 = (temp_output_2_0_g49).w;
			float temp_output_116_0 = distance( _SpectrogramOrigin , TransformedUV148 );
			float2 normalizeResult122 = normalize( ( TransformedUV148 - _SpectrogramOrigin ) );
			float2 break120 = normalizeResult122;
			float x1_g44 = ( ( ( ( atan2( abs( break120.x ) , break120.y ) + UNITY_PI ) % UNITY_PI ) / UNITY_PI ) + _Spectrogramrotationinrad );
			float localMyCustomExpression1_g44 = MyCustomExpression1_g44( x1_g44 );
			float ifLocalVar13 = 0;
			if( ( _Spectrogramoutercircle * localMyCustomExpression1_g44 ) > ( temp_output_116_0 - _Spectrograminnercircle ) )
				ifLocalVar13 = 1.0;
			else if( ( _Spectrogramoutercircle * localMyCustomExpression1_g44 ) == ( temp_output_116_0 - _Spectrograminnercircle ) )
				ifLocalVar13 = 0.0;
			else if( ( _Spectrogramoutercircle * localMyCustomExpression1_g44 ) < ( temp_output_116_0 - _Spectrograminnercircle ) )
				ifLocalVar13 = 0.0;
			float4 appendResult4_g45 = (float4(( _Spectogramcolor.rgb * ifLocalVar13 ) , ifLocalVar13));
			float4 temp_output_153_0 = appendResult4_g45;
			float4 ifLocalVar149 = 0;
			if( _Spectrograminnercircle <= temp_output_116_0 )
				ifLocalVar149 = temp_output_153_0;
			else
				ifLocalVar149 = _Innercirclecolor;
			float4 SpectogramColor132 = ifLocalVar149;
			float4 temp_output_2_0_g50 = SpectogramColor132;
			c.rgb = 0;
			c.a = 1;
			clip( ( temp_output_73_6 + (temp_output_2_0_g50).a ) - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			int Band3_g39 = 0;
			int Delay3_g39 = 0;
			float localAudioLinkData3_g39 = AudioLinkData3_g39( Band3_g39 , Delay3_g39 );
			float Bass41 = localAudioLinkData3_g39;
			float temp_output_3_0_g42 = ( _DefaultLogoZoom - ( Bass41 * _BassIntensity ) );
			float2 temp_cast_0 = (_Time.y).xx;
			float dotResult4_g40 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
			float lerpResult10_g40 = lerp( -_BassShakeIntensity , _BassShakeIntensity , frac( ( sin( dotResult4_g40 ) * 43758.55 ) ));
			float mulTime52 = _Time.y * 0.5;
			float2 temp_cast_1 = (mulTime52).xx;
			float dotResult4_g41 = dot( temp_cast_1 , float2( 12.9898,78.233 ) );
			float lerpResult10_g41 = lerp( -_BassShakeIntensity , _BassShakeIntensity , frac( ( sin( dotResult4_g41 ) * 43758.55 ) ));
			float2 appendResult53 = (float2(lerpResult10_g40 , lerpResult10_g41));
			int Band3_g38 = 2;
			int Delay3_g38 = 0;
			float localAudioLinkData3_g38 = AudioLinkData3_g38( Band3_g38 , Delay3_g38 );
			float HighMid94 = localAudioLinkData3_g38;
			float mulTime92 = _Time.y * ( HighMid94 * _ShakeSpeed );
			int Band3_g37 = 3;
			int Delay3_g37 = 0;
			float localAudioLinkData3_g37 = AudioLinkData3_g37( Band3_g37 , Delay3_g37 );
			float High113 = localAudioLinkData3_g37;
			float mulTime108 = _Time.y * ( High113 * _ShakeSpeed );
			float2 appendResult100 = (float2(( sin( mulTime92 ) * _ShakeIntensity ) , ( cos( mulTime108 ) * _ShakeIntensity )));
			float2 TransformedUV148 = ( ( (i.uv_texcoord*temp_output_3_0_g42 + ( ( 1.0 - temp_output_3_0_g42 ) / 2.0 )) + ( appendResult53 * saturate( ( Bass41 - _BassShakeStart ) ) ) ) + appendResult100 );
			float2 temp_output_11_0_g46 = TransformedUV148;
			int Band3_g43 = 1;
			int Delay3_g43 = 0;
			float localAudioLinkData3_g43 = AudioLinkData3_g43( Band3_g43 , Delay3_g43 );
			float LowMid77 = localAudioLinkData3_g43;
			float temp_output_1_0_g46 = ( _LowMidChromaticIntensity * saturate( ( LowMid77 - _LowMidChromaticStart ) ) );
			float temp_output_3_0_g47 = ( 1.0 - temp_output_1_0_g46 );
			float4 tex2DNode14_g46 = tex2D( _Logo, (temp_output_11_0_g46*temp_output_3_0_g47 + ( ( 1.0 - temp_output_3_0_g47 ) / 2.0 )) );
			float temp_output_3_0_g48 = ( 1.0 - ( temp_output_1_0_g46 / 2.0 ) );
			float4 tex2DNode18_g46 = tex2D( _Logo, (temp_output_11_0_g46*temp_output_3_0_g48 + ( ( 1.0 - temp_output_3_0_g48 ) / 2.0 )) );
			float4 tex2DNode19_g46 = tex2D( _Logo, temp_output_11_0_g46 );
			float4 appendResult21_g46 = (float4(tex2DNode14_g46.r , tex2DNode18_g46.g , tex2DNode19_g46.b , ( tex2DNode14_g46.a + tex2DNode18_g46.a + tex2DNode19_g46.a )));
			float4 temp_output_2_0_g49 = appendResult21_g46;
			float temp_output_116_0 = distance( _SpectrogramOrigin , TransformedUV148 );
			float2 normalizeResult122 = normalize( ( TransformedUV148 - _SpectrogramOrigin ) );
			float2 break120 = normalizeResult122;
			float x1_g44 = ( ( ( ( atan2( abs( break120.x ) , break120.y ) + UNITY_PI ) % UNITY_PI ) / UNITY_PI ) + _Spectrogramrotationinrad );
			float localMyCustomExpression1_g44 = MyCustomExpression1_g44( x1_g44 );
			float ifLocalVar13 = 0;
			if( ( _Spectrogramoutercircle * localMyCustomExpression1_g44 ) > ( temp_output_116_0 - _Spectrograminnercircle ) )
				ifLocalVar13 = 1.0;
			else if( ( _Spectrogramoutercircle * localMyCustomExpression1_g44 ) == ( temp_output_116_0 - _Spectrograminnercircle ) )
				ifLocalVar13 = 0.0;
			else if( ( _Spectrogramoutercircle * localMyCustomExpression1_g44 ) < ( temp_output_116_0 - _Spectrograminnercircle ) )
				ifLocalVar13 = 0.0;
			float4 appendResult4_g45 = (float4(( _Spectogramcolor.rgb * ifLocalVar13 ) , ifLocalVar13));
			float4 temp_output_153_0 = appendResult4_g45;
			float4 ifLocalVar149 = 0;
			if( _Spectrograminnercircle <= temp_output_116_0 )
				ifLocalVar149 = temp_output_153_0;
			else
				ifLocalVar149 = _Innercirclecolor;
			float4 SpectogramColor132 = ifLocalVar149;
			float4 temp_output_2_0_g50 = SpectogramColor132;
			float temp_output_73_6 = (temp_output_2_0_g49).w;
			float3 lerpResult142 = lerp( (temp_output_2_0_g49).xyz , (temp_output_2_0_g50).rgb , saturate( ( 1.0 - temp_output_73_6 ) ));
			o.Emission = lerpResult142;
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
Node;AmplifyShaderEditor.FunctionNode;95;-1872,-1216;Inherit;False;4BandAmplitude;-1;;37;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;3;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;93;-1888,-816;Inherit;False;4BandAmplitude;-1;;38;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;2;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;62;-2210,366;Inherit;False;1316;611;Bass Shake;12;56;36;52;61;35;51;53;40;43;45;46;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;30;-1872,-384;Inherit;False;4BandAmplitude;-1;;39;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1616,-832;Inherit;False;HighMid;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-1584,-1232;Inherit;False;High;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;63;-1840,0;Inherit;False;948;339;Bass Zoom;7;31;42;32;34;27;64;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2160,656;Inherit;False;Property;_BassShakeIntensity;Bass Shake Intensity;9;0;Create;True;0;0;0;False;0;False;0;0.025;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-1600,-416;Inherit;False;Bass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-800,704;Inherit;False;94;HighMid;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-832,1088;Inherit;False;113;High;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-880,800;Inherit;False;Property;_ShakeSpeed;Shake Speed;12;0;Create;True;0;0;0;False;0;False;0;72;0;500;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-1952,416;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-1952,496;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;61;-1808,608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1776,224;Inherit;False;Property;_BassIntensity;Bass Intensity;7;0;Create;True;0;0;0;False;0;False;1;0.417;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1712,144;Inherit;False;41;Bass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1840,864;Inherit;False;Property;_BassShakeStart;Bass Shake Start;8;0;Create;True;0;0;0;False;0;False;0;0.751;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1792,736;Inherit;False;41;Bass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-560,720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-596.8461,1102.339;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;35;-1584,416;Inherit;False;Random Range;-1;;40;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;51;-1584,576;Inherit;False;Random Range;-1;;41;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1456,160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1792,48;Inherit;False;Property;_DefaultLogoZoom;DefaultLogoZoom;6;0;Create;True;0;0;0;False;0;False;2.06;1.82;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-1520,800;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;92;-400,720;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;108;-436.8461,1102.339;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-1360,496;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-1296,160;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-1312,800;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1392,32;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;102;-176,784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;112;-256,1120;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-336,880;Inherit;False;Property;_ShakeIntensity;Shake Intensity;13;0;Create;True;0;0;0;False;0;False;1;0.042;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1072,624;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;64;-1104,112;Inherit;False;M_Zoom;-1;;42;8f7343c5452fd0e45b8eeb9a1810d401;0;2;6;FLOAT2;0,0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-48,784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-80,1088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-800,336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;96,848;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;141.1765,493.9849;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;331.3408,589.8193;Inherit;False;TransformedUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-848,1856;Inherit;False;148;TransformedUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;114;-848,1696;Inherit;False;Property;_SpectrogramOrigin;Spectrogram Origin ;16;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.47;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;119;-560,1872;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;122;-400,1936;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;120;-208,1952;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.AbsOpNode;177;-80,1952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;118;48,1984;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;172;-144,2288;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;131;112,2112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3.141592;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;124;240,2000;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;6.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;272,2224;Inherit;False;Property;_Spectrogramrotationinrad;Spectrogram rotation in rad;19;0;Create;True;0;0;0;False;0;False;0;0;0;6.16;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;121;400,2000;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;6.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;571.6526,2117.073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;76;-1872,-592;Inherit;False;4BandAmplitude;-1;;43;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;1;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;116;-416,1728;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;32,1472;Inherit;False;Property;_Spectrogramoutercircle;Spectrogram outer circle;15;0;Create;True;0;0;0;False;0;False;0.09176044;0.522;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;159;176,1552;Inherit;False;M_DFT;-1;;44;7f3d9fdbff4c9de43a7ed1e2a13b88ee;0;1;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1584,-576;Inherit;False;LowMid;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-224,1824;Inherit;False;Property;_Spectrograminnercircle;Spectrogram inner circle;14;0;Create;True;0;0;0;False;0;False;0;0.299;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;352,1744;Inherit;False;Constant;_Float1;Float 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;352,1808;Inherit;False;Constant;_Float2;Float 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;352,1664;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;0,1632;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;384,1520;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-608,176;Inherit;False;Property;_LowMidChromaticStart;LowMid Chromatic Start;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-512,96;Inherit;False;77;LowMid;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;13;560,1552;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;136;528,1312;Inherit;False;Property;_Spectogramcolor;Spectogram color;17;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleSubtractOpNode;78;-304,112;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1872,-256;Inherit;True;Property;_Logo;Logo;1;0;Create;True;0;0;0;False;0;False;7682a0d099898344a95aea6c5677b45f;7682a0d099898344a95aea6c5677b45f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;816,1408;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;80;-144,112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-272,32;Inherit;False;Property;_LowMidChromaticIntensity;LowMid Chromatic Intensity;11;0;Create;True;0;0;0;False;0;False;0;0.125;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-1600,-256;Inherit;False;Logo;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;153;1232,1520;Inherit;False;Alpha Merge;-1;;45;e0d79828992f19c4f90bfc29aa19b7a5;0;2;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;150;1136,1808;Inherit;False;Property;_Innercirclecolor;Inner circle color;18;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,0,0,0.3607843;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;32,64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;7;-16,336;Inherit;False;6;Logo;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ConditionalIfNode;149;1440,1680;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;71;256,336;Inherit;False;M_Chromatic_abberation;-1;;46;b6201a9a56afebd4589a98d6e55b9232;0;3;1;FLOAT;0;False;3;SAMPLER2D;0;False;11;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;73;528,336;Inherit;False;Alpha Split;-1;;49;07dab7960105b86429ac8eebd729ed6d;0;1;2;FLOAT4;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;1968,1600;Inherit;False;SpectogramColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;528,720;Inherit;False;132;SpectogramColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;146;704,448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;154;800,720;Inherit;False;Alpha Split;-1;;50;07dab7960105b86429ac8eebd729ed6d;0;1;2;COLOR;0,0,0,0;False;2;FLOAT3;0;FLOAT;6
Node;AmplifyShaderEditor.SaturateNode;147;864,560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1920,-880;Inherit;False;Property;_Debug_HighMid;Debug_HighMid;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1904,-1296;Inherit;False;Property;_Debug_High;Debug_High;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1904,-656;Inherit;False;Property;_Debug_LowMid;Debug_LowMid;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1904,-448;Inherit;False;Property;_Debug_Low;Debug_Low;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;1360,448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;142;1152,592;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1936,160;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;CustomLighting;MyroP/MusicVisualizer;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;94;0;93;0
WireConnection;113;0;95;0
WireConnection;41;0;30;0
WireConnection;61;0;56;0
WireConnection;97;0;96;0
WireConnection;97;1;98;0
WireConnection;107;0;105;0
WireConnection;107;1;98;0
WireConnection;35;1;36;0
WireConnection;35;2;61;0
WireConnection;35;3;56;0
WireConnection;51;1;52;0
WireConnection;51;2;61;0
WireConnection;51;3;56;0
WireConnection;32;0;42;0
WireConnection;32;1;31;0
WireConnection;45;0;43;0
WireConnection;45;1;40;0
WireConnection;92;0;97;0
WireConnection;108;0;107;0
WireConnection;53;0;35;0
WireConnection;53;1;51;0
WireConnection;34;0;27;0
WireConnection;34;1;32;0
WireConnection;46;0;45;0
WireConnection;102;0;92;0
WireConnection;112;0;108;0
WireConnection;47;0;53;0
WireConnection;47;1;46;0
WireConnection;64;6;65;0
WireConnection;64;3;34;0
WireConnection;99;0;102;0
WireConnection;99;1;104;0
WireConnection;111;0;112;0
WireConnection;111;1;104;0
WireConnection;48;0;64;0
WireConnection;48;1;47;0
WireConnection;100;0;99;0
WireConnection;100;1;111;0
WireConnection;101;0;48;0
WireConnection;101;1;100;0
WireConnection;148;0;101;0
WireConnection;119;0;141;0
WireConnection;119;1;114;0
WireConnection;122;0;119;0
WireConnection;120;0;122;0
WireConnection;177;0;120;0
WireConnection;118;0;177;0
WireConnection;118;1;120;1
WireConnection;131;0;118;0
WireConnection;131;1;172;0
WireConnection;124;0;131;0
WireConnection;124;1;172;0
WireConnection;121;0;124;0
WireConnection;121;1;172;0
WireConnection;170;0;121;0
WireConnection;170;1;169;0
WireConnection;116;0;114;0
WireConnection;116;1;141;0
WireConnection;159;2;170;0
WireConnection;77;0;76;0
WireConnection;128;0;116;0
WireConnection;128;1;127;0
WireConnection;130;0;129;0
WireConnection;130;1;159;0
WireConnection;13;0;130;0
WireConnection;13;1;128;0
WireConnection;13;2;14;0
WireConnection;13;3;16;0
WireConnection;13;4;15;0
WireConnection;78;0;79;0
WireConnection;78;1;75;0
WireConnection;152;0;136;5
WireConnection;152;1;13;0
WireConnection;80;0;78;0
WireConnection;6;0;1;0
WireConnection;153;2;152;0
WireConnection;153;3;13;0
WireConnection;81;0;74;0
WireConnection;81;1;80;0
WireConnection;149;0;127;0
WireConnection;149;1;116;0
WireConnection;149;2;150;0
WireConnection;149;3;153;0
WireConnection;149;4;153;0
WireConnection;71;1;81;0
WireConnection;71;3;7;0
WireConnection;71;11;148;0
WireConnection;73;2;71;0
WireConnection;132;0;149;0
WireConnection;146;0;73;6
WireConnection;154;2;133;0
WireConnection;147;0;146;0
WireConnection;135;0;73;6
WireConnection;135;1;154;6
WireConnection;142;0;73;0
WireConnection;142;1;154;0
WireConnection;142;2;147;0
WireConnection;0;2;142;0
WireConnection;0;10;135;0
ASEEND*/
//CHKSM=8D35F8DA6C2B3D094C67034359E9FC72C43B68F3