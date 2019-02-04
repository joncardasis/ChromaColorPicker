//
//  ChromaAddButton.swift
//
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
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

open class ChromaAddButton: UIButton {
    open var color = UIColor.gray{
        didSet{
            if let layer = circleLayer{
                layer.fillColor = color.cgColor
                layer.strokeColor = color.darkerColor(0.075).cgColor
            }
        }
    }
    override open var frame: CGRect{ //update on frame change
        didSet{
            self.layoutCircleLayer()
            self.layoutPlusIconLayer()
        }
    }
    open var circleLayer: CAShapeLayer?
    open var plusIconLayer: CAShapeLayer?
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.createGraphics()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createGraphics()
    }
    
    open func createGraphics(){
        circleLayer = CAShapeLayer()
        self.layoutCircleLayer()
        circleLayer!.fillColor = color.cgColor
        self.layer.addSublayer(circleLayer!)
        
        /* Create Plus Icon */
        let plusPath = UIBezierPath()
        plusPath.move(to: CGPoint(x: self.bounds.width/2 - self.bounds.width/8, y: self.bounds.height/2))
        plusPath.addLine(to: CGPoint(x: self.bounds.width/2 + self.bounds.width/8, y: self.bounds.height/2))
        plusPath.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2 + self.bounds.height/8))
        plusPath.addLine(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2 - self.bounds.height/8))
        
        plusIconLayer = CAShapeLayer()
        self.layoutPlusIconLayer()
        plusIconLayer!.strokeColor = UIColor.white.cgColor
        self.layer.addSublayer(plusIconLayer!)
    }
    
    open func layoutCircleLayer(){
        if let layer = circleLayer{
            layer.path = UIBezierPath(ovalIn: self.bounds).cgPath
            layer.lineWidth = frame.width * 0.04 //4 for size (100,100)
        }
    }
    
    open func layoutPlusIconLayer(){
        if let layer = plusIconLayer{
            let plusPath = UIBezierPath()
            plusPath.move(to: CGPoint(x: self.bounds.width/2 - self.bounds.width/8, y: self.bounds.height/2))
            plusPath.addLine(to: CGPoint(x: self.bounds.width/2 + self.bounds.width/8, y: self.bounds.height/2))
            plusPath.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2 + self.bounds.height/8))
            plusPath.addLine(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2 - self.bounds.height/8))
            
            layer.path = plusPath.cgPath
            layer.lineWidth = frame.width * 0.03
        }
    }
    
}
