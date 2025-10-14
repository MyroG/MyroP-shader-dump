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
		_Normal1("Normal 1", 2D) = "bump" {}
		_Normal1Intensity("Normal 1 Intensity", Range( 0 , 5)) = 1
		_Normal1Panningspeed("Normal 1 Panning speed", Vector) = (0,0,0,0)
		_Normal2("Normal 2", 2D) = "bump" {}
		_Normal2Intensity("Normal 2 Intensity", Range( 0 , 5)) = 1
		_Normal2Panningspeed("Normal 2 Panning speed", Vector) = (0,0,0,0)
		_Occlusion("Occlusion", 2D) = "white" {}
		_BlurMask("Blur Mask", 2D) = "white" {}
		_Blur("Blur", Range( 0 , 1)) = 0
		_RefractionMask("Refraction Mask", 2D) = "white" {}
		_Refraction("Refraction", Range( 0 , 1)) = 0.792
		[Toggle(_FRESNEL_ON)] _Fresnel("Fresnel", Float) = 1
		_TransparencyFresnelBias("Transparency Fresnel Bias", Float) = 0
		_TransparencyFresnelScale("Transparency Fresnel Scale", Float) = 1
		_TransparencyFresnelPower("Transparency Fresnel Power", Float) = 2
		_Fallbackcubemap("Fallback cubemap", CUBE) = "black" {}
		_Forcefallback("Force fallback", Range( 0 , 1)) = 0
		[Toggle(_CHROMATICABERRATION_ON)] _Chromaticaberration("Chromatic aberration", Float) = 0
		_Chromaticaberrationdispersion("Chromatic aberration dispersion", Range( 0 , 1)) = 0.005
		[Enum(UnityEngine.Rendering.CullMode)]_Culling("Culling", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Culling]
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature_local _FRESNEL_ON
		#pragma shader_feature_local _CHROMATICABERRATION_ON
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
		uniform sampler2D _Normal1;
		uniform float2 _Normal1Panningspeed;
		uniform float4 _Normal1_ST;
		uniform float _Normal1Intensity;
		uniform sampler2D _Normal2;
		uniform float2 _Normal2Panningspeed;
		uniform float4 _Normal2_ST;
		uniform float _Normal2Intensity;
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
		uniform float _Chromaticaberrationdispersion;
		uniform float _Forcefallback;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _Overallintensity;
		uniform float _Specularintensity;
		uniform float _Smoothness;


		float3 Reflectionprobesampler2_g147( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
		{
			float3 dir = refract(-normalize(viewDir), normalize(normal), IOR);
			#ifdef UNITY_SPECCUBE_BOX_PROJECTION
			    dir = BoxProjectedCubemapDirection(
			        dir,
			         fragmentWorldPosition,
			        unity_SpecCube0_ProbePosition,
			        unity_SpecCube0_BoxMin,
			        unity_SpecCube0_BoxMax
			    );
			#endif
			float Mipmap = Blur * Blur * UNITY_SPECCUBE_LOD_STEPS; //Blur square since I'm simulating perpetual roughness
			float4 rawProbe = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, dir, Mipmap);
			bool noProbe = (dot(rawProbe.rgb, rawProbe.rgb) + rawProbe.a) < 0.01; //fallback probe, not box projected
			float3 fallback = texCUBElod(fallbackCube, float4(dir, Mipmap)).rgb;
			if (noProbe)
			{
			    return fallback;
			}
			else
			{
			    rawProbe.rgb = DecodeHDR(rawProbe, unity_SpecCube0_HDR);
			    return lerp(rawProbe.rgb, fallback, forceFallback);
			}
		}


		float3 Reflectionprobesampler2_g144( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
		{
			float3 dir = refract(-normalize(viewDir), normalize(normal), IOR);
			#ifdef UNITY_SPECCUBE_BOX_PROJECTION
			    dir = BoxProjectedCubemapDirection(
			        dir,
			         fragmentWorldPosition,
			        unity_SpecCube0_ProbePosition,
			        unity_SpecCube0_BoxMin,
			        unity_SpecCube0_BoxMax
			    );
			#endif
			float Mipmap = Blur * Blur * UNITY_SPECCUBE_LOD_STEPS; //Blur square since I'm simulating perpetual roughness
			float4 rawProbe = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, dir, Mipmap);
			bool noProbe = (dot(rawProbe.rgb, rawProbe.rgb) + rawProbe.a) < 0.01; //fallback probe, not box projected
			float3 fallback = texCUBElod(fallbackCube, float4(dir, Mipmap)).rgb;
			if (noProbe)
			{
			    return fallback;
			}
			else
			{
			    rawProbe.rgb = DecodeHDR(rawProbe, unity_SpecCube0_HDR);
			    return lerp(rawProbe.rgb, fallback, forceFallback);
			}
		}


		float3 Reflectionprobesampler2_g145( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
		{
			float3 dir = refract(-normalize(viewDir), normalize(normal), IOR);
			#ifdef UNITY_SPECCUBE_BOX_PROJECTION
			    dir = BoxProjectedCubemapDirection(
			        dir,
			         fragmentWorldPosition,
			        unity_SpecCube0_ProbePosition,
			        unity_SpecCube0_BoxMin,
			        unity_SpecCube0_BoxMax
			    );
			#endif
			float Mipmap = Blur * Blur * UNITY_SPECCUBE_LOD_STEPS; //Blur square since I'm simulating perpetual roughness
			float4 rawProbe = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, dir, Mipmap);
			bool noProbe = (dot(rawProbe.rgb, rawProbe.rgb) + rawProbe.a) < 0.01; //fallback probe, not box projected
			float3 fallback = texCUBElod(fallbackCube, float4(dir, Mipmap)).rgb;
			if (noProbe)
			{
			    return fallback;
			}
			else
			{
			    rawProbe.rgb = DecodeHDR(rawProbe, unity_SpecCube0_HDR);
			    return lerp(rawProbe.rgb, fallback, forceFallback);
			}
		}


		float3 Reflectionprobesampler2_g146( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
		{
			float3 dir = refract(-normalize(viewDir), normalize(normal), IOR);
			#ifdef UNITY_SPECCUBE_BOX_PROJECTION
			    dir = BoxProjectedCubemapDirection(
			        dir,
			         fragmentWorldPosition,
			        unity_SpecCube0_ProbePosition,
			        unity_SpecCube0_BoxMin,
			        unity_SpecCube0_BoxMax
			    );
			#endif
			float Mipmap = Blur * Blur * UNITY_SPECCUBE_LOD_STEPS; //Blur square since I'm simulating perpetual roughness
			float4 rawProbe = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, dir, Mipmap);
			bool noProbe = (dot(rawProbe.rgb, rawProbe.rgb) + rawProbe.a) < 0.01; //fallback probe, not box projected
			float3 fallback = texCUBElod(fallbackCube, float4(dir, Mipmap)).rgb;
			if (noProbe)
			{
			    return fallback;
			}
			else
			{
			    rawProbe.rgb = DecodeHDR(rawProbe, unity_SpecCube0_HDR);
			    return lerp(rawProbe.rgb, fallback, forceFallback);
			}
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal1 = i.uv_texcoord * _Normal1_ST.xy + _Normal1_ST.zw;
			float2 panner84 = ( _Time.y * _Normal1Panningspeed + uv_Normal1);
			float2 uv_Normal2 = i.uv_texcoord * _Normal2_ST.xy + _Normal2_ST.zw;
			float2 panner92 = ( _Time.y * _Normal2Panningspeed + uv_Normal2);
			float3 NormalFinal65 = BlendNormals( UnpackScaleNormal( tex2D( _Normal1, panner84 ), _Normal1Intensity ) , UnpackScaleNormal( tex2D( _Normal2, panner92 ), _Normal2Intensity ) );
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
			float3 viewDir2_g147 = ase_viewDirWS;
			float3 newWorldNormal31 = (WorldNormalVector( i , NormalFinal65 ));
			float3 switchResult59 = (((i.ASEIsFrontFacing>0)?(newWorldNormal31):(-newWorldNormal31)));
			float3 NormalFinalByFace114 = switchResult59;
			float3 normal2_g147 = NormalFinalByFace114;
			float2 uv_RefractionMask = i.uv_texcoord * _RefractionMask_ST.xy + _RefractionMask_ST.zw;
			float Refraction117 = ( _Refraction * tex2D( _RefractionMask, uv_RefractionMask ).r );
			float IOR2_g147 = Refraction117;
			float2 uv_BlurMask = i.uv_texcoord * _BlurMask_ST.xy + _BlurMask_ST.zw;
			float blur110 = ( _Blur * tex2D( _BlurMask, uv_BlurMask ).b );
			float Blur2_g147 = blur110;
			samplerCUBE fallbackCube2_g147 = _Fallbackcubemap;
			float forceFallback2_g147 = 0.0;
			float3 fragmentWorldPosition2_g147 = ase_positionWS;
			float3 localReflectionprobesampler2_g147 = Reflectionprobesampler2_g147( viewDir2_g147 , normal2_g147 , IOR2_g147 , Blur2_g147 , fallbackCube2_g147 , forceFallback2_g147 , fragmentWorldPosition2_g147 );
			float3 viewDir2_g144 = ase_viewDirWS;
			float3 normal2_g144 = NormalFinalByFace114;
			float lerpResult134 = lerp( 0.0 , ( 1.0 - Refraction117 ) , _Chromaticaberrationdispersion);
			float IOR2_g144 = ( Refraction117 + lerpResult134 );
			float Blur2_g144 = blur110;
			samplerCUBE fallbackCube2_g144 = _Fallbackcubemap;
			float forceFallback2_g144 = _Forcefallback;
			float3 fragmentWorldPosition2_g144 = ase_positionWS;
			float3 localReflectionprobesampler2_g144 = Reflectionprobesampler2_g144( viewDir2_g144 , normal2_g144 , IOR2_g144 , Blur2_g144 , fallbackCube2_g144 , forceFallback2_g144 , fragmentWorldPosition2_g144 );
			float3 viewDir2_g145 = ase_viewDirWS;
			float3 normal2_g145 = NormalFinalByFace114;
			float IOR2_g145 = Refraction117;
			float Blur2_g145 = blur110;
			samplerCUBE fallbackCube2_g145 = _Fallbackcubemap;
			float forceFallback2_g145 = _Forcefallback;
			float3 fragmentWorldPosition2_g145 = ase_positionWS;
			float3 localReflectionprobesampler2_g145 = Reflectionprobesampler2_g145( viewDir2_g145 , normal2_g145 , IOR2_g145 , Blur2_g145 , fallbackCube2_g145 , forceFallback2_g145 , fragmentWorldPosition2_g145 );
			float3 viewDir2_g146 = ase_viewDirWS;
			float3 normal2_g146 = NormalFinalByFace114;
			float IOR2_g146 = ( Refraction117 - lerpResult134 );
			float Blur2_g146 = blur110;
			samplerCUBE fallbackCube2_g146 = _Fallbackcubemap;
			float forceFallback2_g146 = _Forcefallback;
			float3 fragmentWorldPosition2_g146 = ase_positionWS;
			float3 localReflectionprobesampler2_g146 = Reflectionprobesampler2_g146( viewDir2_g146 , normal2_g146 , IOR2_g146 , Blur2_g146 , fallbackCube2_g146 , forceFallback2_g146 , fragmentWorldPosition2_g146 );
			float3 appendResult155 = (float3(localReflectionprobesampler2_g144.x , localReflectionprobesampler2_g145.y , localReflectionprobesampler2_g146.z));
			#ifdef _CHROMATICABERRATION_ON
				float3 staticSwitch101 = appendResult155;
			#else
				float3 staticSwitch101 = localReflectionprobesampler2_g147;
			#endif
			float3 FakeTransparency67 = staticSwitch101;
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
Node;AmplifyShaderEditor.CommentaryNode;71;-3280,-1072;Inherit;False;1899.6;742.8;Normal map;14;85;41;29;65;84;87;89;90;91;92;93;94;95;96;Normal map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;89;-2928,-768;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;90;-2928,-416;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;95;-2976,-544;Inherit;False;Property;_Normal2Panningspeed;Normal 2 Panning speed;13;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;85;-2976,-896;Inherit;False;Property;_Normal1Panningspeed;Normal 1 Panning speed;10;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-2960,-1024;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-2960,-672;Inherit;False;0;93;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;84;-2688,-992;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2704,-800;Inherit;False;Property;_Normal1Intensity;Normal 1 Intensity;9;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;92;-2688,-640;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2704,-448;Inherit;False;Property;_Normal2Intensity;Normal 2 Intensity;12;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-2416,-1008;Inherit;True;Property;_Normal1;Normal 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;93;-2400,-672;Inherit;True;Property;_Normal2;Normal 2;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;140;-4528,-1120;Inherit;False;836;363;Comment;4;39;8;40;117;Calculated refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendNormalsNode;96;-2064,-800;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;141;-4528,-608;Inherit;False;1124;235;Comment;5;68;31;60;59;114;Normal per face;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1760,-800;Inherit;False;NormalFinal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;39;-4464,-992;Inherit;True;Property;_RefractionMask;Refraction Mask;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;8;-4464,-1072;Inherit;False;Property;_Refraction;Refraction;18;0;Create;True;0;0;0;False;0;False;0.792;0.835;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;139;-5056,1104;Inherit;False;1172;643;Comment;8;120;128;134;137;138;124;123;143;Chromatic aberration : 3 different IOR per color channel;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-4144,-1072;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-4480,-560;Inherit;False;65;NormalFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;143;-5040,1248;Inherit;False;532;220;To get a value between 0 and 1-IOF;2;135;136;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;111;-4544,-240;Inherit;False;817.8008;369.3071;Comment;4;109;108;107;110;Blur;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;-832,1152;Inherit;False;1813.55;538.1277;Comment;11;21;20;19;22;23;18;63;62;61;80;81;Rim light effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-3920,-1072;Inherit;False;Refraction;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;31;-4304,-560;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;61;-800,1216;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;107;-4496,-112;Inherit;True;Property;_BlurMask;Blur Mask;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.NegateNode;60;-4096,-496;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-4976,1360;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-4496,-192;Inherit;False;Property;_Blur;Blur;16;0;Create;True;0;0;0;False;0;False;0;0.187;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;62;-592,1312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-4192,-192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;59;-3936,-560;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-4960,1552;Inherit;False;Property;_Chromaticaberrationdispersion;Chromatic aberration dispersion;26;0;Create;True;0;0;0;False;0;False;0.005;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;135;-4752,1344;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;100;-3744,352;Inherit;False;2019.247;1482.744;Comment;17;67;101;83;38;144;145;146;147;148;149;150;151;152;153;154;155;156;Reflection probe sampling;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwitchByFaceNode;63;-416,1232;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-608,1424;Inherit;False;Property;_TransparencyFresnelBias;Transparency Fresnel Bias;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-608,1504;Inherit;False;Property;_TransparencyFresnelScale;Transparency Fresnel Scale;21;0;Create;True;0;0;0;False;0;False;1;1.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-608,1584;Inherit;False;Property;_TransparencyFresnelPower;Transparency Fresnel Power;22;0;Create;True;0;0;0;False;0;False;2;2.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-4464,1152;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-4512,1632;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-3968,-192;Inherit;False;blur;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-3648,-560;Inherit;False;NormalFinalByFace;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;134;-4496,1392;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;18;-192,1232;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3632,1040;Inherit;False;Property;_Forcefallback;Force fallback;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-4224,1152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;138;-4272,1568;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-4288,1360;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;38;-3568,1120;Inherit;True;Property;_Fallbackcubemap;Fallback cubemap;23;0;Create;True;0;0;0;False;0;False;None;None;False;black;LockedToCube;Cube;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;151;-3504,1312;Inherit;False;114;NormalFinalByFace;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-3488,1440;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;81;112,1472;Inherit;False;Constant;_Black;Black;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode;23;144,1232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;144;-3056,1120;Inherit;False;M_Specular Reflection Sampler;-1;;144;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;145;-3056,1328;Inherit;False;M_Specular Reflection Sampler;-1;;145;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;146;-3056,1552;Inherit;False;M_Specular Reflection Sampler;-1;;146;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;80;432,1536;Inherit;False;Property;_Fresnel;Fresnel;19;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-3296,624;Inherit;False;114;NormalFinalByFace;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-3264,688;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-3264,768;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;153;-2704,1168;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;154;-2720,1360;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;156;-2720,1552;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;79;-1170,-1170;Inherit;False;915.3218;1054;Glass Color;9;77;25;55;15;13;54;24;56;32;Glass Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;688,1536;Inherit;False;Transparency Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;147;-2960,688;Inherit;False;M_Specular Reflection Sampler;-1;;147;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;155;-2544,1360;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;15;-1072,-400;Inherit;False;Property;_Colorouter;Color outer;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0.772549,0.9215686,1;0.7471075,0.9371457,0.9716981,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;32;-1136,-912;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;54;-1136,-704;Inherit;False;Property;_MainTextureintensity;Main Texture intensity;1;0;Create;True;0;0;0;False;0;False;1;0.205;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1104,-192;Inherit;False;22;Transparency Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1072,-608;Inherit;False;Property;_Colorinner;Color inner;2;1;[HDR];Create;True;0;0;0;False;0;False;0.3254902,0.8862745,1,1;0.5896226,0.7730856,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;56;-1136,-1120;Inherit;False;Constant;_White;White;17;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch;101;-2368,1008;Inherit;False;Property;_Chromaticaberration;Chromatic aberration;25;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;25;-752,-576;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;55;-752,-864;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-2048,1008;Inherit;False;FakeTransparency;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-304,80;Inherit;False;67;FakeTransparency;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;34;-416,432;Inherit;True;Property;_Occlusion;Occlusion;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-448,-304;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;35;-416,224;Inherit;True;Property;_Emission;Emission;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-32,-48;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;256,-48;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;96,192;Inherit;False;Property;_Overallintensity;Overall intensity;5;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-112,-256;Inherit;False;Property;_Specularintensity;Specular intensity;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-4.201416,-459.9322;Inherit;False;Constant;_Color1;Color 1;19;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;47;416,128;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;400,0;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;272,-336;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;82;368,592;Inherit;False;Property;_Culling;Culling;27;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;496,-80;Inherit;False;65;NormalFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;720,32;Float;False;True;-1;4;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;MyroP/FrostedGlass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Culling;-1;0;False;;1;Include;UnityCG.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;84;0;87;0
WireConnection;84;2;85;0
WireConnection;84;1;89;0
WireConnection;92;0;91;0
WireConnection;92;2;95;0
WireConnection;92;1;90;0
WireConnection;29;1;84;0
WireConnection;29;5;41;0
WireConnection;93;1;92;0
WireConnection;93;5;94;0
WireConnection;96;0;29;0
WireConnection;96;1;93;0
WireConnection;65;0;96;0
WireConnection;40;0;8;0
WireConnection;40;1;39;1
WireConnection;117;0;40;0
WireConnection;31;0;68;0
WireConnection;60;0;31;0
WireConnection;62;0;61;0
WireConnection;109;0;108;0
WireConnection;109;1;107;3
WireConnection;59;0;31;0
WireConnection;59;1;60;0
WireConnection;135;1;136;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;110;0;109;0
WireConnection;114;0;59;0
WireConnection;134;1;135;0
WireConnection;134;2;123;0
WireConnection;18;0;63;0
WireConnection;18;1;19;0
WireConnection;18;2;20;0
WireConnection;18;3;21;0
WireConnection;137;0;120;0
WireConnection;137;1;134;0
WireConnection;138;0;128;0
WireConnection;138;1;134;0
WireConnection;23;0;18;0
WireConnection;144;4;151;0
WireConnection;144;5;137;0
WireConnection;144;6;152;0
WireConnection;144;7;38;0
WireConnection;144;8;83;0
WireConnection;145;4;151;0
WireConnection;145;5;124;0
WireConnection;145;6;152;0
WireConnection;145;7;38;0
WireConnection;145;8;83;0
WireConnection;146;4;151;0
WireConnection;146;5;138;0
WireConnection;146;6;152;0
WireConnection;146;7;38;0
WireConnection;146;8;83;0
WireConnection;80;1;81;1
WireConnection;80;0;23;0
WireConnection;153;0;144;0
WireConnection;154;0;145;0
WireConnection;156;0;146;0
WireConnection;22;0;80;0
WireConnection;147;4;148;0
WireConnection;147;5;149;0
WireConnection;147;6;150;0
WireConnection;147;7;38;0
WireConnection;155;0;153;0
WireConnection;155;1;154;1
WireConnection;155;2;156;2
WireConnection;101;1;147;0
WireConnection;101;0;155;0
WireConnection;25;0;13;5
WireConnection;25;1;15;5
WireConnection;25;2;24;0
WireConnection;55;0;56;5
WireConnection;55;1;32;5
WireConnection;55;2;54;0
WireConnection;67;0;101;0
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
//CHKSM=0404F5A219B469DDAC6B422E5B76EBD026C0A40A