//
//  UIView+DropShadow.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/11/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

internal struct ShadowProperties {
    internal let color: CGColor
    internal let opacity: Float
    internal let offset: CGSize
    internal let radius: CGFloat
}

internal extension UIView {
    
    var dropShadowProperties: ShadowProperties? {
        guard let shadowColor = layer.shadowColor else { return nil }
        return ShadowProperties(color: shadowColor, opacity: layer.shadowOpacity, offset: layer.shadowOffset, radius: layer.shadowRadius)
    }
    
    func applyDropShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func applyDropShadow(_ properties: ShadowProperties) {
        applyDropShadow(color: UIColor(cgColor: properties.color), opacity: properties.opacity, offset: properties.offset, radius: properties.radius)
    }
    
    func removeDropShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
    }
}
