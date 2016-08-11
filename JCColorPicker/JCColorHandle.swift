//
//  JCColorHandle.swift
//
//  Created by Jonathan Cardasis on 5/16/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//

import UIKit

class JCColorHandle: UIView {
    var color = UIColor.blackColor() {
        didSet{
            circleLayer.fillColor = color.CGColor
        }
    }
    override var frame: CGRect{
        didSet { self.layoutCircleLayer() }
    }
    var circleLayer = CAShapeLayer()
    
    var shadowOffset: CGSize?{
        set{
            if let offset = newValue {
                circleLayer.shadowColor = UIColor.blackColor().CGColor
                circleLayer.shadowRadius = 3
                circleLayer.shadowOpacity = 0.3
                circleLayer.shadowOffset = offset
            }
        }
        get{
            return circleLayer.shadowOffset
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        
        /* Add Shape Layer */
        //circleLayer.shouldRasterize = true
        self.layoutCircleLayer()
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        circleLayer.fillColor = color.CGColor
        
        self.layer.addSublayer(circleLayer)
    }
    
    func layoutCircleLayer(){
        circleLayer.path = UIBezierPath(ovalInRect: self.bounds).CGPath
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        circleLayer.lineWidth = frame.width/8.75 //4
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
