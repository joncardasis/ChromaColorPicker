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
public class ChromaColorPicker: UIControl, ChromaControlStylable {
    
    @IBInspectable public var borderWidth: CGFloat = 8.0 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable public var borderColor: UIColor = .white {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable public var showsShadow: Bool = true {
        didSet { setNeedsLayout() }
    }
    
    /// A brightness slider attached via the `connect(_:)` method.
    private(set) public weak var brightnessSlider: ChromaBrightnessSlider? {
        didSet {
            oldValue?.removeTarget(self, action: nil, for: .valueChanged)
        }
    }
    
    //MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowIfNeeded()
        updateBorderIfNeeded()
    }
    
    // MARK: - Public
    
    public func addHandle(at color: UIColor? = nil) -> ChromaColorHandle {
        return ChromaColorHandle(color: color ?? defaultHandleColorPosition)
    }
    
    public func connect(_ slider: ChromaBrightnessSlider) {
        slider.addTarget(self, action: #selector(brightnessSliderDidValueChange(_:)), for: .valueChanged)
        brightnessSlider = slider
    }
    
    // MARK: - Private
    internal let colorWheelView = ColorWheelView()
    
    internal func commonInit() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        setupColorWheelView()
        setupGestures()
    }
    
    // MARK: Setup & Layout
    
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
    
    func updateShadowIfNeeded() {
        if showsShadow {
            applyDropShadow(shadowProperties(forHeight: bounds.height))
        } else {
            removeDropShadow()
        }
    }
    
    internal func updateBorderIfNeeded() {
        colorWheelView.layer.borderColor = borderColor.cgColor
        colorWheelView.layer.borderWidth = borderWidth
    }
    
    internal func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorWheelTapped(_:)))
        colorWheelView.isUserInteractionEnabled = true
        colorWheelView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Actions
    
    @objc
    internal func colorWheelTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: colorWheelView)
        let pixelColor = colorWheelView.pixelColor(at: location)
        print(pixelColor)
    }
    
    @objc
    internal func brightnessSliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        
    }
}

internal let defaultHandleColorPosition: UIColor = .black
