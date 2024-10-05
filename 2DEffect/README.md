# Standard 2D Effect shader

A shader that can flatten your avatar, to make it nearly two dimensional. The effect is more noticeable in VR.

## Installation

It should be enough to download the "Standard 2DEffect.shader" file.

## Demo

In the first part, the avatar is 3D.
After modifying the "thickness" property, we can see that the avatar turns 2D.

<video src='https://github.com/MyroG/MyroP-shader-dump/raw/refs/heads/master/2DEffect/Doc/demo.mp4' width=180/>

## Documentation

The shader has similar functionalities to the standard Unity shader.
An example material is included in the "Example" folder.

![Doc](https://github.com/MyroG/MyroP-shader-dump/blob/master/2DEffect/Doc/Settings.png)

## Applying the effect on other shaders (Amplify Shader Editor)

If you want to create your own 2D shader with Amplify, just plug the "M Flatten" function into the "local vertex position" node. make sure "vertex output" is set to "absolute" in the shader settings.
You can find that function in the "ASEFunctions" folder, located at the root of this repository.

![Amplify](https://github.com/MyroG/MyroP-shader-dump/blob/master/2DEffect/Doc/Amplify.webp)


