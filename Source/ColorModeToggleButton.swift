//
//  ColorModeToggleButton.swift
//
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

open class ColorModeToggleButton: UIButton {
    
    public enum ColorState {
        case hue
        case grayscale
    }
    
    open var colorState: ColorState = .hue
    
    open lazy var hueColorGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let colorUpperLeft = UIColor(red: 250/255.0, green: 217/255.0, blue: 97/255.0, alpha: 1)
        let colorLowerRight = UIColor(red: 247/255.0, green: 107/255.0, blue: 28/255.0, alpha: 1)
        gradient.colors = [colorUpperLeft.cgColor, colorLowerRight.cgColor]
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        return gradient
    }()
    
    open lazy var grayColorGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        let gray = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        let colorUpperLeft = gray
        let colorLowerRight = gray.darkerColor(0.25)
        gradient.colors = [colorUpperLeft.cgColor, colorLowerRight.cgColor]
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        return gradient
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(hueColorGradientLayer)
        layer.addSublayer(grayColorGradientLayer)
        
        addTarget(self, action: #selector(toggleState), for: .touchUpInside)
    }
    
//    override open func sendActions(for controlEvents: UIControlEvents) {
//        if controlEvents == .touchUpInside {
//            toggleState()
//        }
//        super.sendActions(for: controlEvents)
//    }
//    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = bounds.width/2
        layoutGradientLayer()
    }
    
  @objc open func toggleState() {
        if colorState == .hue {
            colorState = .grayscale
        }
        else {
            colorState = .hue
        }
        
        layoutGradientLayer()
    }
    
    private func layoutGradientLayer() {
        hueColorGradientLayer.frame = bounds
        grayColorGradientLayer.frame = bounds
        
        if colorState == .hue {
            // Display inverse gradients. (i.e. Gray is displayed when hue is active)
            grayColorGradientLayer.isHidden = false
            hueColorGradientLayer.isHidden = true
        }
        else {
            hueColorGradientLayer.isHidden = false
            grayColorGradientLayer.isHidden = true
        }
    }
    
}
