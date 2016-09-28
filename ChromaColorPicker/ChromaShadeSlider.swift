//
//  ChromaShadeSlider.swift
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

public class ChromaSliderTrackLayer: CALayer{
    public let gradient = CAGradientLayer()
    
    override public init() {
        super.init()
        gradient.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        self.addSublayer(gradient)
    }
    override init(layer: Any) {
        super.init(layer: layer)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public protocol ChromaShadeSliderDelegate {
    func shadeSliderChoseColor(slider: ChromaShadeSlider, color: UIColor)
}

public class ChromaShadeSlider: UIControl {
    public var currentValue: CGFloat = 0.0 //range of {-1,1}
    
    public let trackLayer = ChromaSliderTrackLayer()
    public let handleView = ChromaHandle()
    public var handleWidth: CGFloat{ return self.bounds.height }
    public var handleCenterX: CGFloat = 0.0
    public var delegate: ChromaShadeSliderDelegate?
    
    public var primaryColor = UIColor.gray{
        didSet{
            self.changeColorHue(to: currentColor)
            self.updateGradientTrack(for: primaryColor)
        }
    }
    /* The computed color of the primary color with shading based on the currentValue */
    public var currentColor: UIColor{
        get{
            if currentValue < 0 {//darken
                return primaryColor.darkerColor(amount: -currentValue)
            }
            else{ //lighten
                return primaryColor.lighterColor(amount: currentValue)
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        self.backgroundColor = nil
        handleCenterX = self.bounds.width/2
        
        trackLayer.backgroundColor = UIColor.blue.cgColor
        trackLayer.masksToBounds = true
        trackLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()] //disable implicit animations
        self.layer.addSublayer(trackLayer)
        
        handleView.color = UIColor.blue
        handleView.circleLayer.borderWidth = 3
        handleView.isUserInteractionEnabled = false //disable interaction for touch events
        self.layer.addSublayer(handleView.layer)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapRecognized))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        
        self.layoutLayerFrames()
        self.changeColorHue(to: currentColor)
        self.updateGradientTrack(for: primaryColor)
    }
    
    override public func didMoveToSuperview() {
        self.updateGradientTrack(for: primaryColor)
    }
    
    public func layoutLayerFrames(){
        trackLayer.frame = self.bounds.insetBy(dx: handleWidth/2, dy: self.bounds.height/4) //Make half the height of the bounds
        trackLayer.cornerRadius = trackLayer.bounds.height/2
        
        self.updateGradientTrack(for: primaryColor)
        self.updateHandleLocation()
        self.layoutHandleFrame()
    }
    
    //Lays out handle according to the currentValue on slider
    public func layoutHandleFrame(){
        handleView.frame = CGRect(x: handleCenterX - handleWidth/2, y: self.bounds.height/2 - handleWidth/2, width: handleWidth, height: handleWidth)
    }
    
    public func changeColorHue(to newColor: UIColor){
        handleView.color = newColor
        if currentValue != 0 { //Don't call delegate if the color hasnt changed
            self.delegate?.shadeSliderChoseColor(slider: self, color: newColor)
        }
    }
    
    public func updateGradientTrack(for color: UIColor){
        trackLayer.gradient.frame = trackLayer.bounds
        trackLayer.gradient.startPoint = CGPoint(x: 0, y: 0.5)
        trackLayer.gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        //Gradient is for astetics - the slider is actually between black and white
        trackLayer.gradient.colors = [color.darkerColor(amount: 0.65).cgColor, color.cgColor, color.lighterColor(amount: 0.65).cgColor]
    }
    
    //Updates handeles location based on currentValue
    public func updateHandleLocation(){
        handleCenterX = (currentValue+1)/2 * (bounds.width - handleView.bounds.width) +  handleView.bounds.width/2
        handleView.color = currentColor
        self.layoutHandleFrame()
    }
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        if handleView.frame.contains(location) {
            return true
        }
        return false
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        //Update for center point
        handleCenterX = location.x
        handleCenterX = fittedValueInBounds(value: handleCenterX) //adjust value to fit in bounds if needed
        
        
        //Update current value
        currentValue = ((handleCenterX - handleWidth/2)/trackLayer.bounds.width - 0.5) * 2  //find current value between {-1,1} of the slider
        
        //Update handle color
        self.changeColorHue(to: currentColor)
        
        //Update layers frames
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.layoutHandleFrame()
        CATransaction.commit()
        
        self.sendActions(for: .valueChanged)
        return true
    }
    
    func doubleTapRecognized(recognizer: UITapGestureRecognizer){
        let location = recognizer.location(in: self)
        guard handleView.frame.contains(location) else {
            return
        }
        //Tap is on handle
        
        resetHandleToCenter()
    }
    
    public func resetHandleToCenter(){
        
        handleCenterX = self.bounds.width/2
        self.layoutHandleFrame()
        handleView.color = primaryColor
        currentValue = 0.0
        
        self.sendActions(for: .valueChanged)
        self.delegate?.shadeSliderChoseColor(slider: self, color: currentColor)
    }
    
    /* Helper Methods */
    //Returns a CGFloat for the highest/lowest possble value such that it is inside the views bounds
    private func fittedValueInBounds(value: CGFloat) -> CGFloat {
        return min(max(value, trackLayer.frame.minX), trackLayer.frame.maxX)
    }
    
}




