//
//  BrightnessSlider.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/13/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

public class BrightnessSlider: UIControl, ChromaControlStylable {
    
    /// The value of the slider between [0.0, 1.0].
    public var currentValue: CGFloat = 0.0 {
        didSet { updateControl(to: currentValue) }
    }
    
    /// The value of the color the handle is currently displaying.
    public var currentColor: UIColor {
        return sliderHandleView.handleColor
    }
    
    public var borderWidth: CGFloat = 4.0 {
        didSet { setNeedsLayout() }
    }
    
    public var borderColor: UIColor = .white {
        didSet { setNeedsLayout() }
    }
    
    public var showsShadow: Bool = true {
        didSet { setNeedsLayout() }
    }
    
    //MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        sliderTrackView.layer.cornerRadius = sliderTrackView.bounds.height / 2.0
        sliderTrackView.layer.borderColor = borderColor.cgColor
        sliderTrackView.layer.borderWidth = borderWidth
        
        moveHandle(to: currentValue)
        updateShadowIfNeeded()
    }
    
    /// Sets the tracking color of the slider and updates the gradient view.
    public func updateTrackingColor(to color: UIColor, value: CGFloat) {
        updateTrackViewGradient(for: color)
        currentValue = value
    }
    
    // MARK: - Control
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        return confiningTrackFrame.contains(location) || sliderHandleView.frame.contains(location)
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let clampedPositionX: CGFloat = max(0, min(location.x, confiningTrackFrame.width))
        let value = clampedPositionX / confiningTrackFrame.width
        
        updateControl(to: value)
        sendActions(for: .valueChanged)
        
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sendActions(for: .editingDidEnd)
    }
    
    // MARK: - Private
    internal let sliderTrackView = SliderTrackView()
    internal let sliderHandleView = SliderHandleView()
    
    /// The amount of padding caused by visual stylings
    internal var horizontalPadding: CGFloat {
        return sliderTrackView.layer.cornerRadius / 2.0
    }
    
    internal var confiningTrackFrame: CGRect {
        return sliderTrackView.frame.insetBy(dx: horizontalPadding, dy: 0)
    }
    
    internal func commonInit() {
        backgroundColor = .clear
        setupSliderTrackView()
        setupSliderHandleView()
        updateControl(to: currentValue)
    }
    
    internal func setupSliderTrackView() {
        sliderTrackView.isUserInteractionEnabled = false
        sliderTrackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sliderTrackView)
        NSLayoutConstraint.activate([
            sliderTrackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sliderTrackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sliderTrackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            sliderTrackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    internal func setupSliderHandleView() {
        sliderHandleView.isUserInteractionEnabled = false
        addSubview(sliderHandleView)
    }
    
    internal func updateShadowIfNeeded() {
        let views = [sliderHandleView, sliderTrackView]
        
        if showsShadow {
            let shadowProps = shadowProperties(forHeight: bounds.height)
            views.forEach { $0.applyDropShadow(shadowProps) }
        } else {
            views.forEach { $0.removeDropShadow() }
        }
    }
    
//    internal func updateControl(to color: UIColor) {
//        updateTrackViewGradient(for: color)
//    }
    
    internal func updateControl(to value: CGFloat) {
        let brightness = 1 - max(0, min(1, value))
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        currentColor.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        sliderHandleView.handleColor = newColor
        CATransaction.commit()
        
        moveHandle(to: value)
    }
    
    internal func updateTrackViewGradient(for color: UIColor) {
        sliderTrackView.gradientValues = (color, .black)
    }
    
    internal func moveHandle(to value: CGFloat) {
        let clampedValue = max(0, min(1, value))
        let xPos = (clampedValue * confiningTrackFrame.width) + horizontalPadding
        let size = CGSize(width: bounds.height * 1.15, height: bounds.height)
        
        sliderHandleView.frame = CGRect(origin: CGPoint(x: xPos - (size.width / 2), y: 0), size: size)
    }
    
    
}
