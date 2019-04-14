//
//  ChromaControlStylable.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/13/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

internal protocol ChromaControlStylable {
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
    var showsShadow: Bool { get set }
    
    func updateShadowIfNeeded()
}

internal extension ChromaControlStylable where Self: UIView {
    
    func shadowProperties(forHeight height: CGFloat) -> ShadowProperties {
        let dropShadowHeight = height * 0.01
        return ShadowProperties(color: UIColor.black.cgColor, opacity: 0.35, offset: CGSize(width: 0, height: dropShadowHeight), radius: 4)
    }
}
