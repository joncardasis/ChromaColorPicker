//
//  UIColor+TestHelpers.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 5/2/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

extension UIColor {
    
    var rgbValues: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red, green, blue)
    }
    
    var hsbaValues: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h,s,b,a)
    }
    
}
