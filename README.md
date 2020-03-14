<p align="center">
    <img src=".github/Logo.png" width="480" max-width="90%" alt="ChromaColorPicker 2.0" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
  <img src="https://img.shields.io/badge/platform-iOS-lightgray.svg" />
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" />
  <img src="https://img.shields.io/badge/Cocoapods-✔-green.svg" />
  <img src="https://img.shields.io/badge/Carthage-✔-green.svg" />
  <img src="https://travis-ci.com/joncardasis/ChromaColorPicker.svg?branch=master" />
</p>

An intuitive HSB color picker built in Swift. Supports multiple selection handles and is customizable to your needs.

<p align="center">
    <img src=".github/ChromaColorPicker.gif" width="365" alt="ChromaColorPicker GIF" />
</p>

<details>
<summary><b>Looking for version 1.x?</b></summary>
Version 1.x.x can be found on the <b>legacy</b> branch. While the pod is still available, it is deprecated and projects should migrate to 2.0.<br/>
<img src="../assets/Screenshot-With-BG.png?raw=true" height="350">
</details>

## Examples
```Swift
let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
addSubview(colorPicker)

// Optional: Attach a ChromaBrightnessSlider to a ChromaColorPicker
let brightnessSlider = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 280, height: 32))
addSubview(brightnessSlider)

colorPicker.connect(brightnessSlider) // or `brightnessSlider.connect(to: colorPicker)`
```

- View the _Example_ app for more.

## Usage
### Multiple Handles
```Swift
// Add handle at color
let peachColor = UIColor(red: 1, green: 203 / 255, blue: 164 / 255, alpha: 1)
colorPicker.addHandle(at: peachColor)

// Add handle with reference
let customHandle = ChromaColorHandle()
customHandle.color = UIColor.purple
colorPicker.addHandle(customHandle)

// Add handle and keep reference
let handle = colorPicker.addHandle(at: .blue)
```

### Custom Handle Icon
```Swift
let homeHandle = ChomaColorHandle(color: .blue)
let imageView = UIImageView(image: #imageLiteral(resourceName: "home-icon").withRenderingMode(.alwaysTemplate))
imageView.contentMode = .scaleAspectFit
imageView.tintColor = .white
homeHandle.accessoryView = imageView
homeHandle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)

colorPicker.addHandle(homeHandle)
```

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
| Component | Description |
| :-------: | :---------: |
| ChromaColorPicker | An HSB color picker with support for adding multiple color selection handles. |
| ChromaBrightnessSlider | A slider UIControl which can be attached to any `ChromaColorPicker` via the `connect(to:)` method. ChromaBrightnessSlider can also function as a stand-alone UIControl. |

## Supported UIControlEvents
Both `ChromaBrightnessSlider` and `ChromaColorPicker` conform to UIControl. Each send UIControlEvents which can be observed via via `UIControl`'s `addTarget` method.

_ChromaColorPicker_
| Event              | Description  |
| :-----------------:|:-------------|
| `.valueChanged`    | Called whenever the color has changed. |
| `.touchUpInside`   | Called when a handle is released. |

_ChromaBrightnessSlider_
| Event              | Description  |
| :-----------------:|:-------------|
| `.touchDown`       | Called when a the slider is grabbed. |
| `.valueChanged`    | Called whenever the slider is moved and the value has changed. |
| `.touchUpInside`   | Called when the slider handle is released. |

```Swift
// Example
brightnessSlider.addTarget(self, action: #selector(sliderDidValueChange(_:)), for: .valueChanged)

@objc func sliderDidValueChange(_ slider: ChromaBrightnessSlider) {
  print("new color: \(slider.currentColor)")
}
```

## License
ChromaColorPicker is available under the MIT license. See the LICENSE file for more info.
