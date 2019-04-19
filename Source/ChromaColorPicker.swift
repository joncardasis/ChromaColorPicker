//
//  ChromaColorPicker2.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 3/10/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit
import Accelerate

public protocol ChromaColorPickerDelegate: class {
    /// When the control has changed
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor)
}


@IBDesignable
public class ChromaColorPicker: UIControl, ChromaControlStylable {
    
    public weak var delegate: ChromaColorPickerDelegate?
    
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
    
    //public var handleSize: CGSize { /* TODO */ }
    
    /// Handles added to the color picker.
    private(set) public var handles: [ChromaColorHandle] = []
    
    /// The last active handle.
    private(set) public var currentHandle: ChromaColorHandle?
    
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
        
        handles.forEach { handle in
            //let location = colorWheelView.location(of: handle.color)
            handle.frame.size = defaultHandleSize
            //handle.center = location
        }
    }
    
    // MARK: - Public
    
    @discardableResult
    public func addHandle(at color: UIColor? = nil) -> ChromaColorHandle {
        let handleColor = color ?? defaultHandleColorPosition
        let handle = ChromaColorHandle()
        handle.color = handleColor
        
        addHandle(handle)
        return handle
    }
    
    public func addHandle(_ handle: ChromaColorHandle) {
        addPanGesture(to: handle)
        handles.append(handle)
        colorWheelView.addSubview(handle)
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
        //setupGestures()
    }
    
    // MARK: - Control
    
//    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let location = touch.location(in: self)
//
//        for handle in handles {
//            if handle.frame.contains(location) {
//                print("tapped on handle")
//                currentHandle = handle
//                return true
//            }
//        }
//        return false
//    }
//
//    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let location = touch.location(in: colorWheelView)
//        guard let handle = currentHandle else { return false }
//
//        handle.center = location
//        if let selectedColor = colorWheelView.pixelColor(at: location) {
//            print(location)
//            handle.color = selectedColor
//
//            delegate?.colorPickerDidChooseColor(self, color: selectedColor)
//        }
//
//        sendActions(for: .valueChanged)
//        return true
//    }
//
//    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        sendActions(for: .editingDidEnd)
//    }
    
    internal func addPanGesture(to handle: ChromaColorHandle) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleWasMoved(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        handle.addGestureRecognizer(panGesture)
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
    internal func handleWasMoved(_ gesture: UIPanGestureRecognizer) {
        if let touchedView = gesture.view {
            colorWheelView.bringSubviewToFront(touchedView)
        }
        
        switch (gesture.state) {
        case .began:
            currentHandle = gesture.view as? ChromaColorHandle
        case .changed:
            let location = gesture.location(in: colorWheelView)

            if let handle = currentHandle, let pixelColor = colorWheelView.pixelColor(at: location) {
                let previousBrightness = handle.color.brightness
                
                print(pixelColor)
                
                handle.color = pixelColor.withBrightness(previousBrightness)
                handle.center = location
                
                if let slider = brightnessSlider {
                    slider.trackColor = pixelColor
                    slider.currentValue = slider.value(brightness: previousBrightness)
                }
                
                informDelegateOfColorChange(on: handle)
            }
            
            self.sendActions(for: .touchDragInside)
        case .ended:
            /* Shrink Animation */
            //self.executeHandleShrinkAnimation()
            break
        default:
            break
        }
    }
    
    @objc
    internal func colorWheelTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: colorWheelView)
        let pixelColor = colorWheelView.pixelColor(at: location)
        print(pixelColor)
        
        print(location)
        delegate?.colorPickerDidChooseColor(self, color: pixelColor!)
    }
    
    @objc
    internal func brightnessSliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        guard let currentHandle = currentHandle else { return }
        
        currentHandle.color = slider.currentColor
        informDelegateOfColorChange(on: currentHandle)
    }
    
    internal func informDelegateOfColorChange(on handle: ChromaColorHandle) {
        delegate?.colorPickerDidChooseColor(self, color: handle.color)
    }
}

internal let defaultHandleColorPosition: UIColor = .white
internal let defaultHandleSize: CGSize = CGSize(width: 42, height: 42)
