//
//  ChromaColorPicker.swift
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

public protocol ChromaColorPickerDelegate {
    /* Called when the user tapps the add button in the center */
    func colorPickerDidChooseColor(colorPicker: ChromaColorPicker, color: UIColor)
}

public class ChromaColorPicker: UIControl {
    public var hexLabel: UILabel!
    public var shadeSlider: ChromaShadeSlider!
    public var handleView: ChromaHandle!
    public var handleLine: CAShapeLayer!
    public var addButton: ChromaAddButton!
    
    public var currentColor = UIColor()
    public var delegate: ChromaColorPickerDelegate?
    public var currentAngle: Float = 0
    private (set) var radius: CGFloat = 0
    public var stroke: CGFloat = 1
    public var padding: CGFloat = 15
    public var handleSize: CGSize{
        get{ return CGSizeMake(self.bounds.width * 0.1, self.bounds.height * 0.1) }
    }
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        self.backgroundColor = UIColor.clearColor()
        
        let minDimension = min(self.bounds.size.width, self.bounds.size.height)
        radius = minDimension/2 - handleSize.width/2
        
        /* Setup Handle */
        handleView = ChromaHandle(frame: CGRectMake(0,0, handleSize.width, handleSize.height))
        handleView.shadowOffset = CGSizeMake(0,2)
        
        /* Setup pan gesture for handle */
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ChromaColorPicker.handleWasMoved(_:)))
        handleView.addGestureRecognizer(panRecognizer)
        
        /* Setup Add Button */
        addButton = ChromaAddButton()
        self.layoutAddButton() //layout frame
        addButton.addTarget(self, action: #selector(ChromaColorPicker.addButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        /* Setup Handle Line */
        handleLine = CAShapeLayer()
        handleLine.lineWidth = 2
        handleLine.strokeColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        
        /* Setup Color Hex Label */
        hexLabel = UILabel()
        self.layoutHexLabel() //layout frame
        hexLabel.layer.cornerRadius = 2
        hexLabel.adjustsFontSizeToFitWidth = true
        hexLabel.textAlignment = .Center
        hexLabel.textColor = UIColor(red: 51/255.0, green:51/255.0, blue: 51/255.0, alpha: 0.65)
        
        /* Setup Shade Slider */
        shadeSlider = ChromaShadeSlider()
        shadeSlider.delegate = self
        self.layoutShadeSlider()
        
        
        /* Add components to view */
        self.layer.addSublayer(handleLine)
        self.addSubview(shadeSlider)
        self.addSubview(hexLabel)
        self.addSubview(handleView)
        self.addSubview(addButton)
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        /* Get the starting color */
        currentColor = colorOnWheelFromAngle(currentAngle)
        handleView.center = positionOnWheelFromAngle(currentAngle) //update pos for angle
        self.layoutHandleLine() //layout the lines positioning
        
        handleView.color = currentColor
        addButton.color = currentColor
        shadeSlider.primaryColor = currentColor
        self.updateHexLabel() //update for hex value
    }
    
    
    //MARK: - Handle Touches
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){
        //Overriden to prevent uicontrolevents being called from the super
    }
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        let touchPoint = touches.first!.locationInView(self)
        if CGRectContainsPoint(handleView.frame, touchPoint) {
            self.sendActionsForControlEvents(.TouchDown)
            
            /* Enlarge Animation */
            UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                self.handleView.transform = CGAffineTransformMakeScale(1.45, 1.45)
                }, completion: nil)
        }
    }
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Run this animation after a pan or here if touches are released
        if handleView.transform.d > 1 { //if scale is larger than 1 (already animated)
            self.executeHandleShrinkAnimation()
        }
    }
    
    func handleWasMoved(recognizer: UIPanGestureRecognizer) {
        switch(recognizer.state){

        case UIGestureRecognizerState.Changed:
            let touchPosition = recognizer.locationInView(self)
            self.moveHandleTowardPoint(touchPosition)
            self.sendActionsForControlEvents(.TouchDragInside)
            break
        
        case UIGestureRecognizerState.Ended:
            /* Shrink Animation */
            self.executeHandleShrinkAnimation()
            break
            
        default:
            break
        }
    }
    
    private func executeHandleShrinkAnimation(){
        self.sendActionsForControlEvents(.TouchUpInside)
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            self.handleView.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }
    
    private func moveHandleTowardPoint(point: CGPoint){
        currentAngle = angleToCenterFromPoint(point) //Find the angle of point to the frames center
        
        //Layout Handle
        self.layoutHandle()
        
        //Layout Line
        self.layoutHandleLine()
        
        //Update color for shade slider
        shadeSlider.primaryColor = handleView.color//currentColor
        
        //Update color for add button if a shade isnt selected
        if shadeSlider.currentValue == 0 {
            self.updateCurrentColor(shadeSlider.currentColor)
        }
        
        //Update Text Field display value
        self.updateHexLabel()
    }
    
    
    func addButtonPressed(sender: ChromaAddButton){
        //Do a 'bob' animation
        UIView.animateWithDuration(0.2,
                delay: 0,
                options: .CurveEaseIn,
                animations: { () -> Void in
                    sender.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: { (done) -> Void in
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        sender.transform = CGAffineTransformMakeScale(1, 1)
                    })
                })
        
        delegate?.colorPickerDidChooseColor(self, color: sender.color) //Delegate call
    }
    
    
    //MARK: - Drawing
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let ctx = UIGraphicsGetCurrentContext()
        drawRainbowCircle(in: ctx, outerRadius: radius - padding, innerRadius: radius - stroke - padding, resolution: 1)
    }
    
    /*
    Resolution should be between 0.1 and 1
    */
    func drawRainbowCircle(in context: CGContextRef?, outerRadius: CGFloat, innerRadius: CGFloat, resolution: Float){
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) //Move context to center
        
        let subdivisions:CGFloat = CGFloat(resolution * 512) //Max subdivisions of 512
        
        let innerHeight = (CGFloat(M_PI)*innerRadius)/subdivisions //height of the inner wall for each segment
        let outterHeight = (CGFloat(M_PI)*outerRadius)/subdivisions
        
        let segment = UIBezierPath()
        segment.moveToPoint(CGPointMake(innerRadius, -innerHeight/2))
        segment.addLineToPoint(CGPointMake(innerRadius, innerHeight/2))
        segment.addLineToPoint(CGPointMake(outerRadius, outterHeight/2))
        segment.addLineToPoint(CGPointMake(outerRadius, -outterHeight/2))
        segment.closePath()
        
        
        //Draw each segment and rotate around the center
        for i in 0 ..< Int(ceil(subdivisions)) {
            UIColor(hue: CGFloat(i)/subdivisions, saturation: 1, brightness: 1, alpha: 1).set()
            segment.fill()
            let lineTailSpace = CGFloat(M_PI*2)*outerRadius/subdivisions  //The amount of space between the tails of each segment
            segment.lineWidth = lineTailSpace //allows for seemless scaling
            segment.stroke()
            
            //Rotate to correct location
            let rotate = CGAffineTransformMakeRotation(-(CGFloat(M_PI*2)/subdivisions)) //rotates each segment
            segment.applyTransform(rotate)
        }
        
        CGContextTranslateCTM(context, -CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds)) //Move context back to original position
        CGContextRestoreGState(context)
    }
    
    
    //MARK: - Layout Updates
    /* re-layout view and all its subview and drawings */
    public func layout() {
        self.setNeedsDisplay() //mark view as dirty
        
        let minDimension = min(self.bounds.size.width, self.bounds.size.height)
        radius = minDimension/2 - handleSize.width/2 //create radius for new size
        
        self.layoutAddButton()
        
        //Update handle's size
        handleView.frame = CGRect(origin: .zero, size: handleSize)
        self.layoutHandle()
        
        //Ensure colors are updated
        self.updateCurrentColor(handleView.color)
        shadeSlider.primaryColor = handleView.color
        
        self.layoutShadeSlider()
        self.layoutHandleLine()
        self.layoutHexLabel()
    }
    
    public func layoutAddButton(){
        let addButtonSize = CGSize(width: self.bounds.width/5, height: self.bounds.height/5)
        addButton.frame = CGRect(x: CGRectGetMidX(self.bounds) - addButtonSize.width/2, y: CGRectGetMidY(self.bounds) - addButtonSize.height/2, width: addButtonSize.width, height: addButtonSize.height)
    }
    
    /*
    Update the handleView's position and color for the currentAngle
    */
    func layoutHandle(){
        let angle = currentAngle //Preserve value in case it changes
        let newPosition = positionOnWheelFromAngle(angle) //find the correct position on the color wheel
        
        //Update handle position
        handleView.center = newPosition
        
        //Update color for the movement
        handleView.color = colorOnWheelFromAngle(angle)
    }
    
    /*
    Updates the line view's position for the current angle
    Pre: dependant on addButtons position
    */
    func layoutHandleLine(){
        let linePath = UIBezierPath()
        linePath.moveToPoint(addButton.center)
        linePath.addLineToPoint(positionOnWheelFromAngle(currentAngle))
        handleLine.path = linePath.CGPath
    }
    
    /*
    Pre: dependant on addButtons position
    */
    func layoutHexLabel(){
        hexLabel.frame = CGRect(x: 0, y: 0, width: addButton.bounds.width*1.5, height: addButton.bounds.height/3)
        hexLabel.center = CGPointMake(CGRectGetMidX(self.bounds), (addButton.frame.origin.y + (padding + handleView.frame.height/2 + stroke/2))/1.75) //Divided by 1.75 not 2 to make it a bit lower
        hexLabel.font = UIFont(name: "Menlo-Regular", size: hexLabel.bounds.height)
    }
    
    /*
    Pre: dependant on radius
    */
    func layoutShadeSlider(){
        /* Calculate proper length for slider */
        let centerPoint = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        let insideRadius = radius - padding
        
        let pointLeft = CGPoint(x: centerPoint.x + insideRadius*CGFloat(cos(7*M_PI/6)), y: centerPoint.y - insideRadius*CGFloat(sin(7*M_PI/6)))
        let pointRight = CGPoint(x: centerPoint.x + insideRadius*CGFloat(cos(11*M_PI/6)), y: centerPoint.y - insideRadius*CGFloat(sin(11*M_PI/6)))
        let deltaX = pointRight.x - pointLeft.x //distance on circle between points at 7pi/6 and 11pi/6
        

        let sliderSize = CGSize(width: deltaX * 0.75, height: 0.08 * (bounds.height - padding*2))//bounds.height
        shadeSlider.frame = CGRect(x: bounds.midX - sliderSize.width/2, y: pointLeft.y - sliderSize.height/2, width: sliderSize.width, height: sliderSize.height)
        shadeSlider.handleCenterX = shadeSlider.bounds.width/2 //set handle starting position
        shadeSlider.layoutLayerFrames() //call sliders' layout function
    }
    
    func updateHexLabel(){
        hexLabel.text = "#" + currentColor.hexCode
    }
    
    func updateCurrentColor(color: UIColor){
        currentColor = color
        addButton.color = color
        self.sendActionsForControlEvents(.ValueChanged)
    }
    
    
    //MARK: - Helper Methods
    private func angleToCenterFromPoint(point: CGPoint) -> Float {
        let deltaX = Float(CGRectGetMidX(self.bounds) - point.x)
        let deltaY = Float(CGRectGetMidY(self.bounds) - point.y)
        let angle = atan2f(deltaX, deltaY)
        
        // Convert the angle to be between 0 and 2PI
        var adjustedAngle = angle + Float(M_PI/2)
        if (adjustedAngle < 0){ //Left side (Q2 and Q3)
            adjustedAngle += Float(M_PI*2)
        }

        return adjustedAngle
    }
    
    /* Find the angle relative to the center of the frame and uses the angle to find what color lies there */
    private func colorOnWheelFromAngle(angle: Float) -> UIColor {
        return UIColor(hue: CGFloat(Double(angle)/(2*M_PI)), saturation: 1, brightness: 1, alpha: 1)
    }
    
    /* Returns a position centered on the wheel for a given angle */
    private func positionOnWheelFromAngle(angle: Float) -> CGPoint{
        let buffer = padding + stroke/2
        return CGPoint(x: CGRectGetMidX(self.bounds) + ((radius - buffer) * CGFloat(cos(-angle))), y: CGRectGetMidY(self.bounds) + ((radius - buffer) * CGFloat(sin(-angle))))
    }
}


extension ChromaColorPicker: ChromaShadeSliderDelegate{
    public func shadeSliderChoseColor(slider: ChromaShadeSlider, color: UIColor) {
        self.updateCurrentColor(color) //update main controller for selected color
        self.updateHexLabel()
    }
}
