// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyroP/Standard 2DEffect Transparent"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		_MetallicSmoothness("MetallicSmoothness", 2D) = "black" {}
		_MetallicOffset("MetallicOffset", Range( -1 , 1)) = 0
		_SmoothnessOffset("SmoothnessOffset", Range( -1 , 1)) = 0
		_Normal("Normal", 2D) = "bump" {}
		_Occlusion("Occlusion", 2D) = "white" {}
		_Emission("Emission", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		[Toggle(_VERTEXDISPLACEMENT_ON)] _Vertexdisplacement("Vertex displacement", Float) = 1
		_thickness("thickness", Range( 0 , 2)) = 0.02
		_largeness("largeness", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _VERTEXDISPLACEMENT_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _thickness;
		uniform float _largeness;
		uniform float _VRChatMirrorMode;
		uniform float3 _VRChatMirrorCameraPos;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Color;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float4 _EmissionColor;
		uniform sampler2D _MetallicSmoothness;
		uniform float4 _MetallicSmoothness_ST;
		uniform float _MetallicOffset;
		uniform float _SmoothnessOffset;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;
		uniform float _Cutoff = 0.5;


		float4 Flatten4_g4( float4 localVertex, float thickness, float largeness, float VRChatMirrorMode, float3 VRChatMirrorCameraPos )
		{
			if (thickness == 1.0f && largeness == 1.0f)
				return localVertex;
			// Convert vertex to world space
			float4 vertexWS = mul(unity_ObjectToWorld, localVertex);
			// Get mesh origin in world space
			float4 meshOriginWS = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
			// Get camera position in world space
			#if defined(USING_STEREO_MATRICES)
				float3 cameraPositionWS = ( unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1] ) / 2;
			#else
				float3 cameraPositionWS = VRChatMirrorMode != 0 ? VRChatMirrorCameraPos : _WorldSpaceCameraPos.xyz;
			#endif
			// Now we'll snap the vertex on a flat vertical plane, we will work in a 2D space
			float2 vertex2DSpace = float2(vertexWS.x, vertexWS.z);
			float2 cameraPos2DSpace = float2(cameraPositionWS.x, cameraPositionWS.z);
			float2 meshOrigin2DSpace = float2(meshOriginWS.x, meshOriginWS.z);
			// Calculate the direction of the perpendicular plane (in 2D)
			float2 cameraToOrigin = cameraPos2DSpace - meshOrigin2DSpace;
			float2 perpendicular2DPlaneDirection = float2(cameraToOrigin.y, -cameraToOrigin.x); 
			perpendicular2DPlaneDirection = normalize(perpendicular2DPlaneDirection);
			// Calculate dot product between vertex and the perpendicular plane direction
			float2 vertexOffsetFromOrigin = vertex2DSpace - meshOrigin2DSpace;
			float dotProduct = dot(perpendicular2DPlaneDirection, vertexOffsetFromOrigin);
			// Project the vertex onto the plane by using the perpendicular direction
			float2 projectedVertex = meshOrigin2DSpace + perpendicular2DPlaneDirection * dotProduct;
			// Adjust the position based on thickness
			float2 finalPosition = lerp(projectedVertex, vertex2DSpace, thickness) + perpendicular2DPlaneDirection * dotProduct * (largeness - 1);
			// Update the original vertex's x and z values
			vertexWS.x = finalPosition.x;
			vertexWS.z = finalPosition.y;
			// Convert the vertex back to local space
			float4 localPos = mul(unity_WorldToObject, vertexWS);
			return localPos;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 ase_vertex4Pos = v.vertex;
			float4 localVertex4_g4 = ase_vertex4Pos;
			float thickness4_g4 = _thickness;
			float largeness4_g4 = _largeness;
			float VRChatMirrorMode4_g4 = _VRChatMirrorMode;
			float3 VRChatMirrorCameraPos4_g4 = _VRChatMirrorCameraPos;
			float4 localFlatten4_g4 = Flatten4_g4( localVertex4_g4 , thickness4_g4 , largeness4_g4 , VRChatMirrorMode4_g4 , VRChatMirrorCameraPos4_g4 );
			#ifdef _VERTEXDISPLACEMENT_ON
				float4 staticSwitch16 = localFlatten4_g4;
			#else
				float4 staticSwitch16 = float4( ase_vertex3Pos , 0.0 );
			#endif
			v.vertex.xyz = staticSwitch16.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_output_4_0 = ( tex2D( _Albedo, uv_Albedo ) * _Color );
			o.Albedo = temp_output_4_0.rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = ( tex2D( _Emission, uv_Emission ) * _EmissionColor ).rgb;
			float2 uv_MetallicSmoothness = i.uv_texcoord * _MetallicSmoothness_ST.xy + _MetallicSmoothness_ST.zw;
			float4 tex2DNode6 = tex2D( _MetallicSmoothness, uv_MetallicSmoothness );
			o.Metallic = ( tex2DNode6.r + _MetallicOffset );
			o.Smoothness = ( tex2DNode6.a + _SmoothnessOffset );
			float2 uv_Occlusion = i.uv_texcoord * _Occlusion_ST.xy + _Occlusion_ST.zw;
			o.Occlusion = tex2D( _Occlusion, uv_Occlusion ).g;
			o.Alpha = 1;
			clip( temp_output_4_0.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.ColorNode;3;-614.5,-28.5;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-682.5,-213.5;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;29.02069,809.4554;Inherit;False;Property;_largeness;largeness;12;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;32.02069,731.4554;Inherit;False;Property;_thickness;thickness;11;0;Create;False;0;0;0;False;0;False;0.02;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-341.0305,317.1123;Inherit;False;Property;_SmoothnessOffset;SmoothnessOffset;5;0;Create;True;0;0;0;False;0;False;0;0.92;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-376.0305,165.1123;Inherit;False;Property;_MetallicOffset;MetallicOffset;4;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-641.4849,777.2297;Inherit;True;Property;_Emission;Emission;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-641.5,180.5;Inherit;True;Property;_MetallicSmoothness;MetallicSmoothness;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-573.4849,962.2297;Inherit;False;Property;_EmissionColor;EmissionColor;9;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-323.5,-79.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;22;358.4639,572.5228;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;14;370.8121,758.5905;Inherit;False;M_Flatten;-1;;4;8b03c39c5cdf686428715f68329cecd1;0;2;7;FLOAT;0.1;False;9;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;8;-642.5,562.5;Inherit;True;Property;_Occlusion;Occlusion;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-286.4848,850.7297;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-69.03046,209.1123;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-104.0305,107.1123;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-640.5,368.5;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;23;-104.6448,-30.63513;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StaticSwitch;16;768.2103,643.7611;Inherit;False;Property;_Vertexdisplacement;Vertex displacement;10;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;232,-75;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyroP/Standard 2DEffect Transparent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;14;7;13;0
WireConnection;14;9;12;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;19;0;6;4
WireConnection;19;1;18;0
WireConnection;21;0;6;1
WireConnection;21;1;20;0
WireConnection;23;0;4;0
WireConnection;16;1;22;0
WireConnection;16;0;14;0
WireConnection;0;0;4;0
WireConnection;0;1;7;0
WireConnection;0;2;11;0
WireConnection;0;3;21;0
WireConnection;0;4;19;0
WireConnection;0;5;8;2
WireConnection;0;10;23;3
WireConnection;0;11;16;0
ASEEND*/
//CHKSM=EDF9E34F2B35462F54FBDCD51DB655682833349C