# JCColorPicker :art:
![Supported Version](https://img.shields.io/badge/Swift-2.2-yellow.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-lightgray.svg)

An intuitive iOS color picker built in Swift.

<img src="../assets/Screenshot-With-BG.png?raw=true" width="350">

## Installation
### Cocoapods
```
pod 'JCColorPicker'
```
### Manually
Add all files from the JCColorPicker folder to your project.


## Example
```Swift
let neatColorPicker = JCColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
neatColorPicker.padding = 5
neatColorPicker.stroke = 3
neatColorPicker.hexLabel.textColor = UIColor.whiteColor()

self.view.addSubview(neatColorPicker)
```
<img src="../assets/demo.gif?raw=true" width="225">

## Customization
<img src="../assets/Design_Breakdown.png?raw=true" width="350">

### Properties

| Property        | Description           |
| :-------------:          |:-------------|
| delegate                 | JCColorPickerDelegate |
| padding                  | The padding on each side of the view (default=10)    |
| stroke                   | The stroke of the rainbow track (deafult=1)    |
| currentColor | The currently set color by the control. It is displayed in the add button. |
| currentAngle | The angle which the handle is currently sitting at. Can be changed and the view can be re-drawn to show the change.
| handleSize | Returns the size of the handle. |


### Sub-Components
Sub-Components can be hidden and customized to the preferred liking.

| Component        | Description           |
| :-------------:          |:-------------|
| hexLabel | A UILabel which displays the hex value of the current color. |
| shadeSlider | A custom slider which adjusts the shade of the current color. |
| addButton | A UIButton in the center of the control. The `colorPickerDidChooseColor(colorPicker: color:)` delegate function is called when this is tapped. |
| handleView | A JCColorHandle (custom UIView) which displays the current color and can be moved around the circle.|
| handleLine | A line which is drawn from the addButton to the handleView. |

### Supported UIControlEvents
`.TouchDown`       -> called when the handle is first grabbed

`.TouchUpInside`   -> called when handle is let go

`.ValueChanged`    -> called whenever the color has changed hue or shade

`.TouchDragInside` -> called when the handle has moved by a drag action


## Additional Info
Check out the [Wiki](https://github.com/joncardasis/JCColorPicker/wiki/Challenges-and-Solutions) for more.

## License
JCColorPicker is available under the MIT license. See the LICENSE file for more info.
