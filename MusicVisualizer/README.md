# MyroP's Music visualizer

A music visualizer you can put in your VRChat world or avatar. The logo can be replaced with whatever logo you want

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/MusicVisualizer/Doc/visualiser.gif)

## Installation
1) Install AudioLink via VCC
2) Download the whole "MusicVisualizer" folder, and import it into Unity
3) Put the "Example" prefab in your scene

## Settings

The shader has a lot of settings :
- **Logo**: The logo you want to use
- **Logo Size**: The size of the logo when no music is playing

### AudioLink Debug
You can test the effect in your scene when checking the "AudioLink debug" checkbox, <ins>make sure to uncheck it when testing in-game!</ins>
**Debug_X** allows you to debug the shader for each frequency range

### Low (Bass)

Bass adds a little zoom and shake effect
- **Low shake start**: When the shake effect should start, put it to 1 if you don't want that effect
- **Low shake intensity**: Shake intensity, put it to 0 if you don't want any shake effect
- **Low zoom intensity**: How much the logo should zoom when the bass hits

### LowMid

LowMid adds some chromatic aberration:
- **LowMid Chromatic Start**: When the chromatic aberration effect should start, put it to 1 if you don't want that effect
- **LowMid Chromatic Intensity**: Chromatic aberration intensity, put it to 0 if you don't want that effect

### High mid and High

Some additional shake effect
- **MidHigh Shake Intensity**: Intensity of the shake effect, or how much the logo moves
- **MidHigh Shake Speed**: Speed of the shake effect, or how fast the logo moves

### Audio Spectogram

Those settings affect the audio spectogram rendered behing the logo

- **Spectogram inner radius and color** : The color and the radius of the inner circle
- **Spectogram outer radius and color** : The color of the actual spectogram, the size can be customized with the "outer radius" setting
- **Spectogram origin** : Where the spectogram needs to be rendered

## Are you a shader creator?

- Use the "M_Music Visualizer" function to add that visualizer in your own shader!

![Showcase](https://github.com/MyroG/MyroP-shader-dump/blob/master/MusicVisualizer/Doc/funct.png)

## License

MIT