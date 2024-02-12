# Eye Shader

The 3 main features can be seen below

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/ltcgi.gif)

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/al.gif)

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/video.gif)

## Installation

- Install LTCGI https://github.com/PiMaker/ltcgi
- Install AudioLink via the VCC package manager
- It should be enough to download the `EyeShader.shader` file, but if you're planning to edit the shader later with the Amplify shader editor, you also need to download the `ASEFunctions` folder at the root of this repository.

## Settings

- MainTex : Your main eye texture, use whatever texture you want.
- FlowMap : Your flow map, see the "Flow map" section to see how to create your own flow map.
- AudioLink intensity : The intensity of the AudioLink effect, 0 disables that effect.
- Video Lerp : intensity of the video texture applied to the eyes. A value of 0 implies no video texture visible, while a value of 1 indicates the full visibility of the video texture. If this feature is not supported by specific video players, setting the value to 1 will disable any effects.
- Emissive Mask : determines how the effect should be shown on the eyes, personally I used a mask with very strong red, green and blue colors, something like this :

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/EyeShader/Doc/maskExample.png)

Lastly, there are two settings to customize the flow speed and strength : Flow Speed and Flow strength.

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

