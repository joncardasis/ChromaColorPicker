//
//  ViewController.swift
//  ChromaColorPicker-Demo
//
//  Created by Cardasis, Jonathan (J.) on 8/11/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorDisplayView: UIView!
    var colorPicker: ChromaColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calculate relative size and origin in bounds
        let pickerSize = CGSize(width: view.bounds.width*0.8, height: view.bounds.width*0.8)
        let pickerOrigin = CGPoint(x: CGRectGetMidX(view.bounds) - pickerSize.width/2, y: CGRectGetMidY(view.bounds) - pickerSize.height/2)
        
        //Create Color Picker
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.delegate = self
        
        //Customize the view (optional)
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float(M_PI)
        
        colorPicker.hexLabel.textColor = UIColor.whiteColor()
        
        //Don't want an element like the shade slider? Just hide it:
        //colorPicker.shadeSlider.hidden = true
        
        self.view.addSubview(colorPicker)
    }
}

extension ViewController: ChromaColorPickerDelegate{
    func colorPickerDidChooseColor(colorPicker: ChromaColorPicker, color: UIColor) {

        //Set color for the display view
        colorDisplayView.backgroundColor = color
        
        //Perform zesty animation
        UIView.animateWithDuration(0.2,
                animations: {
                    self.colorDisplayView.transform = CGAffineTransformMakeScale(1.05, 1.05)
                }) { (done) in
                UIView.animateWithDuration(0.2, animations: { 
                    self.colorDisplayView.transform = CGAffineTransformIdentity
                })
        }
    }
}

