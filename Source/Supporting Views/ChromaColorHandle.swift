//
//  ChromaColorHandle.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/11/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

public class ChromaColorHandle: UIView, ChromaControlStylable {
    
    /// Current selected color of the handle.
    public var color: UIColor = .black {
        didSet { layoutNow() }
    }
    
    /// An image to display in the handle. Updates `accessoryView` to be a UIImageView.
    public var accessoryImage: UIImage? {
        didSet {
            let imageView = UIImageView(image: accessoryImage)
            imageView.contentMode = .scaleAspectFit
            accessoryView = imageView
        }
    }
    
    /// A view to display in the handle. Overrides any previously set `accessoryImage`.
    public var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let accessoryView = accessoryView {
                addAccessoryView(accessoryView)
            }
        }
    }
    
    /// The amount an accessory view's frame should be inset by.
    public var accessoryViewEdgeInsets: UIEdgeInsets = .zero {
        didSet { layoutNow() }
    }
    
    public var borderWidth: CGFloat = 3.0 {
        didSet { layoutNow() }
    }
    
    public var borderColor: UIColor = .white {
        didSet { layoutNow() }
    }
    
    public var showsShadow: Bool = true {
        didSet { layoutNow() }
    }
    
    // MARK: - Initialization
    
    public convenience init(color: UIColor) {
        self.init(frame: .zero)
        self.color = color
        commonInit()
    }
    
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
        layoutHandleShape()
        layoutAccessoryViewIfNeeded()
        updateShadowIfNeeded()
        
        layer.masksToBounds = false
    }
    
    // MARK: - Private
    internal let handleShape = CAShapeLayer()
    
    internal func commonInit() {
        layer.addSublayer(handleShape)
    }
    
    internal func updateShadowIfNeeded() {
        if showsShadow {
            let shadowProps = ShadowProperties(color: UIColor.black.cgColor,
                                               opacity: 0.3,
                                               offset: CGSize(width: 0, height: bounds.height / 8.0),
                                               radius: 4.0)
            applyDropShadow(shadowProps)
        } else {
            removeDropShadow()
        }
    }
    
    internal func makeHandlePath(frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY + 1 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.40310 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.83333 * frame.width, y: frame.minY + 0.80216 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.60320 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY * frame.height), controlPoint1: CGPoint(x: frame.minX + 1 * frame.width, y: frame.minY + 0.18047 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.77614 * frame.width, y: frame.minY * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.40310 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.22386 * frame.width, y: frame.minY * frame.height), controlPoint2: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.18047 * frame.height))
        path.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 1 * frame.height), controlPoint1: CGPoint(x: frame.minX * frame.width, y: frame.minY + 0.60837 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.16667 * frame.width, y: frame.minY + 0.80733 * frame.height))
        path.close()
        return path.cgPath
    }
    
    internal func layoutHandleShape() {
        let size = CGSize(width: bounds.width - borderWidth, height: bounds.height - borderWidth)
        handleShape.path = makeHandlePath(frame: CGRect(origin: .zero, size: size))
        handleShape.frame = CGRect(origin: CGPoint(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2)), size: size)
        
        handleShape.fillColor = color.cgColor
        handleShape.strokeColor = borderColor.cgColor
        handleShape.lineWidth = borderWidth
    }
    
    internal func layoutAccessoryViewIfNeeded() {
        if let accessoryLayer = accessoryView?.layer {
            let width = bounds.width - borderWidth * 2
            let size = CGSize(width: width - (accessoryViewEdgeInsets.left + accessoryViewEdgeInsets.right),
                              height: width - (accessoryViewEdgeInsets.top + accessoryViewEdgeInsets.bottom))
            accessoryLayer.frame = CGRect(origin: CGPoint(x: (borderWidth / 2) + accessoryViewEdgeInsets.left, y: (borderWidth / 2) + accessoryViewEdgeInsets.top), size: size)
            
            accessoryLayer.cornerRadius = size.height / 2
            accessoryLayer.masksToBounds = true
        }
    }
    
    internal func addAccessoryView(_ view: UIView) {
        let accessoryLayer = view.layer
        handleShape.addSublayer(accessoryLayer)
    }
}
