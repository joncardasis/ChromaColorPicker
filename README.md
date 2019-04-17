<p align="center">
    <img src=".github/Logo.png" width="480" max-width="90%" alt="ChromaColorPicker 2.0" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
  <img src="https://img.shields.io/badge/platform-iOS-lightgray.svg" />
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" />
  <img src="https://img.shields.io/badge/pod-1.7.1-green.svg" />
  <img src="https://img.shields.io/badge/Carthage-compatible-green.svg" />
  <img src="https://travis-ci.com/joncardasis/ChromaColorPicker.svg?branch=develop" />
</p>

An intuitive HSB color picker built in Swift. Supports multiple selection handles and is customizable to your needs.

> TODO: Image / GIF

## Examples
```Swift
let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
addSubview(colorPicker)

// Optional: Add multiple handles to the color picker

// Optional: Attach a ChromaBrightnessSlider to a ChromaColorPicker
let brightnessSlider = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 280, height: 32))
addSubview(brightnessSlider)

colorPicker.connect(brightnessSlider) // or `brightnessSlider.connect(to: colorPicker)`

```

## Installation
### Carthage
```
github "joncardasis/ChromaColorPicker"
```

### Cocoapods
```
pod 'ChromaColorPicker'
```
### Manually
Add all files from the `Source` folder to your project.

## Components

### ChromaColorPicker

### ChromaBrightnessSlider

### Supported UIControlEvents
| Event              | Description  |
| :-----------------:|:-------------|
| `.touchDown`       | Called when a handle is first grabbed. |
| `.touchUpInside`   | Called when a handle is let go. |
| `.valueChanged`    | Called whenever the color has changed. |
| `.touchDragInside` | Called when a handle has moved via a drag action. |
| `.editingDidEnd`   | Called when either a handle is let go or slider is let go. |

##### Example
```Swift
```

## License
ChromaColorPicker is available under the MIT license. See the LICENSE file for more info.
