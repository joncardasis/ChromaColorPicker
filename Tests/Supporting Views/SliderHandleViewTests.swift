//
//  SliderHandleViewTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 5/13/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class SliderHandleViewTests: XCTestCase {
    
    func testSettingHandleColorUpdatesHandleLayer() {
        // Given
        let subject = SliderHandleView()
        let layer = handleLayer(for: subject)
        let expectedColor: UIColor = .purple
        
        // When
        subject.handleColor = expectedColor
        
        // Then
        XCTAssertEqual(layer.fillColor!, expectedColor.cgColor)
    }
    
    func testSettingBorderColorUpdatesHandleLayer() {
        // Given
        let subject = SliderHandleView()
        let layer = handleLayer(for: subject)
        let expectedColor: UIColor = .purple
        
        // When
        subject.borderColor = expectedColor
        
        // Then
        XCTAssertEqual(layer.strokeColor!, expectedColor.cgColor);
    }
    
    func testSettingBorderWidthUpdatesHandleLayer() {
        // Given
        let subject = SliderHandleView()
        let layer = handleLayer(for: subject)
        let expectedWidth: CGFloat = 12.0
        
        // When
        subject.borderWidth = expectedWidth
        
        // Then
        XCTAssertEqual(layer.lineWidth, expectedWidth);
    }
}

/// Return the internal cashape sublayer for the provided view.
fileprivate func handleLayer(for handleView: SliderHandleView) -> CAShapeLayer {
    return handleView.layer.sublayers!.first(where: { $0 is CAShapeLayer }) as! CAShapeLayer
}

