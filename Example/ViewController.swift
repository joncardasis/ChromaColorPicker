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
    
    let colorPicker = ChromaColorPicker()
    let brightnessSlider = ChromaBrightnessSlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorPicker()
        setupBrightnessSlider()
        setupColorPickerHandles()
    }
    
    private func setupColorPicker() {
        colorPicker.delegate = self
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPicker)
        
        let verticalOffset = -defaultColorPickerSize.height / 6
        
        NSLayoutConstraint.activate([
            colorPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: verticalOffset),
            colorPicker.widthAnchor.constraint(equalToConstant: defaultColorPickerSize.width),
            colorPicker.heightAnchor.constraint(equalToConstant: defaultColorPickerSize.height)
        ])
    }
    
    private func setupBrightnessSlider() {
        brightnessSlider.connect(to: colorPicker)
        
        // Style
        brightnessSlider.trackColor = UIColor.blue
        brightnessSlider.handle.borderWidth = 3.0 // Example of customizing the handle's properties.
        
        // Layout
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brightnessSlider)
        
        NSLayoutConstraint.activate([
            brightnessSlider.centerXAnchor.constraint(equalTo: colorPicker.centerXAnchor),
            brightnessSlider.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 28),
            brightnessSlider.widthAnchor.constraint(equalTo: colorPicker.widthAnchor, multiplier: 0.9),
            brightnessSlider.heightAnchor.constraint(equalTo: brightnessSlider.widthAnchor, multiplier: brightnessSliderWidthHeightRatio)
        ])
    }
    
    private func setupColorPickerHandles() {
        addHomeHandle()
        
        let peachColor = UIColor(red: 1, green: 203 / 255, blue: 164 / 255, alpha: 1)
        colorPicker.addHandle(at: peachColor)
    }
    
    private func addHomeHandle() {
        let homeHandle = colorPicker.addHandle(at: .blue)
        
        // Setup custom handle view with insets
        let customImageView = UIImageView(image: #imageLiteral(resourceName: "home").withRenderingMode(.alwaysTemplate))
        customImageView.contentMode = .scaleAspectFit
        customImageView.tintColor = .white
        homeHandle.accessoryView = customImageView
        homeHandle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
    }
}

extension ViewController: ChromaColorPickerDelegate {
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor) {
        colorDisplayView.backgroundColor = color
    }
    
}


private let defaultColorPickerSize = CGSize(width: 320, height: 320)
private let brightnessSliderWidthHeightRatio: CGFloat = 0.1
