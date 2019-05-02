//
//  ChromaColorPickerTest.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 2/3/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class ChromaColorPickerTests: XCTestCase {
    var subject: ChromaColorPicker!
    
    override func setUp() {
        subject = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    func testConnectingSliderAddsEventTarget() {
        // Given
        let slider = ChromaBrightnessSlider(frame: .zero)
        
        // When
        subject.connect(slider)
        
        // Then
        XCTAssertEqual(subject.brightnessSlider, slider)
        XCTAssertEqual(slider.allTargets.first, subject)
        XCTAssertTrue(slider.allControlEvents.contains(.valueChanged))
    }
    
    func testOldBrightnessSliderRemovesTargetWhenInstanceChanges() {
        // Given
        let slider1 = ChromaBrightnessSlider(frame: .zero)
        let slider2 = ChromaBrightnessSlider(frame: .zero)
        
        // When
        subject.connect(slider1)
        subject.connect(slider2)
        
        // Then
        XCTAssertEqual(slider1.allTargets.count, 0)
    }
}
