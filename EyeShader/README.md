# Eye Shader

The 3 main features can be seen below

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/ltcgi.gif)

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/al.gif)

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/video.gif)

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/retro.png)

## Installation

- Install LTCGI from here https://github.com/PiMaker/ltcgi or via VCC https://vpm.pimaker.at, this package was tested with LTCGI 1.4.1. This step is required if you decide to only download the `EyeShader.shader` file. If you download the .unitypackage file from the release page (https://github.com/MyroG/MyroP-shader-dump/releases), then this step is not required.
- Install AudioLink via the VCC package manager
- It should be enough to download the `EyeShader.shader` file, but if you're planning to edit the shader later with the Amplify shader editor, you also need to download the `ASEFunctions` folder at the root of this repository.

## Settings

### General settings
- MainTex : Your main eye texture, use whatever texture you want.
- Normal : Normal map
- Specular, smoothness and emission

### "Rave" settings
Those settings will mostly work in AudioLinked worlds :
- Rave mode : 0 will turn all "Rave"-related settings Off.
- LTCGI : If you feel like you don't need it, you can turn it off. Turning if off improves a bit the performance.
- Effect Mask : Determines how the effect should be shown on the eyes, personally I used a mask with very strong red, green and blue colors, something like this :

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/maskExample.png)

- FlowMap : Your flow map, see the "Flow map" section to see how to create your own flow map.
- AudioLink intensity : The intensity of the AudioLink effect, 0 disables that effect.
- Video Lerp : intensity of the video texture applied to the eyes. A value of 0 implies no video texture visible, while a value of 1 indicates the full visibility of the video texture. If this feature is not supported by specific video players, setting the value to 1 will disable any effects.

Lastly, there are two settings to customize the flow speed and strength : Flow Speed and Flow strength.

### "Retroreflection" settings
To test that feature, I would recommend placing a light source in your scene, and place it close to your avatar's eyes.
Here are the settings :
- The Retroreflection toggles turns in on or off
- "Retroreflection Eye zones" : A mask containing information about how the retroreflection should be shown :
    - Red channel: This should cover the entire pupil and defines where the effect needs to be rendered.
    - Green and Blue Channels: These channels define the appearance of the retroreflection effect. The area they cover should be larger than the pupil and aligned with its position. You can also color the entire mask in cyan (#00FFFF).
    
Here's an example of a mask, but you'll need to create your own since you're likely using a different avatar than mine. For the green and blue layers, I chose a gradient, but you can draw anything you like with those two colors, perhaps something resembling a retina, for instance.

<img src="https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/MaskExample2.png" width=25% >

- "Retroreflection Color 1/2" : Color of the retroreflection, "Color 1" affects the green channel of the mask, "Color 2" affects the blue channel of the mask
- "Retroreflection depth" : How deep the retroreflection should be shown in the eyes"
- "Retroreflection size" : The size of the retroreflection, keep that value pretty low if you avatar has very small pupils.
- "Retroreflection minimum light intensity" : Basically a light intensity threshold, if you only want the effect to be visible if a very bright light shines into your avatar's eyes, increase that value to something like 1 or more.


## Flow map

You can create your own flow map in your favourite image editing software, like Photoshop or GIMP, if you don't have a flow map, or don't want to generate one, make sure to set the "Flow strength" or "Flow Speed" setting to 0.

- Open your eye texture using your preferred image editing software.
- Create a new layer and import the 'flowMapTemplate.png' onto this layer.
- Resize the flow map template to match the dimensions of your eye texture, ensuring it is slightly smaller than the eye texture itself.
- Create a hole in the center of the flow map template for the pupil. Ensure the hole is slightly larger than the size of your pupils.
- Adjust the background color of the eye texture to a 50% blend of red and green (#808000 in hexadecimal format). Ensure that the texture background is not transparent.
- Blur a little bit the edges, applying a gausian blur effect should be good enough.
- After importing your flow map texture into Unity, deselect the "sRGB" option in the import settings.

Here's an example of a flow map I created for one of my avatars:

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/flowExample.png)

## Testing

The video effect only works with ProTV 3.0, here are a few worlds you can check out to test the shader on your avatar :
- Stabby Cinema : https://vrchat.com/home/world/wrld_cc341f9d-9363-49c5-b7e6-262c1d0d8f45
- LTCGI Avatar testing : https://vrchat.com/home/world/wrld_f25c3ba1-6c18-4e81-9617-6239e3dd11a1

