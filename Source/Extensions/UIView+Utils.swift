//
//  UIView+Utils.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 9/8/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

internal extension UIView {
    
    /// Forces the view to layout synchronously and immediately
    func layoutNow() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
