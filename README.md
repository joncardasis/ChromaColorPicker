# ChromaColorPicker :art:
![Supported Version](https://img.shields.io/badge/Swift-3-yellow.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgray.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-1.4-green.svg)
![Carthage](https://img.shields.io/badge/Carthage-✔-green.svg)

An intuitive iOS color picker built in Swift.

<img src="../assets/Screenshot-With-BG.png?raw=true" width="350">

## Installation
### Cocoapods
```
pod 'ChromaColorPicker'
```
### Manually
Add all files from the ChromaColorPicker folder to your project.


## Examples
```Swift
let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
neatColorPicker.delegate = self //ChromaColorPickerDelegate
neatColorPicker.padding = 5
neatColorPicker.stroke = 3
neatColorPicker.hexLabel.textColor = UIColor.white

view.addSubview(neatColorPicker)
```
<img src="../assets/demo.gif?raw=true" width="225">

If the ChromaColorPicker or any of its properties are later updated after being added to a view, the `layout()` function should be called to update the view.

```Swift
let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.addSubview(neatColorPicker)

neatColorPicker.padding = 0
neatColorPicker.hexLabel.hidden = true

neatColorPicker.layout()
```

You can also set the color of the picker anytime by using the `adjustToColor(color:)` function.

```Swift
let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
...
neatColorPicker.adjustToColor(UIColor.green)
...
```

## Customization
<img src="../assets/Design_Breakdown.png?raw=true" width="350">

### Properties

| Property        | Description           |
| :-------------:          |:-------------|
| delegate                 | ChromaColorPickerDelegate |
| padding                  | The padding on each side of the view (default=10)    |
| stroke                   | The stroke of the rainbow track (default=1)    |
| currentColor | The currently set color by the control. It is displayed in the add button. Use `adjustToColor(color: UIColor)` to update the color.|
| currentAngle | The angle which the handle is currently sitting at. Can be changed and the view can be re-drawn using `layout()` to show the change.
| handleSize | Returns the size of the handle. |

### Functions
| Function        | Description           |
| :-------------:          |:-------------|
|layout() | Layout the entire picker and all its subviews.|
|adjustToColor(color: ) | Updates the picker to a specific color.|

### Sub-Components
Sub-Components can be hidden and customized to the preferred liking.

| Component        | Description           |
| :-------------:          |:-------------|
| hexLabel | A UILabel which displays the hex value of the current color. |
| shadeSlider | A custom slider which adjusts the shade of the current color. |
| addButton | A custom UIButton in the center of the control. The `colorPickerDidChooseColor(colorPicker: color:)` delegate function is called when this is tapped. |
| handleView | A ChromaHandle (custom UIView) which displays the current color and can be moved around the circle.|
| handleLine | A line which is drawn from the addButton to the handleView. |

### Supported UIControlEvents
`.touchDown`       -> called when the handle is first grabbed

`.touchUpInside`   -> called when handle is let go

`.valueChanged`    -> called whenever the color has changed hue or shade

`.touchDragInside` -> called when the handle has moved by a drag action


## Additional Info
Check out the [Wiki](https://github.com/joncardasis/ChromaColorPicker/wiki/Challenges-and-Solutions) if you're interested in reading into how the color wheel was created.

## License
ChromaColorPicker is available under the MIT license. See the LICENSE file for more info.
