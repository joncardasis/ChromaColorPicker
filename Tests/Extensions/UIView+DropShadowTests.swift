//
//  UIView+DropShadowTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 5/2/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class UIView_DropShadowTests: XCTestCase {

    var subject: UIView!
    
    override func setUp() {
        subject = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    func testApplyingDropShadowUpdatesLayerProperties() {
        // Given
        let color: UIColor = .blue
        let opacity: Float = 0.35
        let offset: CGSize = CGSize(width: 12, height: 10)
        let radius: CGFloat = 4.0
        
        // When
        subject.applyDropShadow(color: color, opacity: opacity, offset: offset, radius: radius)
        
        // Then
        XCTAssertFalse(subject.layer.masksToBounds)
        XCTAssertEqual(subject.layer.shadowColor, color.cgColor)
        XCTAssertEqual(subject.layer.shadowOpacity, opacity)
        XCTAssertEqual(subject.layer.shadowOffset, offset)
        XCTAssertEqual(subject.layer.shadowRadius, radius)
    }
    
    func testConvenienceMethodApplyDropShadowUpdatesTheSameLayerProperties() {
        // Given
        let color: UIColor = .blue
        let opacity: Float = 0.35
        let offset: CGSize = CGSize(width: 12, height: 10)
        let radius: CGFloat = 4.0
        
        let shadowProps = ShadowProperties(color: color.cgColor, opacity: opacity, offset: offset, radius: radius)
        
        // When
        subject.applyDropShadow(shadowProps)
        
        // Then
        XCTAssertFalse(subject.layer.masksToBounds)
        XCTAssertEqual(subject.layer.shadowColor, color.cgColor)
        XCTAssertEqual(subject.layer.shadowOpacity, opacity)
        XCTAssertEqual(subject.layer.shadowOffset, offset)
        XCTAssertEqual(subject.layer.shadowRadius, radius)
    }
    
    func testViewShouldNotClipToBoundsWhenDropShadowApplied() {
        // Given, When
        subject.applyDropShadow(defaultShadowProperties)
        
        // Then
        XCTAssertFalse(subject.clipsToBounds)
    }
    
    func testApplyingDropShadowShouldRasterizeLayer() {
        // Given, When
        subject.applyDropShadow(defaultShadowProperties)
        
        // Then
        XCTAssertTrue(subject.layer.shouldRasterize)
        XCTAssertEqual(subject.layer.rasterizationScale, UIScreen.main.scale)
    }
    
    func testDropShadowPropertiesReturnsCurrentShadowProps() {
        // Given, When
        subject.applyDropShadow(defaultShadowProperties)
        
        // Then
        XCTAssertEqual(subject.dropShadowProperties!.color, defaultShadowProperties.color)
        XCTAssertEqual(subject.dropShadowProperties!.opacity, defaultShadowProperties.opacity)
        XCTAssertEqual(subject.dropShadowProperties!.offset, defaultShadowProperties.offset)
        XCTAssertEqual(subject.dropShadowProperties!.radius, defaultShadowProperties.radius)
    }
    
    func testDropShadowPropertiesReturnsNilWhenNoShadowColor() {
        // Given, When
        subject.applyDropShadow(defaultShadowProperties)
        subject.layer.shadowColor = nil
        
        // Then
        XCTAssertNil(subject.dropShadowProperties)
    }
    
    func testRemoveDropShadowRemovesVisualShadowProperties() {
        // Given
        subject.applyDropShadow(defaultShadowProperties)
        
        // When
        subject.removeDropShadow()
        
        // Then
        XCTAssertNil(subject.layer.shadowColor)
        XCTAssertEqual(subject.layer.shadowOpacity, 0)
    }
    
}

private var defaultShadowProperties: ShadowProperties {
    return ShadowProperties(color: UIColor.black.cgColor, opacity: 0.5, offset: CGSize(width: 2, height: 4), radius: 4)
}
