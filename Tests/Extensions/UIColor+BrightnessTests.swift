//
//  UIColor+BrightnessTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 5/2/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class UIColor_BrightnessTests: XCTestCase {

    func testWithBrightnessReturnsNewInstanceWithNewBrightness() {
        // Given
        let color: UIColor = UIColor(hue: 25, saturation: 0.65, brightness: 0, alpha: 0.73)
        let newBrightness: CGFloat = 1.0
        
        // When
        let newColor = color.withBrightness(newBrightness)
        
        // Then
        let expectedValues = color.hsbaValues
        let actualValues = newColor.hsbaValues
        
        XCTAssertNotEqual(color, newColor)
        XCTAssertEqual(expectedValues.hue, actualValues.hue)
        XCTAssertEqual(expectedValues.saturation, actualValues.saturation)
        XCTAssertEqual(actualValues.brightness, newBrightness)
        XCTAssertEqual(expectedValues.alpha, actualValues.alpha)
    }

    func testBrightnessReturnsZeroForBlack() {
        // Given
        let color: UIColor = .black
        
        // When, Then
        XCTAssertEqual(color.brightness, 0)
    }
    
    func testBrightnessReturnsOneForWhite() {
        // Given
        let color: UIColor = .white
        
        // When, Then
        XCTAssertEqual(color.brightness, 1)
    }
    
    func testBrightnessReturnsCustomColorBrightness() {
        // Given
        let color: UIColor = UIColor(hue: 25, saturation: 1, brightness: 0.36, alpha: 1)
        
        // When, Then
        XCTAssertEqual(color.brightness, 0.36)
    }
}
