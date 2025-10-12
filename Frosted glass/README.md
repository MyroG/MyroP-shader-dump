# Simple frosted glass shader

A simple frosted glass shader for the Built-in render pipeline, entirely made with the Amplify Shader Editor, the interesting feature about this shader is that it uses the scene's environment reflection to fake transparency : The shader is fully opaque and doesn't use a grab pass for the blur effect. The example folder contains a scene with a bunch of example materials.
The shader works on VRChat and can be used on PC avatars also.

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/Frosted%20glass/Examples/example.gif)

## Installation
You only need to download the shader file ```FrostedGlass.shader```, but I would also recommend downloading the example folder so you can see some material examples.

## Settings

- **Main texture** : The color of the glass. If no texture is set, the color defaults to white.
You can also use that texture to make certain parts of the mesh darker or less transparent, but if you want to have an even color throughout the mesh, you can just play around with the ```Color inner``` and ```Color outer``` settings

- **Main texture intensity** : Basically how much of the ```Main texture``` you want, so 0 removes the main texture

- **Color inner/outer** : The overall color tint of the glass, "outer" represents the outer edge of the mesh, which can be customized using the ```fresnel``` settings.
Those properties support HDR values, but for regular glass you want to keep the HDR intensity to 0, you can increase that value to simulate light shining through the mesh.

- **Emission** : additional Emission texture you can set on the mesh

- **Overall intensity** : Emission intensity multiplier

- **Specular intensity** : How much the glass should reflect light, for fully transparent glass you want that value close to 0

- **Smoothness** : The overall surface smoothness, for smooth glass you can set it to 0.9~1, for frosted glass you can lower that value.

- **Normal** : Normal map, tiling and offset can be set next to the texture

- **Occlusion** : AO, only the green channel (G) is used, defaults to 1

- **Blur** : How much you want the glass to blur the environment

- **Blur mask** : An additional mask texture you can set to make certain parts of the mesh blurier than other, uses only the blue channel (B), 0 means no blur, defaults to 1. The final blur level is basically ```Blur * Blur mask```

- **Refraction** : How much you want the glass to refract the environment, 1 means no refraction

- **Refraction mask** : An additional mask texture you can set to make certain parts of the mesh refract more of the environment than others, uses only the red channel (R), 0 means full refraction, defaults to 1. The final refraction level is basically ```Refraction * Refraction mask```

- **Fresnel** : Those settings allow you to customise the fresnel effect (or "rim light" if you prefer), it can be useful to add a glow effect, or to make the outer edge more transparent

- **Fallback cubemap** : The shader relies on the environemnt reflection (reflection probe) to work properly. If there's none, you can set your own cubemap in that field, accepts only textures imported as "Cube"

- **Force fallback** : If that value is set to 0, the shader will use the scene's reflection, and the fallback cubemap if there's no scene reflection.
If that value is set to 1, then the shader will only use the fallback cubemap.
If you're using that shader for a VRChat avatar, you could animate that property and use the fallback cubemap if the world reflections aren't good enough.

## License and credits

The shader was made by MyroP, the full license can be found in the LICENSE.txt file, in the same folder as the "Frosted glass" folder.
But TL;DR : The shader is MIT licensed, the textures in the example folder CC0 (they were downloaded from AmbientCG)

