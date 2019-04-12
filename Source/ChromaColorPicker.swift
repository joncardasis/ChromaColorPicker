//
//  ChromaColorPicker2.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 3/10/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit
import Accelerate

public protocol ChromaColorPickerDelegate {
    /// When the control has changed
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor)
}



@IBDesignable
public class ChromaColorPicker: UIControl {
    
    //MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override func setNeedsDisplay() {
        super.setNeedsDisplay()
        print("called")

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func addHandle(at color: UIColor? = nil) -> ChromaColorHandle {
        return ChromaColorHandle(color: color ?? defaultHandleColorPosition)
    }
    
    // MARK: - Private
    internal let colorWheelView = ColorWheelView()
    
    internal func commonInit() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        setupColorWheelView()
        applySmoothingMaskToColorWheel()
        setupGestures()
    }
    
    internal func setupColorWheelView() {
        colorWheelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorWheelView)
        NSLayoutConstraint.activate([
            colorWheelView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            colorWheelView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorWheelView.widthAnchor.constraint(equalTo: self.widthAnchor),
            colorWheelView.heightAnchor.constraint(equalTo: colorWheelView.widthAnchor),
        ])
    }
    
    /// Applys a smoothing mask to the color wheel to account for CIFilter's image dithering at the edges.
    internal func applySmoothingMaskToColorWheel() {
        
    }
    
    internal func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorWheelTapped(_:)))
        colorWheelView.isUserInteractionEnabled = true
        colorWheelView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    internal func colorWheelTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: colorWheelView)
        let pixelColor = colorWheelView.pixelColor(at: location)
        print(pixelColor)
    }
}

internal let defaultHandleColorPosition: UIColor = .black
