//
//  ChromaColorHandleTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 5/13/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class ChromaColorHandleTests: XCTestCase {
    
    func testSettingAcessoryImageMakesAccessoryViewUIImageView() {
        // Given
        let subject = ChromaColorHandle()
        
        // When
        subject.accessoryImage = UIImage()
        
        // Then
        XCTAssertNotNil(subject.accessoryView)
        XCTAssertTrue(subject.accessoryView is UIImageView)
    }
    
    func testSettingAccessoryImageMakesImageViewAspectFit() {
        // Given
        let subject = ChromaColorHandle()
        
        // When
        subject.accessoryImage = UIImage()
        
        // Then
        XCTAssertEqual(subject.accessoryView!.contentMode, .scaleAspectFit)
    }

    func testSettingAccessoryViewOverridesImage() {
        // Given
        let subject = ChromaColorHandle()
        subject.accessoryImage = UIImage()
        let view = UIView()
        
        // When
        subject.accessoryView = view
        
        // Then
        XCTAssertEqual(subject.accessoryView, view)
    }

}
