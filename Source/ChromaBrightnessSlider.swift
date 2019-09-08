//
//  ChromaBrightnessSlider.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/13/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

public class ChromaBrightnessSlider: UIControl, ChromaControlStylable {
    
    /// The value of the slider between [0.0, 1.0].
    public var currentValue: CGFloat = 0.0 {
        didSet { updateControl(to: currentValue) }
    }
    
    /// The base color the slider on the track.
    public var trackColor: UIColor = .white {
        didSet { updateTrackColor(to: trackColor) }
    }
    
    /// The value of the color the handle is currently displaying.
    public var currentColor: UIColor {
        return handle.handleColor
    }
    
    /// The handle control of the slider.
    public let handle = SliderHandleView()
    
    public var borderWidth: CGFloat = 4.0 {
        didSet { layoutNow() }
    }
    
    public var borderColor: UIColor = .white {
        didSet { layoutNow() }
    }
    
    public var showsShadow: Bool = true {
        didSet { layoutNow() }
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
    
    // MARK: - Public
    
    /// Attaches control to the provided color picker.
    public func connect(to colorPicker: ChromaColorPicker) {
        colorPicker.connect(self)
    }
    
    /// Returns the relative value on the slider [0.0, 1.0] for the given color brightness ([0.0, 1.0]).
    public func value(brightness: CGFloat) -> CGFloat {
        let clamedBrightness = max(0, min(brightness, 1.0))
        return 1.0 - clamedBrightness
    }
    
    // MARK: - Control
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let shouldBeginTracking = interactableBounds.contains(location)
        if shouldBeginTracking {
            sendActions(for: .touchDown)
        }
        return shouldBeginTracking
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let clampedPositionX: CGFloat = max(0, min(location.x, confiningTrackFrame.width))
        let value = clampedPositionX / confiningTrackFrame.width
        
        currentValue = value
        sendActions(for: .valueChanged)
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if interactableBounds.contains(point) {
            return true
        }
        return super.point(inside: point, with: event)
    }
    
    internal func updateShadowIfNeeded() {
        let views = [handle, sliderTrackView]
        
        if showsShadow {
            let shadowProps = shadowProperties(forHeight: bounds.height)
            views.forEach { $0.applyDropShadow(shadowProps) }
        } else {
            views.forEach { $0.removeDropShadow() }
        }
    }
    
    // MARK: - Private
    private let sliderTrackView = SliderTrackView()
    
    /// The amount of padding caused by visual stylings
    private var horizontalPadding: CGFloat {
        return sliderTrackView.layer.cornerRadius / 2.0
    }
    
    private var confiningTrackFrame: CGRect {
        return sliderTrackView.frame.insetBy(dx: horizontalPadding, dy: 0)
    }
    
    private var interactableBounds: CGRect {
        let horizontalOffset = -(handle.bounds.width / 2) + horizontalPadding
        return bounds.insetBy(dx: horizontalOffset, dy: 0)
    }
    
    private func commonInit() {
        backgroundColor = .clear
        setupSliderTrackView()
        setupSliderHandleView()
        updateTrackColor(to: trackColor)
    }
    
    private func setupSliderTrackView() {
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
    
    private func setupSliderHandleView() {
        handle.isUserInteractionEnabled = false
        addSubview(handle)
    }
    
    private func updateControl(to value: CGFloat) {
        let brightness = 1 - max(0, min(1, value))
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        trackColor.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        handle.handleColor = newColor
        CATransaction.commit()
        
        moveHandle(to: value)
    }
    
    private func updateTrackColor(to color: UIColor) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        let colorWithMaxBrightness = UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1)
        
        updateTrackViewGradient(for: colorWithMaxBrightness)
        currentValue = 1 - brightness
    }
    
    private func updateTrackViewGradient(for color: UIColor) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        sliderTrackView.gradientValues = (color, .black)
        CATransaction.commit()
    }
    
    private func moveHandle(to value: CGFloat) {
        let clampedValue = max(0, min(1, value))
        let xPos = (clampedValue * confiningTrackFrame.width) + horizontalPadding
        let size = CGSize(width: bounds.height * 1.15, height: bounds.height)
        
        handle.frame = CGRect(origin: CGPoint(x: xPos - (size.width / 2), y: 0), size: size)
    }
}
