//
//  ColorWheelView.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/11/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

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
        
        let minDimensionSize = min(bounds.width, bounds.height)
        if let colorWheelImage = makeColorWheelImage(radius: minDimensionSize) {
            imageView.image = UIImage(ciImage: colorWheelImage)
        }
    }
    
    public var radius: CGFloat {
        return max(bounds.width, bounds.height) / 2.0
    }
    
    /**
     Returns the (x,y) location of the color provided within the ColorWheelView.
    */
    public func location(of color: UIColor) -> CGPoint {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let radianAngle = hue * (2 * .pi)
        let distance = saturation * radius
        let colorTranslation = CGPoint(x: distance * cos(radianAngle), y: -distance * sin(radianAngle))
        let colorPoint = CGPoint(x: center.x + colorTranslation.x, y: center.y + colorTranslation.y)
        
        return colorPoint
    }
    
    /**
     Returns the color on the wheel on a given point relative to the view. nil is returned if
     the point does not exist within the bounds of the color wheel.
    */
    public func pixelColor(at point: CGPoint) -> UIColor? {
        guard bounds.contains(point) else { return nil }
        
        let distanceFromCenter: CGFloat = hypot(center.x - point.x, center.y - point.y)
        let pointExistsInRadius: Bool = distanceFromCenter <= radius
        guard pointExistsInRadius else { return nil }
        
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
        layer.render(in: context)
        let color = UIColor(
            red: CGFloat(pixel[0]) / 255.0,
            green: CGFloat(pixel[1]) / 255.0,
            blue: CGFloat(pixel[2]) / 255.0,
            alpha: CGFloat(pixel[3]) / 255.0
        )
        
        pixel.deallocate()
        return color
    }
    
    // MARK: - Private
    internal let imageView = UIImageView()
    
    internal func commonInit() {
        backgroundColor = .clear
        setupImageView()
    }
    
    internal func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    /**
     Generates a color wheel image from a given radius.
     - Parameters:
        - radius: The radius of the wheel in points. A radius of 100 would generate an
                  image of 200x200 (400x400 pixels on a device with 2x scaling.)
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
}
