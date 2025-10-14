// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/FrostedGlass LTCGI"
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
		_Fallbackcubemap("Fallback cubemap", CUBE) = "white" {}
		_Forcefallback("Force fallback", Range( 0 , 1)) = 0
		[Toggle(_CHROMATICABERRATION_ON)] _Chromaticaberration("Chromatic aberration", Float) = 0
		_Chromaticaberrationdispersion("Chromatic aberration dispersion", Range( 0 , 1)) = 0.005
		[Toggle(_LTCGICHROMATICABERRATIONREADDOC_ON)] _LTCGIChromaticaberrationReaddoc("LTCGI Chromatic aberration (Read doc!)", Float) = 0
		[Toggle(_LTCGIONTHESURFACE_ON)] _LTCGIonthesurface("LTCGI on the surface", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_Culling("Culling", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  "LTCGI"="ALWAYS" }
		Cull [_Culling]
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardBRDF.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature_local _FRESNEL_ON
		#pragma shader_feature_local _CHROMATICABERRATION_ON
		#pragma shader_feature_local _LTCGIONTHESURFACE_ON
		#pragma shader_feature_local _LTCGICHROMATICABERRATIONREADDOC_ON
		#define ASE_VERSION 19801
		#include "UnityCG.cginc"
		#include "Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc"
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
		uniform float _Forcefallback;
		uniform float _Chromaticaberrationdispersion;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _Overallintensity;
		uniform float _Smoothness;
		uniform float _Specularintensity;


		float3 Reflectionprobesampler2_g157( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
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


		float3 Reflectionprobesampler2_g152( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
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


		float3 Reflectionprobesampler2_g153( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
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


		float3 Reflectionprobesampler2_g154( float3 viewDir, float3 normal, float IOR, float Blur, samplerCUBE fallbackCube, float forceFallback, float3 fragmentWorldPosition )
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
			float3 Diffuse162 = ( lerpResult55 * lerpResult25 );
			float3 viewDir2_g157 = ase_viewDirWS;
			float3 newWorldNormal31 = (WorldNormalVector( i , NormalFinal65 ));
			float3 switchResult59 = (((i.ASEIsFrontFacing>0)?(newWorldNormal31):(-newWorldNormal31)));
			float3 NormalFinalByFace114 = switchResult59;
			float3 normal2_g157 = NormalFinalByFace114;
			float2 uv_RefractionMask = i.uv_texcoord * _RefractionMask_ST.xy + _RefractionMask_ST.zw;
			float Refraction117 = ( _Refraction * tex2D( _RefractionMask, uv_RefractionMask ).r );
			float IOR2_g157 = Refraction117;
			float2 uv_BlurMask = i.uv_texcoord * _BlurMask_ST.xy + _BlurMask_ST.zw;
			float blur110 = ( _Blur * tex2D( _BlurMask, uv_BlurMask ).b );
			float Blur2_g157 = blur110;
			samplerCUBE fallbackCube2_g157 = _Fallbackcubemap;
			float forceFallback2_g157 = _Forcefallback;
			float3 fragmentWorldPosition2_g157 = ase_positionWS;
			float3 localReflectionprobesampler2_g157 = Reflectionprobesampler2_g157( viewDir2_g157 , normal2_g157 , IOR2_g157 , Blur2_g157 , fallbackCube2_g157 , forceFallback2_g157 , fragmentWorldPosition2_g157 );
			float3 viewDir2_g152 = ase_viewDirWS;
			float3 normal2_g152 = NormalFinalByFace114;
			float lerpResult134 = lerp( 0.0 , ( 1.0 - Refraction117 ) , _Chromaticaberrationdispersion);
			float Refraction_Red327 = ( Refraction117 + lerpResult134 );
			float IOR2_g152 = Refraction_Red327;
			float Blur2_g152 = blur110;
			samplerCUBE fallbackCube2_g152 = _Fallbackcubemap;
			float forceFallback2_g152 = _Forcefallback;
			float3 fragmentWorldPosition2_g152 = ase_positionWS;
			float3 localReflectionprobesampler2_g152 = Reflectionprobesampler2_g152( viewDir2_g152 , normal2_g152 , IOR2_g152 , Blur2_g152 , fallbackCube2_g152 , forceFallback2_g152 , fragmentWorldPosition2_g152 );
			float3 viewDir2_g153 = ase_viewDirWS;
			float3 normal2_g153 = NormalFinalByFace114;
			float IOR2_g153 = Refraction117;
			float Blur2_g153 = blur110;
			samplerCUBE fallbackCube2_g153 = _Fallbackcubemap;
			float forceFallback2_g153 = _Forcefallback;
			float3 fragmentWorldPosition2_g153 = ase_positionWS;
			float3 localReflectionprobesampler2_g153 = Reflectionprobesampler2_g153( viewDir2_g153 , normal2_g153 , IOR2_g153 , Blur2_g153 , fallbackCube2_g153 , forceFallback2_g153 , fragmentWorldPosition2_g153 );
			float3 viewDir2_g154 = ase_viewDirWS;
			float3 normal2_g154 = NormalFinalByFace114;
			float Refraction_Blue328 = ( Refraction117 - lerpResult134 );
			float IOR2_g154 = Refraction_Blue328;
			float Blur2_g154 = blur110;
			samplerCUBE fallbackCube2_g154 = _Fallbackcubemap;
			float forceFallback2_g154 = _Forcefallback;
			float3 fragmentWorldPosition2_g154 = ase_positionWS;
			float3 localReflectionprobesampler2_g154 = Reflectionprobesampler2_g154( viewDir2_g154 , normal2_g154 , IOR2_g154 , Blur2_g154 , fallbackCube2_g154 , forceFallback2_g154 , fragmentWorldPosition2_g154 );
			float3 appendResult133 = (float3(localReflectionprobesampler2_g152.x , localReflectionprobesampler2_g153.y , localReflectionprobesampler2_g154.z));
			#ifdef _CHROMATICABERRATION_ON
				float3 staticSwitch101 = appendResult133;
			#else
				float3 staticSwitch101 = localReflectionprobesampler2_g157;
			#endif
			float3 FakeTransparency67 = staticSwitch101;
			float2 uv_Occlusion = i.uv_texcoord * _Occlusion_ST.xy + _Occlusion_ST.zw;
			float4 tex2DNode34 = tex2D( _Occlusion, uv_Occlusion );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float localLTCGI15_g155 = ( 0.0 );
			float3 worldPos15_g155 = ase_positionWS;
			float3 newWorldNormal7_g155 = (WorldNormalVector( i , NormalFinal65 ));
			float3 switchResult24_g155 = (((i.ASEIsFrontFacing>0)?(newWorldNormal7_g155):(-newWorldNormal7_g155)));
			float3 normalizeResult9_g155 = normalize( switchResult24_g155 );
			float3 worldNorm15_g155 = normalizeResult9_g155;
			float3 normalizeResult12_g155 = normalize( ( _WorldSpaceCameraPos - ase_positionWS ) );
			float3 cameraDir15_g155 = normalizeResult12_g155;
			float roughness15_g155 = ( 1.0 - _Smoothness );
			float2 lightmapUV15_g155 = i.uv2_texcoord2;
			float3 diffuse15_g155 = float3( 0,0,0 );
			float3 specular15_g155 = float3( 0,0,0 );
			float specularIntensity15_g155 = 0;
			{
			LTCGI_Contribution(worldPos15_g155, worldNorm15_g155, cameraDir15_g155, roughness15_g155, lightmapUV15_g155, diffuse15_g155, specular15_g155, specularIntensity15_g155);
			}
			float Specular_intensity_param156 = _Specularintensity;
			#ifdef _LTCGIONTHESURFACE_ON
				float3 staticSwitch357 = ( ( ( specular15_g155 * specularIntensity15_g155 ) + ( diffuse15_g155 * Diffuse162 ) ) * Specular_intensity_param156 );
			#else
				float3 staticSwitch357 = float3( 0,0,0 );
			#endif
			float localLTCGI15_g156 = ( 0.0 );
			float3 worldPos15_g156 = ase_positionWS;
			float3 normalizeResult9_g156 = normalize( (WorldNormalVector( i , NormalFinal65 )) );
			float3 switchResult24_g156 = (((i.ASEIsFrontFacing>0)?(normalizeResult9_g156):(-normalizeResult9_g156)));
			float3 world_normal48_g156 = switchResult24_g156;
			float3 worldNorm15_g156 = -world_normal48_g156;
			float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
			float3 cameraDir15_g156 = -refract( -ase_viewDirSafeWS , -world_normal48_g156 , Refraction117 );
			float roughness15_g156 = blur110;
			float2 lightmapUV15_g156 = i.uv2_texcoord2;
			float3 diffuse15_g156 = float3( 0,0,0 );
			float3 specular15_g156 = float3( 0,0,0 );
			float specularIntensity15_g156 = 0;
			{
			LTCGI_Contribution(worldPos15_g156, worldNorm15_g156, cameraDir15_g156, roughness15_g156, lightmapUV15_g156, diffuse15_g156, specular15_g156, specularIntensity15_g156);
			}
			float localLTCGI15_g151 = ( 0.0 );
			float3 worldPos15_g151 = ase_positionWS;
			float3 normalizeResult9_g151 = normalize( (WorldNormalVector( i , NormalFinal65 )) );
			float3 switchResult24_g151 = (((i.ASEIsFrontFacing>0)?(normalizeResult9_g151):(-normalizeResult9_g151)));
			float3 world_normal48_g151 = switchResult24_g151;
			float3 worldNorm15_g151 = -world_normal48_g151;
			float3 cameraDir15_g151 = -refract( -ase_viewDirSafeWS , -world_normal48_g151 , Refraction_Red327 );
			float roughness15_g151 = blur110;
			float2 lightmapUV15_g151 = i.uv2_texcoord2;
			float3 diffuse15_g151 = float3( 0,0,0 );
			float3 specular15_g151 = float3( 0,0,0 );
			float specularIntensity15_g151 = 0;
			{
			LTCGI_Contribution(worldPos15_g151, worldNorm15_g151, cameraDir15_g151, roughness15_g151, lightmapUV15_g151, diffuse15_g151, specular15_g151, specularIntensity15_g151);
			}
			float localLTCGI15_g149 = ( 0.0 );
			float3 worldPos15_g149 = ase_positionWS;
			float3 normalizeResult9_g149 = normalize( (WorldNormalVector( i , NormalFinal65 )) );
			float3 switchResult24_g149 = (((i.ASEIsFrontFacing>0)?(normalizeResult9_g149):(-normalizeResult9_g149)));
			float3 world_normal48_g149 = switchResult24_g149;
			float3 worldNorm15_g149 = -world_normal48_g149;
			float3 cameraDir15_g149 = -refract( -ase_viewDirSafeWS , -world_normal48_g149 , Refraction117 );
			float roughness15_g149 = blur110;
			float2 lightmapUV15_g149 = i.uv2_texcoord2;
			float3 diffuse15_g149 = float3( 0,0,0 );
			float3 specular15_g149 = float3( 0,0,0 );
			float specularIntensity15_g149 = 0;
			{
			LTCGI_Contribution(worldPos15_g149, worldNorm15_g149, cameraDir15_g149, roughness15_g149, lightmapUV15_g149, diffuse15_g149, specular15_g149, specularIntensity15_g149);
			}
			float localLTCGI15_g150 = ( 0.0 );
			float3 worldPos15_g150 = ase_positionWS;
			float3 normalizeResult9_g150 = normalize( (WorldNormalVector( i , NormalFinal65 )) );
			float3 switchResult24_g150 = (((i.ASEIsFrontFacing>0)?(normalizeResult9_g150):(-normalizeResult9_g150)));
			float3 world_normal48_g150 = switchResult24_g150;
			float3 worldNorm15_g150 = -world_normal48_g150;
			float3 cameraDir15_g150 = -refract( -ase_viewDirSafeWS , -world_normal48_g150 , Refraction_Blue328 );
			float roughness15_g150 = blur110;
			float2 lightmapUV15_g150 = i.uv2_texcoord2;
			float3 diffuse15_g150 = float3( 0,0,0 );
			float3 specular15_g150 = float3( 0,0,0 );
			float specularIntensity15_g150 = 0;
			{
			LTCGI_Contribution(worldPos15_g150, worldNorm15_g150, cameraDir15_g150, roughness15_g150, lightmapUV15_g150, diffuse15_g150, specular15_g150, specularIntensity15_g150);
			}
			float3 appendResult353 = (float3(( ( specular15_g151 * specularIntensity15_g151 ) + ( diffuse15_g151 * Diffuse162 ) ).x , ( ( specular15_g149 * specularIntensity15_g149 ) + ( diffuse15_g149 * Diffuse162 ) ).y , ( ( specular15_g150 * specularIntensity15_g150 ) + ( diffuse15_g150 * Diffuse162 ) ).z));
			#ifdef _LTCGICHROMATICABERRATIONREADDOC_ON
				float3 staticSwitch326 = appendResult353;
			#else
				float3 staticSwitch326 = ( ( specular15_g156 * specularIntensity15_g156 ) + ( diffuse15_g156 * Diffuse162 ) );
			#endif
			float3 LTCGI_contribution165 = ( staticSwitch357 + staticSwitch326 );
			o.Emission = ( ( ( ( Diffuse162 * FakeTransparency67 * tex2DNode34.g ) + tex2D( _Emission, uv_Emission ).rgb ) * _Overallintensity ) + LTCGI_contribution165 );
			float4 color78 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			o.Specular = ( color78.rgb * Specular_intensity_param156 );
			float temp_output_47_0 = _Smoothness;
			o.Smoothness = temp_output_47_0;
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
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.CommentaryNode;49;-832,1152;Inherit;False;1813.55;538.1277;Comment;11;21;20;19;22;23;18;63;62;61;80;81;Rim light effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;71;-3280,-1072;Inherit;False;1899.6;742.8;Normal map;14;85;41;29;65;84;87;89;90;91;92;93;94;95;96;Normal map;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;61;-800,1216;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;89;-2928,-768;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;90;-2928,-416;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;95;-2976,-544;Inherit;False;Property;_Normal2Panningspeed;Normal 2 Panning speed;13;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;85;-2976,-896;Inherit;False;Property;_Normal1Panningspeed;Normal 1 Panning speed;10;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-2960,-1024;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-2960,-672;Inherit;False;0;93;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;140;-4528,-1120;Inherit;False;836;363;Comment;4;39;8;40;117;Calculated refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;62;-592,1312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;84;-2688,-992;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2704,-800;Inherit;False;Property;_Normal1Intensity;Normal 1 Intensity;9;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;92;-2688,-640;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2704,-448;Inherit;False;Property;_Normal2Intensity;Normal 2 Intensity;12;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-4464,-992;Inherit;True;Property;_RefractionMask;Refraction Mask;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;8;-4464,-1072;Inherit;False;Property;_Refraction;Refraction;18;0;Create;True;0;0;0;False;0;False;0.792;0.934;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;63;-416,1232;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-608,1424;Inherit;False;Property;_TransparencyFresnelBias;Transparency Fresnel Bias;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-608,1504;Inherit;False;Property;_TransparencyFresnelScale;Transparency Fresnel Scale;21;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-608,1584;Inherit;False;Property;_TransparencyFresnelPower;Transparency Fresnel Power;22;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-2416,-1008;Inherit;True;Property;_Normal1;Normal 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;93;-2400,-672;Inherit;True;Property;_Normal2;Normal 2;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-4144,-1072;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;18;-192,1232;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;96;-2064,-800;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;139;-4976,1168;Inherit;False;1027.412;686.9303;Comment;7;134;123;135;136;311;312;313;Chromatic aberration : 3 different IOR per color channel;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-3920,-1072;Inherit;False;Refraction;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;81;112,1472;Inherit;False;Constant;_Black;Black;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode;23;144,1232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;141;-4528,-608;Inherit;False;1124;235;Comment;5;68;31;60;59;114;Normal per face;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1760,-800;Inherit;False;NormalFinal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;80;432,1536;Inherit;False;Property;_Fresnel;Fresnel;19;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-4880,1424;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-4480,-560;Inherit;False;65;NormalFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;111;-4544,-240;Inherit;False;817.8008;369.3071;Comment;4;109;108;107;110;Blur;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;313;-4448,1600;Inherit;False;468;227;Comment;2;138;128;;0,0.1308031,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;311;-4416,1200;Inherit;False;436;187;Comment;2;137;120;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1170,-1170;Inherit;False;1091.322;1050;Glass Color;10;162;77;55;25;56;13;24;54;32;15;Glass Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;688,1536;Inherit;False;Transparency Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;135;-4656,1408;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-4928,1504;Inherit;False;Property;_Chromaticaberrationdispersion;Chromatic aberration dispersion;26;0;Create;True;0;0;0;False;0;False;0.005;0.152;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;31;-4304,-560;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;107;-4496,-112;Inherit;True;Property;_BlurMask;Blur Mask;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;108;-4496,-192;Inherit;False;Property;_Blur;Blur;16;0;Create;True;0;0;0;False;0;False;0;0.146;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-1072,-400;Inherit;False;Property;_Colorouter;Color outer;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0.772549,0.9215686,1;0,0.772549,0.9215686,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;32;-1136,-912;Inherit;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;54;-1136,-704;Inherit;False;Property;_MainTextureintensity;Main Texture intensity;1;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1104,-192;Inherit;False;22;Transparency Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1072,-608;Inherit;False;Property;_Colorinner;Color inner;2;1;[HDR];Create;True;0;0;0;False;0;False;0.3254902,0.8862745,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;56;-1136,-1120;Inherit;False;Constant;_White;White;17;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;134;-4480,1456;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-4400,1712;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-4384,1248;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;60;-4096,-496;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;159;-928,-3776;Inherit;False;3084.559;2273.436;Comment;17;326;307;305;304;302;306;324;172;325;350;351;352;353;165;308;354;357;LTCGI contribution;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-4192,-192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;-752,-576;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;55;-752,-864;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;138;-4160,1648;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-4144,1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;59;-3936,-560;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;325;-864,-3696;Inherit;False;1358.632;447.0586;LTCGI on the surface;9;303;161;160;164;144;168;163;150;146;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-3968,-192;Inherit;False;blur;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-512,-352;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;327;-3920,1248;Inherit;False;Refraction Red;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;328;-3936,1664;Inherit;False;Refraction Blue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;356;-722,-1954;Inherit;False;1204;371;Comment;7;343;344;346;345;348;347;349;;0,0.09281969,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;355;-706,-2370;Inherit;False;1204;371;Comment;7;339;340;341;342;338;337;336;;0,1,0.1621556,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;354;-688,-2752;Inherit;False;1220;371;Comment;7;329;330;331;334;333;335;332;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;312;-4240,1408;Inherit;False;260;163;Comment;1;124;;0,1,0.1821365,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;100;-3744,352;Inherit;False;2019.247;1482.744;Comment;17;67;101;133;118;112;115;103;104;102;116;113;83;38;321;320;319;318;Reflection probe sampling;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-3648,-560;Inherit;False;NormalFinalByFace;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-295.9373,-298.2432;Inherit;False;Diffuse;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-832,-3552;Inherit;False;65;NormalFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;329;-640,-2704;Inherit;False;327;Refraction Red;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-608,-2576;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;-624,-2192;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-656,-2320;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;343;-672,-1904;Inherit;False;328;Refraction Blue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;-640,-1776;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-4192,1456;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;38;-3488,1104;Inherit;True;Property;_Fallbackcubemap;Fallback cubemap;23;0;Create;True;0;0;0;False;0;False;None;None;False;white;LockedToCube;Cube;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;83;-3552,1024;Inherit;False;Property;_Forcefallback;Force fallback;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-3472,1376;Inherit;False;114;NormalFinalByFace;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-3456,1504;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1232,144;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;331;-64,-2496;Inherit;False;162;Diffuse;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;339;-272,-2320;Inherit;False;LTCGI_Contribution - Glass;-1;;149;3bb7178283646e54e91f477e354f2056;0;3;79;FLOAT;1;False;23;FLOAT3;0,0,0;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;-80,-2112;Inherit;False;162;Diffuse;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;346;-288,-1904;Inherit;False;LTCGI_Contribution - Glass;-1;;150;3bb7178283646e54e91f477e354f2056;0;3;79;FLOAT;1;False;23;FLOAT3;0,0,0;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;345;-96,-1696;Inherit;False;162;Diffuse;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;332;-256,-2704;Inherit;False;LTCGI_Contribution - Glass;-1;;151;3bb7178283646e54e91f477e354f2056;0;3;79;FLOAT;1;False;23;FLOAT3;0,0,0;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;318;-3024,1184;Inherit;False;M_Specular Reflection Sampler;-1;;152;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;319;-3024,1392;Inherit;False;M_Specular Reflection Sampler;-1;;153;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;320;-3024,1616;Inherit;False;M_Specular Reflection Sampler;-1;;154;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;150;-832,-3440;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-768,-3088;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;-736,-2960;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;176,-2576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;333;176,-2704;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;160,-2320;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;341;160,-2192;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;348;144,-1776;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;144,-1904;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-3264,688;Inherit;False;114;NormalFinalByFace;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-3232,752;Inherit;False;117;Refraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-3232,832;Inherit;False;110;blur;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;102;-2672,1232;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;103;-2688,1424;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;104;-2688,1616;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;75;-2880,-1520;Inherit;False;Property;_Specularintensity;Specular intensity;6;0;Create;True;0;0;0;False;0;False;0;0.011;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;-400,-3440;Inherit;False;162;Diffuse;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;168;-576,-3632;Inherit;False;LTCGI_Contribution - Normal Sampled;-1;;155;6af33a5923a09624383cef78df055efc;0;2;23;FLOAT3;0,0,0;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;-192,-2880;Inherit;False;162;Diffuse;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;302;-384,-3088;Inherit;False;LTCGI_Contribution - Glass;-1;;156;3bb7178283646e54e91f477e354f2056;0;3;79;FLOAT;1;False;23;FLOAT3;0,0,0;False;21;FLOAT;0;False;3;FLOAT3;16;FLOAT;17;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;335;384,-2640;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;342;352,-2256;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;349;336,-1840;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;321;-2928,752;Inherit;False;M_Specular Reflection Sampler;-1;;157;68712ef340f514f40a0225ea01edfb74;0;5;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;1;False;7;SAMPLERCUBE;;False;8;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;133;-2512,1424;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-2576,-1504;Inherit;False;Specular intensity param;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-160,-3648;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-160,-3520;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;48,-3088;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;48,-2960;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;350;544,-2432;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;351;528,-2240;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;352;528,-2048;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StaticSwitch;101;-2400,1008;Inherit;False;Property;_Chromaticaberration;Chromatic aberration;25;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-64,-3440;Inherit;False;156;Specular intensity param;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;161;64,-3584;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;307;240,-3024;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;353;704,-2240;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-2048,1008;Inherit;False;FakeTransparency;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;272,-3520;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-304,80;Inherit;False;67;FakeTransparency;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;34;-416,432;Inherit;True;Property;_Occlusion;Occlusion;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StaticSwitch;326;816,-2768;Inherit;False;Property;_LTCGIChromaticaberrationReaddoc;LTCGI Chromatic aberration (Read doc!);27;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;357;688,-3504;Inherit;False;Property;_LTCGIonthesurface;LTCGI on the surface;28;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;308;1408,-3168;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;35;-416,224;Inherit;True;Property;_Emission;Emission;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-32,-48;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;1600,-3168;Inherit;False;LTCGI contribution;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;256,-48;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;57;96,192;Inherit;False;Property;_Overallintensity;Overall intensity;5;0;Create;True;0;0;0;False;0;False;1;0.56;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;-4.201416,-459.9322;Inherit;False;Constant;_Color1;Color 1;19;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;400,0;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;216.4724,-205.0077;Inherit;False;156;Specular intensity param;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;432,208;Inherit;False;165;LTCGI contribution;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;496,-80;Inherit;False;65;NormalFinal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;480,-304;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;82;976,480;Inherit;False;Property;_Culling;Culling;29;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;166;688,80;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;976,16;Float;False;True;-1;4;AmplifyShaderEditor.MaterialInspector;0;0;StandardSpecular;MyroP/FrostedGlass LTCGI;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;1;LTCGI=ALWAYS;False;0;0;True;_Culling;-1;0;False;;2;Include;UnityCG.cginc;False;;Custom;False;0;0;;Include;Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;62;0;61;0
WireConnection;84;0;87;0
WireConnection;84;2;85;0
WireConnection;84;1;89;0
WireConnection;92;0;91;0
WireConnection;92;2;95;0
WireConnection;92;1;90;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;29;1;84;0
WireConnection;29;5;41;0
WireConnection;93;1;92;0
WireConnection;93;5;94;0
WireConnection;40;0;8;0
WireConnection;40;1;39;1
WireConnection;18;0;63;0
WireConnection;18;1;19;0
WireConnection;18;2;20;0
WireConnection;18;3;21;0
WireConnection;96;0;29;0
WireConnection;96;1;93;0
WireConnection;117;0;40;0
WireConnection;23;0;18;0
WireConnection;65;0;96;0
WireConnection;80;1;81;1
WireConnection;80;0;23;0
WireConnection;22;0;80;0
WireConnection;135;1;136;0
WireConnection;31;0;68;0
WireConnection;134;1;135;0
WireConnection;134;2;123;0
WireConnection;60;0;31;0
WireConnection;109;0;108;0
WireConnection;109;1;107;3
WireConnection;25;0;13;5
WireConnection;25;1;15;5
WireConnection;25;2;24;0
WireConnection;55;0;56;5
WireConnection;55;1;32;5
WireConnection;55;2;54;0
WireConnection;138;0;128;0
WireConnection;138;1;134;0
WireConnection;137;0;120;0
WireConnection;137;1;134;0
WireConnection;59;0;31;0
WireConnection;59;1;60;0
WireConnection;110;0;109;0
WireConnection;77;0;55;0
WireConnection;77;1;25;0
WireConnection;327;0;137;0
WireConnection;328;0;138;0
WireConnection;114;0;59;0
WireConnection;162;0;77;0
WireConnection;339;79;336;0
WireConnection;339;23;146;0
WireConnection;339;21;337;0
WireConnection;346;79;343;0
WireConnection;346;23;146;0
WireConnection;346;21;344;0
WireConnection;332;79;329;0
WireConnection;332;23;146;0
WireConnection;332;21;330;0
WireConnection;318;4;116;0
WireConnection;318;5;327;0
WireConnection;318;6;113;0
WireConnection;318;7;38;0
WireConnection;318;8;83;0
WireConnection;319;4;116;0
WireConnection;319;5;124;0
WireConnection;319;6;113;0
WireConnection;319;7;38;0
WireConnection;319;8;83;0
WireConnection;320;4;116;0
WireConnection;320;5;328;0
WireConnection;320;6;113;0
WireConnection;320;7;38;0
WireConnection;320;8;83;0
WireConnection;150;0;47;0
WireConnection;334;0;332;0
WireConnection;334;1;331;0
WireConnection;333;0;332;16
WireConnection;333;1;332;17
WireConnection;340;0;339;16
WireConnection;340;1;339;17
WireConnection;341;0;339;0
WireConnection;341;1;338;0
WireConnection;348;0;346;0
WireConnection;348;1;345;0
WireConnection;347;0;346;16
WireConnection;347;1;346;17
WireConnection;102;0;318;0
WireConnection;103;0;319;0
WireConnection;104;0;320;0
WireConnection;168;23;146;0
WireConnection;168;21;150;0
WireConnection;302;79;172;0
WireConnection;302;23;146;0
WireConnection;302;21;324;0
WireConnection;335;0;333;0
WireConnection;335;1;334;0
WireConnection;342;0;340;0
WireConnection;342;1;341;0
WireConnection;349;0;347;0
WireConnection;349;1;348;0
WireConnection;321;4;115;0
WireConnection;321;5;118;0
WireConnection;321;6;112;0
WireConnection;321;7;38;0
WireConnection;321;8;83;0
WireConnection;133;0;102;0
WireConnection;133;1;103;1
WireConnection;133;2;104;2
WireConnection;156;0;75;0
WireConnection;144;0;168;16
WireConnection;144;1;168;17
WireConnection;164;0;168;0
WireConnection;164;1;163;0
WireConnection;304;0;302;16
WireConnection;304;1;302;17
WireConnection;305;0;302;0
WireConnection;305;1;306;0
WireConnection;350;0;335;0
WireConnection;351;0;342;0
WireConnection;352;0;349;0
WireConnection;101;1;321;0
WireConnection;101;0;133;0
WireConnection;161;0;144;0
WireConnection;161;1;164;0
WireConnection;307;0;304;0
WireConnection;307;1;305;0
WireConnection;353;0;350;0
WireConnection;353;1;351;1
WireConnection;353;2;352;2
WireConnection;67;0;101;0
WireConnection;303;0;161;0
WireConnection;303;1;160;0
WireConnection;326;1;307;0
WireConnection;326;0;353;0
WireConnection;357;0;303;0
WireConnection;308;0;357;0
WireConnection;308;1;326;0
WireConnection;14;0;162;0
WireConnection;14;1;70;0
WireConnection;14;2;34;2
WireConnection;165;0;308;0
WireConnection;36;0;14;0
WireConnection;36;1;35;5
WireConnection;58;0;36;0
WireConnection;58;1;57;0
WireConnection;76;0;78;5
WireConnection;76;1;158;0
WireConnection;166;0;58;0
WireConnection;166;1;167;0
WireConnection;0;1;66;0
WireConnection;0;2;166;0
WireConnection;0;3;76;0
WireConnection;0;4;47;0
WireConnection;0;5;34;2
ASEEND*/
//CHKSM=A1E7CD1057A0A785064C2A318D883B12F9BAB07B