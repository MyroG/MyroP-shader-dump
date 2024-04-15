# AudioLinked pattern

This is a shader I use for one of my avatar, here are the key features :

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/AudioLinkPattern/Doc/wing1.gif)

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/AudioLinkPattern/Doc/wing2.gif)

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/AudioLinkPattern/Doc/wing3.gif)

This shader is still work in progress, there are a few important features I still need to implement, but I don't have so much time working on shaders right now, so I decided to release it a bit earlier, feel free to edit the shader with the Amplify shader editor. Here are the features that still needs to be implemented :
- Adding an option to switch between "opaque" and "transparent"
- Adding a cull mode setting, to switch between "front", "back" or "off", currently the cull mode is set to "Off", which means that the material is shown on both sides of the mesh (inside and outside).
- Adding an option to toggle LTCGI, AudioLink, Rim lights etc.

## Installation 

- Install LTCGI https://github.com/PiMaker/ltcgi
- Install AudioLink with the VCC package manager
- It should be enough to download the folder, but if you're planning to edit the shader later with the Amplify shader editor, you also need to download the `ASEFunctions` folder at the root of this repository.

## Documentation

I'll explain each parameter below :

### Mask1 and Mask2

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/AudioLinkPattern/Doc/Mask.png)

### Tiling Mask1 and Mask2

This allows you to increase or decrease the size of the pattern

### Panner Mask1 and Mask2

Those parameters can be used to add a panning effect on the pattern

### "No AudioLink" parameters

A few parameters that will only affect the material when there's no AudioLink and no video player (Blue channel).
The color can be changed with the "HUE" setting, and the saturation with the "Saturation" setting.

### Opacity

You can make the material more or less transparent with that setting

### Trippyness

This effect only works when there's AudioLink or a compatible video player, so it only affects the green channel.
It works the best if the green channel is a smooth gradient, like the mask included in the example folder.

### "Video screen" parameters

Those parameters affect the video screen, this feature only works in worlds that support that feature:
- Animation speed : Animates the video player texture by rotating it.
- Lerp : 0 disables that feature, 1 enables it.

## Testing

The video effect only works with ProTV 3.0, here are a few worlds you can check out to test the shader on your avatar:
- Stabby Cinema : https://vrchat.com/home/world/wrld_cc341f9d-9363-49c5-b7e6-262c1d0d8f45
- LTCGI Avatar testing : https://vrchat.com/home/world/wrld_f25c3ba1-6c18-4e81-9617-6239e3dd11a1




