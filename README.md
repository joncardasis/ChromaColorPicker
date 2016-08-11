# JCColorPicker
![Supported Version](https://img.shields.io/badge/Swift-2.2-yellow.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-lightgray.svg)

An iOS color picker built in Swift

<img src="../assets/Screenshot.png?raw=true" width="350">

## Installation
### Cocoapods
```
pod 'JCColorPicker'
```
### Manually
Add all files from the JCColorPicker folder to your project.


## Examples
```Swift
let neatColorPicker = JCColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))


```

## Customization

<img src="../assets/Design_Breakdown.png?raw=true" width="350">
```
colorPicker.delegate = self
colorPicker.padding = 10
colorPicker.stroke = 3 //stroke of the rainbow circle
colorPicker.currentAngle = Float(M_PI)
colorPicker.hexLabel.textColor = UIColor.whiteColor()
```


### Supported UIControlEvents
`.TouchDown` -> called when the handle is first grabbed

`.TouchUpInside` -> called when handle is let go

`.ValueChanged` -> called whenever the color has changed hue or shade

`.TouchDragInside` -> called when the handle has moved by a drag action


## License
JCColorPicker is available under the MIT license. See the LICENSE file for more info.
