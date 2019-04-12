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

func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double { //TEMP - DEBUG
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}


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
        
        let minDimensionSize = min(bounds.width, bounds.height)
        let colorWheelImage = makeColorWheel(radius: minDimensionSize * 3.0) // TEMP?
        colorWheelImageView.image = colorWheelImage
    }
    
    public func addHandle(at color: UIColor? = nil) -> ChromaColorHandle {
        return ChromaColorHandle(color: color ?? defaultHandleColorPosition)
    }
    
    // MARK: - Private
    internal var colorWheelImageView: UIImageView!
    
    internal func commonInit() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        setupColorWheel()
        applySmoothingMaskToColorWheel()
        setupGestures()
        
        
        
         // DEBUG - BENCHMARK
        func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double {
            let startTime = CFAbsoluteTimeGetCurrent()
            operation()
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            return Double(timeElapsed)
        }
        
        var times = [Double]()
        for _ in 0..<10 {
            let time = timeElapsedInSecondsWhenRunningCode {
                _ = makeColorWheel(radius: 1400)
            }
            times.append(time)
            print(time)
        }
        
        let avgTime = times.reduce(0, +) / Double(times.count)
        print("\n\nAvgTime: \(avgTime)")
        // END DEBUG
    }
    
    internal func setupColorWheel() {
        colorWheelImageView = UIImageView(image: nil)
        colorWheelImageView.contentMode = .scaleAspectFit
        
        colorWheelImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorWheelImageView)
        NSLayoutConstraint.activate([
            colorWheelImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            colorWheelImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorWheelImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            colorWheelImageView.heightAnchor.constraint(equalTo: colorWheelImageView.widthAnchor),
        ])
    }
    
    /// Applys a smoothing mask to the color wheel to account for CIFilter's image dithering at the edges.
    internal func applySmoothingMaskToColorWheel() {
        
    }
    
    internal func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorWheelTapped(_:)))
        colorWheelImageView.isUserInteractionEnabled = true
        colorWheelImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    internal func colorWheelTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: colorWheelImageView)
        let pixelColor = colorWheelImageView.getPixelColor(at: location)
        print()
    }
    
    /**
     Generates a color wheel image from a given radius.
     - Parameters:
        - radius: The radius of the wheel in points. A radius of 100 would generate an
                  image of 200x200 (400x400 pixels on a device with 2x scaling.)
    */
    internal func makeColorWheel(radius: CGFloat) -> UIImage {
        let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
            "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
            "inputDither": 0,
            "inputRadius": radius,
            "inputSoftness": 0,
            "inputValue": 1
        ])!
        return UIImage(ciImage: filter.outputImage!)
    }
    
    
    
    /*
    internal lazy var context = makeMetalContext()
    
    internal func makeMetalContext() -> CIContext {
        let mtlDevice = MTLCreateSystemDefaultDevice()
        if let device = mtlDevice, device.supportsFeatureSet(.iOS_GPUFamily1_v1) {
            return CIContext(mtlDevice: device, options: [CIContextOption.useSoftwareRenderer: false])
        } else if let eaglContext = EAGLContext(api: .openGLES2) {
            return CIContext(eaglContext: eaglContext)
        } else {
            return CIContext()
        }
    }
    
    internal lazy var lookupImage: CGImage = {
        let colorWheelCIImage = makeColorWheel(radius: 50).ciImage!
        return context.createCGImage(colorWheelCIImage, from: colorWheelCIImage.extent)!
    }()
    
    internal func location(of color: UIColor) -> CGPoint? {
//        guard let image = colorWheelImageView.image else { return nil }
//
//        let ci = image.ciImage!
//        let cgImage = context.createCGImage(ci, from: ci.extent)!
        let cgImage = self.lookupImage
        
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        let r = UInt8(red * 255.0)
        let g = UInt8(green * 255.0)
        let b = UInt8(blue * 255.0)
        
        let width = 100 //Int(image.size.width)
        let height = 100 //Int(image.size.height)
        if let cfData = cgImage.dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) {
            for x in 0..<width {
                for y in 0..<height {
                    // TODO: do a DISTANCE calc and find closest distance
                    let pixelAddress = x * 4 + y * width * 4
                    if pointer.advanced(by: pixelAddress).pointee == r &&     //Red
                        pointer.advanced(by: pixelAddress + 1).pointee == g && //Green
                        pointer.advanced(by: pixelAddress + 2).pointee == b { //Blue
                        print(CGPoint(x: x, y: y)) //temp
                        return CGPoint(x: x, y: y)
                    }
                }
            }
        }
        return nil
    }
    */
    
}

private let defaultHandleColorPosition: UIColor = .black


internal extension UIImageView {
    internal func getPixelColor(at point: CGPoint) -> UIColor {
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
            return UIColor.white
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
}

extension UIImage {
    
    func resized(newWidth: CGFloat, context: CIContext) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


extension CGImage {
    func resizeImageUsingVImage(size:CGSize) -> CGImage? {
        let cgImage = self
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        // create a destination buffer
        //let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.bitsPerPixel/8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate(capacity: destHeight * destBytesPerRow)
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        // create a CGImage from vImage_Buffer
        var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        // create a UIImage
//        defer {
//            destCGImage = nil
//        }
        return destCGImage
        
//        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
//        destCGImage = nil
//        return resizedImage
    }
}
