<p align="center">
    <img src=".github/Logo.png" width="480" max-width="90%" alt="ChromaColorPicker 2.0" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
  <img src="https://img.shields.io/badge/platform-iOS-lightgray.svg" />
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" />
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

## Usage
### Multiple Handles
```Swift
// Add handles
{TODO}

// Add a custom handle
{TODO}

// Remove handles
{TODO}
```

### Supported UIControlEvents

## Installation
### Carthage
```bash
github "joncardasis/ChromaColorPicker"
```

### Cocoapods
```bash
pod 'ChromaColorPicker'
```
### Manually
Add all files from the `Source` folder to your project.

## Components
### ChromaColorPicker
An HSB color picker with support for adding multiple color selection handles.

### ChromaBrightnessSlider
[ChromaBrightnessSlider]() is a slider UIControl which can be attached to any `ChromaColorPicker` via the `connect(to:)` method. ChromaBrightnessSlider can also function as a stand-alone UIControl.

### Supported UIControlEvents
You can observe on the following UIControlEvents via `UIControl`'s `addTarget` method:

```Swift
addTarget(self, action: #selector(sliderDidValueChange(_:)), for: .valueChanged)

@objc func sliderDidValueChange(_ slider: ChromaBrightnessSlider) {
  print("new color: \(slider.currentColor)")
}
```

_ChromaColorPicker_
| Event              | Description  |
| :-----------------:|:-------------|
| `.touchDown`(no)       | Called when a handle is first grabbed. |
| `.touchUpInside`(no)   | Called when a handle is let go. |
| `.valueChanged`    | Called whenever the color has changed. |
| `.touchDragInside`(no) | Called when a handle has moved via a drag action. |
| `.touchUpInside`   | Called when a handle is released. |

_ChromaBrightnessSlider_
| Event              | Description  |
| :-----------------:|:-------------|
| `.touchDown`       | Called when a the slider is grabbed. |
| `.valueChanged`    | Called whenever the slider is moved and the value has changed. |
| `.touchUpInside`   | Called when the slider handle is released. |

##### Example
```Swift
```

## License
ChromaColorPicker is available under the MIT license. See the LICENSE file for more info.
