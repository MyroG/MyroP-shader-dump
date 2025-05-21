# Somna glass

A little transparent parralax shader you can apply on glass

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/SomnaGlass/Doc/example.png)


## Installation

- Install AudioLink via the VCC package manager
- It should be enough to download the `SomnaGlass.shader` file, but if you're planning to edit the shader later with the Amplify shader editor, you also need to download the `ASEFunctions` folder at the root of this repository.

## Settings

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/SomnaGlass/Doc/settings.png)

The shader has two parralax layers : Foreground and background.
Each layer can be customized with the "color", "scroll speed", "distance" and "animation speed" settings.

Glass color : Here you can change the glass color. To made the glass more or less transparent, you can play around with the alpha value
Somna Edge Fade : Makes the parralax effect more transparent around the edgeys
Somna Camera Distance fade : Makes the parralax effect dissapear when you're further away
Fresnel : It's a rim light effect
Lastly, there are also autioLink related settings.

For optimal result, do not compress the "Somna Mask" texture.
I would recommend playing around with each setting to see what each setting really does!

## License

The shader is licensed under the MIT license.
The "Somna_Pattern-6.png" texture is licensed under the Furality, Inc. Asset License Version 1.5, full license can be found in the LICENSE_FURALITY.txt file 