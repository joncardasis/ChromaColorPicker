//
//  UIColor+UtilsTests.swift
//  ChromaColorPicker
//
//  Created by Jonathan Cardasis on 11/8/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class UIColor_UtilsTests: XCTestCase {

    func testLightnessReturns1ForWhite() {
        XCTAssertEqual(UIColor.white.lightness, 1.0, accuracy: 0.001)
    }
    
    func testLightnessReturns0ForBlack() {
        XCTAssertEqual(UIColor.black.lightness, 0.0, accuracy: 0.001)
    }
    
    func testLightnessReturnsCorrectLightnessForYellow() {
        XCTAssertEqual(UIColor.yellow.lightness, 0.886, accuracy: 0.001)
    }
    
    func testLightnessReturnsCorrectLightnessForBlue() {
        XCTAssertEqual(UIColor.blue.lightness, 0.114, accuracy: 0.001)
    }
    
    func testBlueIsNotLight() {
        XCTAssertFalse(UIColor.blue.isLight)
    }
    
    func testRedIsNotLight() {
        XCTAssertFalse(UIColor.red.isLight)
    }
    
    func testPurpleIsNotLight() {
        XCTAssertFalse(UIColor.purple.isLight)
    }
    
    func tesBlackIsNotLight() {
        XCTAssertFalse(UIColor.black.isLight)
    }
    
    func testWhiteIsLight() {
        XCTAssertTrue(UIColor.white.isLight)
    }
    
    func testGreenIsLight() {
        XCTAssertTrue(UIColor.green.isLight)
    }
    
    func testOrangeIsLight() {
        XCTAssertTrue(UIColor.orange.isLight)
    }
    
    func testYellowIsLight() {
        XCTAssertTrue(UIColor.yellow.isLight)
    }
}
