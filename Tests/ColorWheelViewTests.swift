//
//  ColorWheelTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 4/11/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class ColorWheelViewTests: XCTestCase {
    
    var subject: ColorWheelView!
    
    override func setUp() {
        subject = ColorWheelView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    func testBackgroundIsClear() {
        XCTAssertEqual(subject.backgroundColor, .clear)
    }
    
    func testImageViewUsesAspectFit() {
        XCTAssertEqual(subject.imageView.contentMode, .scaleAspectFit)
    }
    
    func testLayerCornerRadiusUpdatesDuringLayout() {
        // Given
        subject.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
        
        // When
        subject.layoutSubviews()
        
        // Then
        XCTAssertEqual(subject.layer.cornerRadius, subject.radius)
    }
    
    func testRadiusIfHalfOfWidthWhenWidthIsLargestDimension() {
        // Given, When
        subject.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
        
        // Then
        XCTAssertEqual(subject.radius, 100)
    }
    
    func testRadiusIfHalfOfHeightWhenHeightIsLargestDimension() {
        // Given, When
        subject.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
        
        // Then
        XCTAssertEqual(subject.radius, 100)
    }
    
    func testColorWheelImageIsGeneratedEveryLayoutCycle() {
        // Given
        let width: CGFloat = 200.0
        let expectedFinalSize = CGSize(width: width, height: width)
        
        // When
        subject.layoutSubviews()
        let firstImage = subject.imageView.image!
        subject.frame = CGRect(x: 0, y: 0, width: width, height: width)
        subject.layoutSubviews()
        let secondImage = subject.imageView.image!
        
        // Then
        XCTAssertNotEqual(firstImage, secondImage)
        XCTAssertEqual(secondImage.size, expectedFinalSize)
    }
    
    func testPixelColorShouldReturnNilForPointOutsideBounds() {
        // Given, When
        let testPoint = CGPoint(x: -100, y: -100)
        // Then
        XCTAssertNil(subject.pixelColor(at: testPoint))
    }
    
    func testPixelColorShouldReturnNilForPointInBoundsButOutsideRadius() {
        // Given, When
        let testPoint = CGPoint(x: 0, y: 0)
        // Then
        XCTAssertNil(subject.pixelColor(at: testPoint))
    }
    
    func testPixelColorShouldReturnNilForPointOnBorder() {
        // Given
        subject.layer.borderWidth = 20
        subject.layer.borderColor = UIColor.white.cgColor
        
        // When
        let testPoint = CGPoint(x: subject.bounds.width - 10, y: subject.frame.midY)
        
        // Then
        XCTAssertNil(subject.pixelColor(at: testPoint))
    }
    
    func testPixelColorShouldBeRedAtMaxXMidY() {
        // Given
        let size = subject.frame.size
        let testPoint = CGPoint(x: size.width, y: size.height / 2.0)
        let (expectedRedValue, _, _) = UIColor.red.rgbValues
        
        let vc = UIViewController()
        vc.view.addSubview(subject)
        vc.beginAppearanceTransition(true, animated: false)
        vc.endAppearanceTransition()
        subject.layoutSubviews()
        
        // When
        let (actualRedValue, _, _) = subject.pixelColor(at: testPoint)!.rgbValues
        
        // Then
        XCTAssertEqual(actualRedValue, expectedRedValue, accuracy: 0.001)
    }
    
    func testPixelColorShouldBeCyanAtMinXMidY() {
        // Given
        let size = subject.frame.size
        let testPoint = CGPoint(x: 0, y: size.height / 2.0)
        let expectedColorValues = UIColor.cyan.rgbValues
        
        let vc = UIViewController()
        vc.view.addSubview(subject)
        vc.beginAppearanceTransition(true, animated: false)
        vc.endAppearanceTransition()
        subject.layoutSubviews()
        
        // When
        let actualColorValues = subject.pixelColor(at: testPoint)!.rgbValues
        
        // Then
        XCTAssertEqual(actualColorValues.red, expectedColorValues.red, accuracy: 0.005)
        XCTAssertEqual(actualColorValues.green, expectedColorValues.green, accuracy: 0.005)
        XCTAssertEqual(actualColorValues.blue, expectedColorValues.blue, accuracy: 0.005)
    }
    
    func testPixelColorShouldBeWhiteAtTheCenter() {
        // Given
        let size = subject.frame.size
        let testPoint = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let expectedColorValues = UIColor.white.rgbValues
        
        let vc = UIViewController()
        vc.view.addSubview(subject)
        vc.beginAppearanceTransition(true, animated: false)
        vc.endAppearanceTransition()
        subject.layoutSubviews()
        
        // When
        let actualColorValues = subject.pixelColor(at: testPoint)!.rgbValues
        
        // Then
        XCTAssertEqual(actualColorValues.red, expectedColorValues.red, accuracy: 0.005)
        XCTAssertEqual(actualColorValues.green, expectedColorValues.green, accuracy: 0.005)
        XCTAssertEqual(actualColorValues.blue, expectedColorValues.blue, accuracy: 0.005)
    }
}
