//
//  ColorWheelView.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/11/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

/// This value is used to expand the imageView's bounds and then mask back to its normal size
/// such that any displayed image may have perfectly rounded corners.
private let defaultImageViewCurveInset: CGFloat = 1.0

public class ColorWheelView: UIView {
    
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
        layer.masksToBounds = false
        layer.cornerRadius = radius
        
        let screenScale: CGFloat = UIScreen.main.scale
        if let colorWheelImage: CIImage = makeColorWheelImage(radius: radius * screenScale) {
            imageView.image = UIImage(ciImage: colorWheelImage, scale: screenScale, orientation: .up)
        }
        
        // Mask imageview so the generated colorwheel has smooth edges.
        // We mask the imageview instead of image so we get the benefits of using the CIImage
        // rendering directly on the GPU.
        imageViewMask.frame = imageView.bounds.insetBy(dx: defaultImageViewCurveInset, dy: defaultImageViewCurveInset)
        imageViewMask.layer.cornerRadius = imageViewMask.bounds.width / 2.0
        imageView.mask = imageViewMask
    }

    public var radius: CGFloat {
        return max(bounds.width, bounds.height) / 2.0
    }
    
    public var middlePoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /**
     Returns the (x,y) location of the color provided within the ColorWheelView.
     Disregards color's brightness component.
    */
    public func location(of color: UIColor) -> CGPoint {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let radianAngle = hue * (2 * .pi)
        let distance = saturation * radius
        let colorTranslation = CGPoint(x: distance * cos(radianAngle), y: -distance * sin(radianAngle))
        let colorPoint = CGPoint(x: bounds.midX + colorTranslation.x, y: bounds.midY + colorTranslation.y)
        
        return colorPoint
    }
    
    /**
     Returns the color on the wheel on a given point relative to the view. nil is returned if
     the point does not exist within the bounds of the color wheel.
    */
    // TODO: replace this function with a mathmatically based one in ChromaColorPicker
    public func pixelColor(at point: CGPoint) -> UIColor? {
        guard pointIsInColorWheel(point) else { return nil }
        
        // Values on the edge of the circle should be calculated instead of obtained
        // from the rendered view layer. This ensures we obtain correct values where
        // image smoothing may have taken place.
        guard !pointIsOnColorWheelEdge(point) else {
            let angleToCenter = atan2(point.x - middlePoint.x, point.y - middlePoint.y)
            return edgeColor(for: angleToCenter)
        }
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(
            data: pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return nil
        }
        
        context.translateBy(x: -point.x, y: -point.y)
        imageView.layer.render(in: context)
        let color = UIColor(
            red: CGFloat(pixel[0]) / 255.0,
            green: CGFloat(pixel[1]) / 255.0,
            blue: CGFloat(pixel[2]) / 255.0,
            alpha: 1.0
        )
        
        pixel.deallocate()
        return color
    }
    
    /**
     Returns whether or not the point is in the circular area of the color wheel.
    */
    public func pointIsInColorWheel(_ point: CGPoint) -> Bool {
        guard bounds.insetBy(dx: -1, dy: -1).contains(point) else { return false }
        
        let distanceFromCenter: CGFloat = hypot(middlePoint.x - point.x, middlePoint.y - point.y)
        let pointExistsInRadius: Bool = distanceFromCenter <= (radius - layer.borderWidth)
        return pointExistsInRadius
    }
    
    public func pointIsOnColorWheelEdge(_ point: CGPoint) -> Bool {
        let distanceToCenter = hypot(middlePoint.x - point.x, middlePoint.y - point.y)
        let isPointOnEdge = distanceToCenter >= radius - 1.0
        return isPointOnEdge
    }
    
    // MARK: - Private
    internal let imageView = UIImageView()
    internal let imageViewMask = UIView()
    
    internal func commonInit() {
        backgroundColor = .clear
        setupImageView()
    }
    
    internal func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageViewMask.backgroundColor = .black
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: defaultImageViewCurveInset * 2),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: defaultImageViewCurveInset * 2),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    /**
     Generates a color wheel image from a given radius.
     - Parameters:
        - radius: The radius of the wheel in points. A radius of 100 would generate an
                  image of 200x200 points (400x400 pixels on a device with 2x scaling.)
    */
    internal func makeColorWheelImage(radius: CGFloat) -> CIImage? {
        let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
            "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
            "inputDither": 0,
            "inputRadius": radius,
            "inputSoftness": 0,
            "inputValue": 1
        ])
        return filter?.outputImage
    }
    
    /**
     Returns a color for a provided radian angle on the color wheel.
     - Note: Adjusts angle for the local color space and returns a color of
             max saturation and brightness with variable hue.
    */
    internal func edgeColor(for angle: CGFloat) -> UIColor {
        var normalizedAngle = angle + .pi // normalize to [0, 2pi]
        normalizedAngle += (.pi / 2) // rotate pi/2 for color wheel
        var hue = normalizedAngle / (2 * .pi)
        if hue > 1 { hue -= 1 }
        return UIColor(hue: hue, saturation: 1, brightness: 1.0, alpha: 1.0)
    }
}
