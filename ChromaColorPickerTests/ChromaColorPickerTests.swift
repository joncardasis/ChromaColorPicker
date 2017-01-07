//
//  ChromaColorPickerTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 12/30/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//

import EarlGrey
import XCTest
@testable import ChromaColorPicker_Demo

let EarlGrey = EarlGreyImpl.invoked(fromFile: #file, lineNumber: #line)!

class ChromaColorPickerTests: XCTestCase {
    
    var viewController: ViewController!
    var colorPicker: ChromaColorPicker!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateInitialViewController() as! ViewController
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        XCTAssertNotNil(viewController.colorPicker)
        viewController.colorPicker.isAccessibilityElement = true //set for earlgrey
        viewController.colorPicker.accessibilityLabel = "color_picker"
        colorPicker = viewController.colorPicker
    }
    
    func testAdjustToColor() {
        let testColor = UIColor(red: 155/255.0, green: 107/255.0, blue: 255/255.0, alpha: 1)
        colorPicker.adjustToColor(testColor)
        let pickerColor = colorPicker.currentColor
        
        XCTAssertEqual(pickerColor.description, testColor.description, "Picker did not properly adjust to color") //Compare description because of fractional differences
        
        XCTAssertEqual(colorPicker.hexLabel.text, "#\(testColor.hexCode)", "Picker displays incorrect Hex Value")
    }
    
    func testButtonDelegateRecieved() {
        let pickerMatch = grey_allOfMatchers([ grey_accessibilityLabel("color_picker") ])
            
        let colorOnTap = colorPicker.currentColor
        EarlGrey.selectElement(with: pickerMatch)
                .perform(grey_tap())
            
        XCTAssertTrue(viewController.colorDisplayView.backgroundColor!.description == colorOnTap.description)
    }
    
    
}
