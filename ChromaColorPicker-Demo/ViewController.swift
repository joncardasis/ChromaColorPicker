//
//  ViewController.swift
//  ChromaColorPicker-Demo
//
//  Created by Cardasis, Jonathan (J.) on 8/11/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//

import UIKit
import ChromaColorPicker

class ViewController: UIViewController {
    
    @IBOutlet weak var colorDisplayView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var colorPicker: ChromaColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftButton.alpha = 0.0
        self.rightButton.alpha = 0.0
        
        /* Calculate relative size and origin in bounds */
        let pickerSize = CGSize(width: view.bounds.width*0.8, height: view.bounds.width*0.8)
        let pickerOrigin = CGPoint(x: view.bounds.midX - pickerSize.width/2, y: view.bounds.midY - pickerSize.height/2)
        
        /* Create Color Picker */
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.delegate = self
        
        /* Customize the view (optional) */
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float.pi
        
        /* Customize for grayscale (optional) */
        colorPicker.supportsShadesOfGray = true // false by default
        //colorPicker.colorToggleButton.grayColorGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor] // You can also override gradient colors
        
        
        colorPicker.hexLabel.textColor = UIColor.white
        
        colorPicker.addButton.plusIconIsHidden = true
        
        /* Don't want an element like the shade slider? Just hide it: */
        //colorPicker.shadeSlider.hidden = true
        
        self.view.addSubview(colorPicker)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.shadeSliderDidStartPan(_:)), name: ChromaShadeSlider.didStartPan, object: nil)
        nc.addObserver(self, selector: #selector(self.shadeSliderDidEndPan(_:)), name: ChromaShadeSlider.didEndPan, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let f: CGFloat = 16/255.0
        let color = UIColor(red: f, green: f, blue: f, alpha: 1.0)
        self.colorPicker.adjustToColor(color)
        if self.colorPicker.currentColor.hasGrayHex {
            print("setting gray color, hex: \(self.colorPicker.currentColor.hexCode)")
            self.colorPicker.colorToggleButton.sendActions(for: .touchUpInside)
        }
    }
    
    // MARK: - Utilities
    
    func colorOf(_ hex: Int) -> UIColor {
        let red = CGFloat((hex >> 16) & 0xff) / CGFloat(255)
        let green = CGFloat((hex >> 8) & 0xff) / CGFloat(255)
        let blue = CGFloat((hex >> 0) & 0xff) / CGFloat(255)
        return UIColor(red:red, green:green, blue:blue, alpha: 1.0)
    }
    
    // MARK: - User Interactions
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        let color = self.colorOf(0xA1F000)
        self.colorPicker.adjustToColor(color)
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        let color = self.colorOf(0xA9A9A9)
        self.colorPicker.adjustToColor(color)
    }
    
    // MARK: - Event observers
    
    @objc func shadeSliderDidStartPan(_ notification: Notification) {
        print("shade slider did start pan")
    }
    
    @objc func shadeSliderDidEndPan(_ notification: Notification) {
        print("shade slider did end pan")
    }
}

extension ViewController: ChromaColorPickerDelegate{
    func colorPickerDidUpdateColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        //Set color for the display view
        colorDisplayView.backgroundColor = color
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        //Set color for the display view
        colorDisplayView.backgroundColor = color
        
        //Perform zesty animation
        UIView.animate(withDuration: 0.2,
                animations: {
                    self.colorDisplayView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }, completion: { (done) in
                UIView.animate(withDuration: 0.2, animations: { 
                    self.colorDisplayView.transform = CGAffineTransform.identity
                })
        }) 
    }
}

