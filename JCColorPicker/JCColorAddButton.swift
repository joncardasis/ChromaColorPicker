//
//  JCColorAddButton.swift
//
//  Created by Jonathan Cardasis on 5/16/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//

import UIKit

class JCColorAddButton: UIButton {
    var color = UIColor.grayColor(){
        didSet{
            if let layer = circleLayer{
                layer.fillColor = color.CGColor
                layer.strokeColor = color.darkerColor(0.075).CGColor
            }
        }
    }
    override var frame: CGRect{ //update on frame change
        didSet{
            self.layoutCircleLayer()
            self.layoutPlusIconLayer()
        }
    }
    var circleLayer: CAShapeLayer?
    var plusIconLayer: CAShapeLayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createGraphics()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createGraphics()
    }
    
    func createGraphics(){
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
    
    func layoutCircleLayer(){
        if let layer = circleLayer{
            layer.path = UIBezierPath(ovalInRect: self.bounds).CGPath
            layer.lineWidth = frame.width * 0.04 //4 for size (100,100)
        }
    }
    
    func layoutPlusIconLayer(){
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