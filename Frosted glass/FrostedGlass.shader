// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/FrostedGlass"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_MainTextureintensity("Main Texture intensity", Range( 0 , 1)) = 1
		[HDR]_Colorinner("Color inner", Color) = (0.3254902,0.8862745,1,1)
		[HDR]_Colorouter("Color outer", Color) = (0,0.772549,0.9215686,1)
		_Emission("Emission", 2D) = "black" {}
		_Overallintensity("Overall intensity", Range( 0 , 5)) = 1
		_Specularintensity("Specular intensity", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Normal("Normal", 2D) = "bump" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 5)) = 1
		_Occlusion("Occlusion", 2D) = "white" {}
		_BlurMask("Blur Mask", 2D) = "white" {}
		_Blur("Blur", Range( 0 , 10)) = 0
		_RefractionMask("Refraction Mask", 2D) = "white" {}
		_Refraction("Refraction", Range( 0 , 1)) = 0.792
		[Toggle(_FRESNEL_ON)] _Fresnel("Fresnel", Float) = 1
		_TransparencyFresnelBias("Transparency Fresnel Bias", Float) = 0
		_TransparencyFresnelScale("Transparency Fresnel Scale", Float) = 1
		_TransparencyFresnelPower("Transparency Fresnel Power", Float) = 2
		_Fallbackcubemap("Fallback cubemap", CUBE) = "white" {}
		[Enum(UnityEngine.Rendering.CullMode)]_Culling("Culling", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Cull]
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature_local _FRESNEL_ON
		#define ASE_VERSION 19801
		#include "UnityCG.cginc"
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
		};

		uniform float _Culling;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _NormalIntensity;
		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float _MainTextureintensity;
		uniform float4 _Colorinner;
		uniform float4 _Colorouter;
		uniform float _TransparencyFresnelBias;
		uniform float _TransparencyFresnelScale;
		uniform float _TransparencyFresnelPower;
		uniform float _Refraction;
		uniform sampler2D _RefractionMask;
		uniform float4 _RefractionMask_ST;
		uniform float _Blur;
		uniform sampler2D _BlurMask;
		uniform float4 _BlurMask_ST;
		uniform samplerCUBE _Fallbackcubemap;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _Overallintensity;
		uniform float _Specularintensity;
		uniform float _Smoothness;


		float3 Reflectionprobesampler1( float3 viewDir, float3 normal, float IOR, float Mipmap, samplerCUBE fallbackCube, float3 worldPos )
		{
			float3 dir = refract(-normalize(viewDir), normalize(normal), IOR);
			#ifdef UNITY_SPECCUBE_BOX_PROJECTION
			    dir = BoxProjectedCubemapDirection(
			        dir,
			        worldPos,
			        unity_SpecCube0_ProbePosition,
			        unity_SpecCube0_BoxMin,
			        unity_SpecCube0_BoxMax
			    );
			#endif
			float4 rawProbe = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, dir, Mipmap);
			bool noProbe = (dot(rawProbe.rgb, rawProbe.rgb) + rawProbe.a) < 0.01; //fallback probe, not box projected
			if (noProbe)
			{
			    return texCUBElod(fallbackCube, float4(dir, Mipmap)).rgb;
			}
			else
			{
			    float4 col = rawProbe;
			    col.rgb = DecodeHDR(col, unity_SpecCube0_HDR);
			    float3 probeRGB = col.rgb;
			    return probeRGB;
			}
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 NormalFinal65 = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _NormalIntensity );
			o.Normal = NormalFinal65;
			float4 color56 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float3 lerpResult55 = lerp( color56.rgb , tex2D( _MainTexture, uv_MainTexture ).rgb , _MainTextureintensity);
			float4 color81 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 switchResult63 = (((i.ASEIsFrontFacing>0)?(ase_normalWS):(-ase_normalWS)));
			float fresnelNdotV18 = dot( switchResult63, ase_viewDirWS );
			float fresnelNode18 = ( _TransparencyFresnelBias + _TransparencyFresnelScale * pow( 1.0 - fresnelNdotV18, _TransparencyFresnelPower ) );
			#ifdef _FRESNEL_ON
				float staticSwitch80 = saturate( fresnelNode18 );
			#else
				float staticSwitch80 = color81.r;
			#endif
			float Transparency_Fresnel22 = staticSwitch80;
			float3 lerpResult25 = lerp( _Colorinner.rgb , _Colorouter.rgb , Transparency_Fresnel22);
			float3 viewDir1 = ase_viewDirWS;
			float3 newWorldNormal31 = (WorldNormalVector( i , NormalFinal65 ));
			float3 switchResult59 = (((i.ASEIsFrontFacing>0)?(newWorldNormal31):(-newWorldNormal31)));
			float3 normal1 = switchResult59;
			float2 uv_RefractionMask = i.uv_texcoord * _RefractionMask_ST.xy + _RefractionMask_ST.zw;
			float IOR1 = ( _Refraction * tex2D( _RefractionMask, uv_RefractionMask ).r );
			float2 uv_BlurMask = i.uv_texcoord * _BlurMask_ST.xy + _BlurMask_ST.zw;
			float Mipmap1 = ( _Blur * tex2D( _BlurMask, uv_BlurMask ).b );
			samplerCUBE fallbackCube1 = _Fallbackcubemap;
			float4 transform74 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 worldPos1 = transform74.xyz;
			float3 localReflectionprobesampler1 = Reflectionprobesampler1( viewDir1 , normal1 , IOR1 , Mipmap1 , fallbackCube1 , worldPos1 );
			float3 FakeTransparency67 = localReflectionprobesampler1;
			float2 uv_Occlusion = i.uv_texcoord * _Occlusion_ST.xy + _Occlusion_ST.zw;
			float4 tex2DNode34 = tex2D( _Occlusion, uv_Occlusion );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = ( ( ( ( lerpResult55 * lerpResult25 ) * FakeTransparency67 * tex2DNode34.g ) + tex2D( _Emission, uv_Emission ).rgb ) * _Overallintensity );
			float4 color78 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			o.Specular = ( color78.rgb * _Specularintensity );
			o.Smoothness = _Smoothness;
			o.Occlusion = tex2DNode34.g;
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
			#pragma target 4.0
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
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.CommentaryNode;71;-2637,-576;Inherit;False;1203;373;Normal map;3;65;41;29;Normal map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;-1968,944;Inherit;False;1813.55;538.1277;Comment;11;21;20;19;22;23;18;63;62;61;80;81;Rim light effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;61;-1936,1008;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;41;-2576,-496;Inherit;False;Property;_NormalIntensity;Normal Intensity;9;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;62;-1728,1104;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;29;-2272,-512;Inherit;True;Property;_Normal;Normal;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwitchByFaceNode;63;-1552,1024;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1744,1216;Inherit;False;Property;_TransparencyFresnelBias;Transparency Fresnel Bias;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1744,1296;Inherit;False;Property;_TransparencyFresnelScale;Transparency Fresnel Scale;17;0;Create;True;0;0;0;False;0;False;1;1.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1744,1376;Inherit;False;Property;_TransparencyFresnelPower;Transparency Fresnel Power;18;0;Create;True;0;0;0;False;0;False;2;2.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;64;-2192,-48;Inherit;False;1596.925;878.7267;Comment;15;67;1;6;38;40;73;59;72;8;39;60;9;31;68;74;Fake transparency, sampling the reflection probe;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1952,-512;Inherit;False;NormalFinal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;18;-1328,1024;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2160,160;Inherit;False;65;NormalFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;81;-1024,1264;Inherit;False;Constant;_Black;Black;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode;23;-992,1024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;31;-1984,160;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;39;-2080,384;Inherit;True;Property;_RefractionMask;Refraction Mask;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;8;-2080,304;Inherit;False;Property;_Refraction;Refraction;14;0;Create;True;0;0;0;False;0;False;0.792;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;80;-704,1328;Inherit;False;Property;_Fresnel;Fresnel;15;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;-1664,432;Inherit;True;Property;_BlurMask;Blur Mask;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;9;-1600,352;Inherit;False;Property;_Blur;Blur;12;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;60;-1776,224;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1170,-1170;Inherit;False;915.3218;1054;Glass Color;9;77;25;55;15;13;54;24;56;32;Glass Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwitchByFaceNode;59;-1616,160;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1328,352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1760,304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;38;-1392,624;Inherit;True;Property;_Fallbackcubemap;Fallback cubemap;19;0;Create;True;0;0;0;False;0;False;None;None;False;white;LockedToCube;Cube;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-1616,16;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;74;-1136,336;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-448,1328;Inherit;False;Transparency Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-1072,-400;Inherit;False;Property;_Colorouter;Color outer;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0.772549,0.9215686,1;0.7471075,0.9371457,0.9716981,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;32;-1136,-912;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;54;-1136,-704;Inherit;False;Property;_MainTextureintensity;Main Texture intensity;1;0;Create;True;0;0;0;False;0;False;1;0.205;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1104,-192;Inherit;False;22;Transparency Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1072,-608;Inherit;False;Property;_Colorinner;Color inner;2;1;[HDR];Create;True;0;0;0;False;0;False;0.3254902,0.8862745,1,1;0.5896226,0.7730856,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;56;-1136,-1120;Inherit;False;Constant;_White;White;17;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CustomExpressionNode;1;-1104,16;Inherit;False;float3 dir = refract(-normalize(viewDir), normalize(normal), IOR)@$$#ifdef UNITY_SPECCUBE_BOX_PROJECTION$    dir = BoxProjectedCubemapDirection($        dir,$        worldPos,$        unity_SpecCube0_ProbePosition,$        unity_SpecCube0_BoxMin,$        unity_SpecCube0_BoxMax$    )@$#endif$$float4 rawProbe = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, dir, Mipmap)@$bool noProbe = (dot(rawProbe.rgb, rawProbe.rgb) + rawProbe.a) < 0.01@ //fallback probe, not box projected$$if (noProbe)${$    return texCUBElod(fallbackCube, float4(dir, Mipmap)).rgb@$}$else${$    float4 col = rawProbe@$    col.rgb = DecodeHDR(col, unity_SpecCube0_HDR)@$    float3 probeRGB = col.rgb@$    return probeRGB@$};3;Create;6;True;viewDir;FLOAT3;0,0,0;In;;Inherit;False;True;normal;FLOAT3;0,0,0;In;;Inherit;False;True;IOR;FLOAT;1;In;;Inherit;False;True;Mipmap;FLOAT;0;In;;Inherit;False;True;fallbackCube;SAMPLERCUBE;;In;;Inherit;False;True;worldPos;FLOAT3;0,0,0;In;;Inherit;False;Reflection probe sampler;True;False;0;;False;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;SAMPLERCUBE;;False;5;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-832,16;Inherit;False;FakeTransparency;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;25;-752,-576;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;55;-752,-864;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-304,80;Inherit;False;67;FakeTransparency;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;34;-416,432;Inherit;True;Property;_Occlusion;Occlusion;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-448,-304;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;35;-416,224;Inherit;True;Property;_Emission;Emission;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-32,-48;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;256,-48;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;96,192;Inherit;False;Property;_Overallintensity;Overall intensity;5;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-4.201416,-459.9322;Inherit;False;Constant;_Color1;Color 1;19;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;75;-112,-256;Inherit;False;Property;_Specularintensity;Specular intensity;6;0;Create;True;0;0;0;False;0;False;0;1E-05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;416,128;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;0.49;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;400,0;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;272,-336;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;496,-80;Inherit;False;65;NormalFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;82;368,592;Inherit;False;Property;_Culling;Culling;20;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;720,32;Float;False;True;-1;4;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;MyroP/FrostedGlass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;1;Include;UnityCG.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;62;0;61;0
WireConnection;29;5;41;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;65;0;29;0
WireConnection;18;0;63;0
WireConnection;18;1;19;0
WireConnection;18;2;20;0
WireConnection;18;3;21;0
WireConnection;23;0;18;0
WireConnection;31;0;68;0
WireConnection;80;1;81;1
WireConnection;80;0;23;0
WireConnection;60;0;31;0
WireConnection;59;0;31;0
WireConnection;59;1;60;0
WireConnection;73;0;9;0
WireConnection;73;1;72;3
WireConnection;40;0;8;0
WireConnection;40;1;39;1
WireConnection;22;0;80;0
WireConnection;1;0;6;0
WireConnection;1;1;59;0
WireConnection;1;2;40;0
WireConnection;1;3;73;0
WireConnection;1;4;38;0
WireConnection;1;5;74;0
WireConnection;67;0;1;0
WireConnection;25;0;13;5
WireConnection;25;1;15;5
WireConnection;25;2;24;0
WireConnection;55;0;56;5
WireConnection;55;1;32;5
WireConnection;55;2;54;0
WireConnection;77;0;55;0
WireConnection;77;1;25;0
WireConnection;14;0;77;0
WireConnection;14;1;70;0
WireConnection;14;2;34;2
WireConnection;36;0;14;0
WireConnection;36;1;35;5
WireConnection;58;0;36;0
WireConnection;58;1;57;0
WireConnection;76;0;78;5
WireConnection;76;1;75;0
WireConnection;0;1;66;0
WireConnection;0;2;58;0
WireConnection;0;3;76;0
WireConnection;0;4;47;0
WireConnection;0;5;34;2
ASEEND*/
//CHKSM=37A5EA33192F1D2E3C07CB6A619367CDE09B71E0