//
//  ChromaBrightnessSliderTests.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 9/8/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import XCTest
@testable import ChromaColorPicker

class ChromaBrightnessSliderTests: XCTestCase {
    
    // MARK: - Properties
    
    func testCurrentColorShouldReturnBlueWhenTrackColorIsBlueAndCurrentValueIsZero() {
        // Given
        let subject = ChromaBrightnessSlider()
        let expectedColor: UIColor = .blue
        
        // When
        subject.trackColor = .blue
        subject.currentValue = 0.0
        
        // Then
        XCTAssertEqual(subject.currentColor, expectedColor)
    }
    
    func testCurrentColorShouldReturnBlackWhenTrackColorIsAnyAndCurrentValueIsOne() {
        // Given
        let subject = ChromaBrightnessSlider()
        let expectedColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        // When
        subject.trackColor = .blue
        subject.currentValue = 1.0
        
        // Then
        XCTAssertEqual(subject.currentColor, expectedColor)
    }

    func testBorderWidthShouldUpdateSliderTrack() {
        // Given
        let subject = ChromaBrightnessSlider()
        let sliderTrack = subject.test_sliderTrackView
        let expectedBorderWidth: CGFloat = 11
        
        // When
        subject.borderWidth = expectedBorderWidth
        
        // Then
        XCTAssertEqual(sliderTrack.layer.borderWidth, expectedBorderWidth)
    }
    
    func testBorderColorShouldUpdateSliderTrack() {
        // Given
        let subject = ChromaBrightnessSlider()
        let sliderTrack = subject.test_sliderTrackView
        let expectedBorderColor: UIColor = .green
        
        // When
        subject.borderColor = expectedBorderColor
        
        // Then
        XCTAssertEqual(sliderTrack.layer.borderColor!, expectedBorderColor.cgColor)
    }
    
    // MARK: - Layout
    
    func testShadowsAreRenderedOnBothHandleAndTrackView() {
        // Given
        let subject = ChromaBrightnessSlider()
        let sliderTrack = subject.test_sliderTrackView
        
        // When
        subject.showsShadow = true
        
        // Then
        XCTAssertGreaterThan(sliderTrack.layer.shadowOpacity, 0)
        XCTAssertGreaterThan(subject.handle.layer.shadowOpacity, 0)
    }
    
    func testShadowsAreRemovedFromHandleAndTrackView() {
        // Given
        let subject = ChromaBrightnessSlider()
        let sliderTrack = subject.test_sliderTrackView
        
        // When
        subject.showsShadow = false
        
        // Then
        XCTAssertEqual(sliderTrack.layer.shadowOpacity, 0)
        XCTAssertEqual(subject.handle.layer.shadowOpacity, 0)
    }
    
    func testHandleIsRepositionedAccordingToCurrentValueOnLayout() {
        // Given
        let subject = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        //subject.layoutIfNeeded()
        let expectedPosition = subject.center
        
        // When
        subject.currentValue = 0.5
        subject.layoutIfNeeded()
        
        // Then
        XCTAssertEqual(subject.handle.center, expectedPosition)
    }
    
    // MARK: - Convenience Functions
    
    func testConnectCallsConnectFunctionOfColorPicker() {
        // Given
        let subject = ChromaBrightnessSlider()
        let colorPicker = FakeColorPicker()
        
        // When
        subject.connect(to: colorPicker)
        
        // Then
        XCTAssertTrue(colorPicker.didCallConnect)
    }
    
    func testValueShouldReturn1WhenBrightnessIs0() {
        // Given
        let subject = ChromaBrightnessSlider()
        
        // When
        let value = subject.value(brightness: 0)
        
        // Then
        XCTAssertEqual(value, 1, accuracy: 0.0001)
    }

    func testValueShouldReturn0WhenBrightnessIs1() {
        // Given
        let subject = ChromaBrightnessSlider()
        
        // When
        let value = subject.value(brightness: 1)

        // Then
        XCTAssertEqual(value, 0, accuracy: 0.0001)
    }
    
    func testValueShouldReturn0WhenBrightnessIsLargerThan1() {
        // Given
        let subject = ChromaBrightnessSlider()
        
        // When
        let value = subject.value(brightness: 100)
        
        // Then
        XCTAssertEqual(value, 0, accuracy: 0.0001)
    }
    
    func testValueShouldReturn1WhenBrightnessIsLessThan0() {
        // Given
        let subject = ChromaBrightnessSlider()
        
        // When
        let value = subject.value(brightness: -100)
        
        // Then
        XCTAssertEqual(value, 1, accuracy: 0.0001)
    }
    
    func testValueShouldReturn0_25WhenBrightnessIs0_75() {
        // Given
        let subject = ChromaBrightnessSlider()
        
        // When
        let value = subject.value(brightness: 0.75)
        
        // Then
        XCTAssertEqual(value, 0.25, accuracy: 0.0001)
    }
    
    // MARK: - Control
    
    func testBeginTrackingSendsTouchDownActionWhenTouchIsInBounds() {
        // Given
        let subject = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        subject.layoutIfNeeded()
        let fakeTouch = FakeUITouch(locationInParent: CGPoint(x: subject.bounds.midX,
                                                              y: subject.bounds.midY))
        let eventReceiver = FakeEventReceiver(listensFor: .touchDown)
        subject.addTarget(eventReceiver, action: #selector(FakeEventReceiver.catchEvent(_:)), for: .touchDown)
        
        var eventDidTrigger = false
        eventReceiver.eventCaught = {
            eventDidTrigger = true
        }
        
        // When
        let shouldTrack = subject.beginTracking(fakeTouch, with: nil)
        
        // Then
        XCTAssertTrue(eventDidTrigger)
        XCTAssertTrue(shouldTrack)
    }
    
    func testBeginTrackingDoesNotSendTouchDownActionWhenTouchIsOutOfBounds() {
        // Given
        let subject = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        subject.layoutIfNeeded()
        let fakeTouch = FakeUITouch(locationInParent: CGPoint(x: -100, y: subject.bounds.midY))
        let eventReceiver = FakeEventReceiver(listensFor: .touchDown)
        subject.addTarget(eventReceiver, action: #selector(FakeEventReceiver.catchEvent(_:)), for: .touchDown)
        
        var eventDidTrigger = false
        eventReceiver.eventCaught = {
            eventDidTrigger = true
        }
        
        // When
        let shouldTrack = subject.beginTracking(fakeTouch, with: nil)
        
        // Then
        XCTAssertFalse(eventDidTrigger)
        XCTAssertFalse(shouldTrack)
    }
    
    func testContinueTrackingSendsValueChangedActionAndHasClampedValue() {
        // Given
        let subject = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        subject.layoutIfNeeded()
        let fakeTouch = FakeUITouch(locationInParent: CGPoint(x: subject.bounds.width + 100, y: subject.bounds.midY))
        let eventReceiver = FakeEventReceiver(listensFor: .valueChanged)
        subject.addTarget(eventReceiver, action: #selector(FakeEventReceiver.catchEvent(_:)), for: .valueChanged)
        
        var eventDidTrigger = false
        var value: CGFloat?
        eventReceiver.eventCaught = {
            eventDidTrigger = true
            value = subject.currentValue
        }
        
        // When
        let _ = subject.continueTracking(fakeTouch, with: nil)
        
        // Then
        XCTAssertTrue(eventDidTrigger)
        XCTAssertEqual(value, 1.0, "ChromaBrightnessSlider did not clamp value when touch is out of bounds")
    }
    
    func testEndTrackingSendsTouchUpInsideAction() {
        // Given
        let subject = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        subject.layoutIfNeeded()
        let fakeTouch = FakeUITouch(locationInParent: CGPoint(x: 0, y: 0))
        let eventReceiver = FakeEventReceiver(listensFor: .touchUpInside)
        subject.addTarget(eventReceiver, action: #selector(FakeEventReceiver.catchEvent(_:)), for: .touchUpInside)
        
        var eventDidTrigger = false
        eventReceiver.eventCaught = {
            eventDidTrigger = true
        }
        
        // When
        let _ = subject.endTracking(fakeTouch, with: nil)
        
        // Then
        XCTAssertTrue(eventDidTrigger)
    }
}

fileprivate extension ChromaBrightnessSlider {
    var test_sliderTrackView: SliderTrackView {
        return subviews.first(where: { $0 is SliderTrackView }) as! SliderTrackView
    }
}


fileprivate class FakeColorPicker: ChromaColorPicker {
    var didCallConnect: Bool = false
    
    override func connect(_ slider: ChromaBrightnessSlider) {
        didCallConnect = true
    }
}
