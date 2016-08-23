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

public class ChromaAddButton: UIButton {
    public var color = UIColor.grayColor(){
        didSet{
            if let layer = circleLayer{
                layer.fillColor = color.CGColor
                layer.strokeColor = color.darkerColor(0.075).CGColor
            }
        }
    }
    override public var frame: CGRect{ //update on frame change
        didSet{
            self.layoutCircleLayer()
            self.layoutPlusIconLayer()
        }
    }
    public var circleLayer: CAShapeLayer?
    public var plusIconLayer: CAShapeLayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createGraphics()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createGraphics()
    }
    
    public func createGraphics(){
        circleLayer = CAShapeLayer()
        self.layoutCircleLayer()
        circleLayer!.fillColor = color.CGColor
        self.layer.addSublayer(circleLayer!)
        
        /* Create Plus Icon */
        let plusPath = UIBezierPath()
        plusPath.moveToPoint(CGPointMake(self.bounds.width/2 - self.bounds.width/8, self.bounds.height/2))
        plusPath.addLineToPoint(CGPointMake(self.bounds.width/2 + self.bounds.width/8, self.bounds.height/2))
        plusPath.moveToPoint(CGPointMake(self.bounds.width/2, self.bounds.height/2 + self.bounds.height/8))
        plusPath.addLineToPoint(CGPointMake(self.bounds.width/2, self.bounds.height/2 - self.bounds.height/8))
        
        plusIconLayer = CAShapeLayer()
        self.layoutPlusIconLayer()
        plusIconLayer!.strokeColor = UIColor.whiteColor().CGColor
        self.layer.addSublayer(plusIconLayer!)
    }
    
    public func layoutCircleLayer(){
        if let layer = circleLayer{
            layer.path = UIBezierPath(ovalInRect: self.bounds).CGPath
            layer.lineWidth = frame.width * 0.04 //4 for size (100,100)
        }
    }
    
    public func layoutPlusIconLayer(){
        if let layer = plusIconLayer{
            let plusPath = UIBezierPath()
            plusPath.moveToPoint(CGPointMake(self.bounds.width/2 - self.bounds.width/8, self.bounds.height/2))
            plusPath.addLineToPoint(CGPointMake(self.bounds.width/2 + self.bounds.width/8, self.bounds.height/2))
            plusPath.moveToPoint(CGPointMake(self.bounds.width/2, self.bounds.height/2 + self.bounds.height/8))
            plusPath.addLineToPoint(CGPointMake(self.bounds.width/2, self.bounds.height/2 - self.bounds.height/8))
            
            layer.path = plusPath.CGPath
            layer.lineWidth = frame.width * 0.03
        }
    }
    
}