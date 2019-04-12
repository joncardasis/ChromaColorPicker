//
//  ChromaHandle.swift
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

open class ChromaHandle: UIView {
    open var color = UIColor.black {
        didSet{
            circleLayer.fillColor = color.cgColor
        }
    }
    override open var frame: CGRect{
        didSet { self.layoutCircleLayer() }
    }
    open var circleLayer = CAShapeLayer()
    
    open var shadowOffset: CGSize?{
        set{
            if let offset = newValue {
                circleLayer.shadowColor = UIColor.black.cgColor
                circleLayer.shadowRadius = 3
                circleLayer.shadowOpacity = 0.3
                circleLayer.shadowOffset = offset
            }
        }
        get{
            return circleLayer.shadowOffset
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear
        
        /* Add Shape Layer */
        //circleLayer.shouldRasterize = true
        self.layoutCircleLayer()
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = color.cgColor
        
        self.layer.addSublayer(circleLayer)
    }
    
    open func layoutCircleLayer(){
        circleLayer.path = UIBezierPath(ovalIn: self.bounds).cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = frame.width/8.75 //4
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
