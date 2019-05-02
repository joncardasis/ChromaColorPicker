//
//  UIColor+Brightness.swift
//  Example
//
//  Created by Jon Cardasis on 4/18/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

internal extension UIColor {
    
    /// Returns a color with the specified brightness component.
    func withBrightness(_ value: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0
        let brightness = max(0, min(value, 1))
        getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// The value of the brightness component.
    var brightness: CGFloat {
        var brightness: CGFloat = 0
        getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}
