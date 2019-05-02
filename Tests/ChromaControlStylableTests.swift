//
//  ChromaControlStylableTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 5/2/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class ChromaControlStyableTests: XCTestCase {
    
    func testUIViewShadowPropertiesShouldReturnBlackColor() {
        // Given
        let view = TestView()
        
        // When
        let shadowProps = view.shadowProperties(forHeight: 120)
        
        // Then
        XCTAssertEqual(shadowProps.color, UIColor.black.cgColor)
    }
    
    func testUIViewShadowPropertiesOpacity() {
        // Given
        let view = TestView()
        
        // When
        let shadowProps = view.shadowProperties(forHeight: 120)
        
        // Then
        XCTAssertEqual(shadowProps.opacity, 0.35)
    }
    
    func testUIViewShadowPropertiesRadius() {
        // Given
        let view = TestView()
        
        // When
        let shadowProps = view.shadowProperties(forHeight: 120)
        
        // Then
        XCTAssertEqual(shadowProps.radius, 4)
    }
    
    func testUIViewShadowPropertiesOffsetHeightShouldBeOnePercentOfProvidedHeight() {
        // Given
        let view = TestView()
        
        // When
        let shadowProps = view.shadowProperties(forHeight: 1200)
        
        // Then
        XCTAssertEqual(shadowProps.offset.width, 0)
        XCTAssertEqual(shadowProps.offset.height, 12)
    }
    
}

private class TestView: UIView, ChromaControlStylable {
    var borderWidth: CGFloat = 2.0
    var borderColor: UIColor = UIColor.green
    var showsShadow: Bool = true
    func updateShadowIfNeeded() {}
}
