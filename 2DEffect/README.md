# Standard 2D Effect shader

A shader that can flatten your avatar, to make it nearly two dimensional. The effect is more noticeable in VR.

## Installation

It should be enough to download the "Standard 2DEffect.shader" or the  the "Standard 2DEffect Transparent.shader" file.

## Demo      

In the first part, the avatar is 3D.
After adjusting the 'thickness' property, the avatar transitions to a 2D appearance.

https://github.com/user-attachments/assets/8f2beb25-2703-4837-be54-da3e46424c67

## Documentation

The shader has similar functionalities to the standard Unity shader.
An example material is included in the "Example" folder.

![Doc](https://github.com/MyroG/MyroP-shader-dump/blob/master/2DEffect/Doc/Settings.png)

## Applying the effect on other shaders (Amplify Shader Editor)

If you want to create your own 2D shader with Amplify, just plug the "M Flatten" function into the "local vertex position" node. make sure "vertex output" is set to "absolute" in the shader settings.
You can find that function in the "ASEFunctions" folder, located at the root of this repository.

![Amplify](https://github.com/MyroG/MyroP-shader-dump/blob/master/2DEffect/Doc/Amplify.webp)


