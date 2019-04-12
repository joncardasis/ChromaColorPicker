//
//  ChromaColorHandle.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/11/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

public class ChromaColorHandle {
    /// Current selected color of the handle.
    fileprivate(set) var color: UIColor
    
    /// An image to display above the handle.
    var popoverImage: UIImage?
    
    /// A view to display above the handle. Overrides any provided `popoverImage`.
    var popoverView: UIView?
    
    init(color: UIColor) {
        self.color = color
    }
}
