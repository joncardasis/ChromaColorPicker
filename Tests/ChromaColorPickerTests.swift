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
    
    // MARK: Handles
    
    func testAddHandleAddsHandleToArray() {
        // Given, When
        subject.addHandle()
        
        // Then
        XCTAssertEqual(subject.handles.count, 1)
    }
    
    func testAddHandleAddsCustomHandleToArray() {
        // Given
        let handle = ChromaColorHandle(color: .black)
        
        // When
        subject.addHandle(handle)
        
        // Then
        XCTAssertEqual(subject.handles.first!, handle)
    }
    
    func testAddHandlePlacesHandleAtWhiteIfColorIsNil() {
        // Given, When
        subject.addHandle(at: nil)
        
        // Then
        XCTAssertEqual(subject.handles.first!.color, .white)
    }
    
    func testAddHandleUpdatesBrightnessSliderIfAttached() {
        // Given
        let slider = ChromaBrightnessSlider(frame: .zero)
        subject.connect(slider)
        let color: UIColor = .purple
        
        // When
        subject.addHandle(at: color)
        
        // Then
        XCTAssertEqual(slider.trackColor, color)
    }
    
    // MARK: Brightness Slider
    
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
    
    // MARK: UI Control
    
    func testShouldBeginTrackingAndSetCurrentHandleIfTouchedHandle() {
        // Given
        let handleFrame = CGRect(x: subject.bounds.width / 2.0, y: subject.bounds.height / 2.0, width: 10, height: 10)
        let handle = ChromaColorHandle(frame: handleFrame)
        subject.addHandle(handle)
        let fakeTouch = FakeUITouch(locationInParent: handleFrame.origin)
        
        // When
        let result = subject.beginTracking(fakeTouch, with: nil)
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(subject.currentHandle, handle)
    }
    
    func testShouldBeginTrackingIfTouchedOnHandleWithExtendedHitBox() {
        // Given
        let yExtension: CGFloat = 8.0
        let handleFrame = CGRect(x: subject.bounds.width / 2.0, y: subject.bounds.height / 2.0, width: 10, height: 10)
        subject.addHandle(ChromaColorHandle(frame: handleFrame))
        subject.handleHitboxExtensionY = yExtension
        let fakeTouch = FakeUITouch(locationInParent: CGPoint(x: handleFrame.origin.x,
                                                              y: handleFrame.origin.y + handleFrame.height + yExtension - 1))
        
        // When
        let result = subject.beginTracking(fakeTouch, with: nil)
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testBeginTrackingUpdatesBrightnessSliderIfAttached() {
        // Given
        let slider = ChromaBrightnessSlider(frame: .zero)
        subject.connect(slider)
        
        let handleFrame = CGRect(x: subject.bounds.width / 2.0, y: subject.bounds.height / 2.0, width: 10, height: 10)
        let handle = ChromaColorHandle(frame: handleFrame)
        subject.addHandle(handle)
        let fakeTouch = FakeUITouch(locationInParent: handleFrame.origin)
        
        // When
        let _ = subject.beginTracking(fakeTouch, with: nil)
        
        // Then
        XCTAssertEqual(slider.trackColor, handle.color.withBrightness(1))
        XCTAssertEqual(slider.currentValue, slider.value(brightness: handle.color.brightness))
    }
    
    func testStopContinueTrackingIfCurrentHandleIsNil() {
        // Given, When
        let result = subject.continueTracking(FakeUITouch(locationInParent: .zero), with: nil)
        
        // Then
        XCTAssertNil(subject.currentHandle)
        XCTAssertFalse(result)
    }
    
    func testContinueTrackingSendsValueChangedActionForValidLocation() {
        subject.colorWheelView.layoutIfNeeded()
        
        // Given
        setCurrentHandle(to: makeFakeHandle())
        let fakeTouch = FakeUITouch(locationInParent: CGPoint(x: subject.colorWheelView.bounds.midX,
                                                              y: subject.colorWheelView.bounds.midY))
        let eventReceiver = FakeEventReceiver(listensFor: .valueChanged)
        subject.addTarget(eventReceiver, action: #selector(FakeEventReceiver.catchEvent), for: .valueChanged)
        
        var eventDidTrigger = false
        eventReceiver.eventCaught = {
            eventDidTrigger = true
        }
        
        // When
        let _ = subject.continueTracking(fakeTouch, with: nil)

        // Then
        XCTAssertTrue(eventDidTrigger)
    }
    
    
    func testEndTrackingSendsTouchUpInsideAction() {
        subject.colorWheelView.layoutIfNeeded()
        
        // Given
        setCurrentHandle(to: makeFakeHandle())
        let fakeTouch = FakeUITouch(locationInParent: CGPoint(x: subject.colorWheelView.bounds.midX,
                                                              y: subject.colorWheelView.bounds.midY))
        let eventReceiver = FakeEventReceiver(listensFor: .touchUpInside)
        subject.addTarget(eventReceiver, action: #selector(FakeEventReceiver.catchEvent), for: .touchUpInside)
        
        var eventDidTrigger = false
        eventReceiver.eventCaught = {
            eventDidTrigger = true
        }
        
        // When
        let _ = subject.endTracking(fakeTouch, with: nil)
        
        // Then
       XCTAssertTrue(eventDidTrigger)
    }
    
    func testHitTestShouldReturnSelfWhenTouchIsWithinSelf() {
        subject.colorWheelView.layoutIfNeeded()
        
        // Given
        let touchLocation = subject.center
        
        // When
        let hitView = subject.hitTest(touchLocation, with: UIEvent())
        
        // Then
        XCTAssertEqual(hitView, subject)
    }
    
    func testHitTestShouldReturnSelfWhenTouchIsWithinSelfPlusHandleRadius() {
        subject.colorWheelView.layoutIfNeeded()
        
        // Given
        let touchLocation = CGPoint(x: -subject.handleSize.width / 2.0, y: subject.center.y)
        
        // When
        let hitView = subject.hitTest(touchLocation, with: UIEvent())
        
        // Then
        XCTAssertEqual(hitView, subject)
    }
    
    func testHitTestShouldReturnNilWhenTouchIsOutsideHitbox() {
        subject.colorWheelView.layoutIfNeeded()
        
        // Given
        let extendedSize: CGFloat = 12
        subject.handleSize = CGSize(width: extendedSize, height: extendedSize)
        let fakeHandle = makeFakeHandle()
        let touchLocation = CGPoint(x: -extendedSize - 1, y: subject.center.y)
        setCurrentHandle(to: fakeHandle)
        
        // When
        let hitView = subject.hitTest(touchLocation, with: UIEvent())
        
        // Then
        XCTAssertEqual(hitView, nil)
    }
}


// Test Helpers
extension ChromaColorPickerTests {
    
    func makeFakeHandle() -> ChromaColorHandle {
        return ChromaColorHandle(frame: CGRect(x: subject.bounds.midX, y: subject.bounds.midY, width: 10, height: 10))
    }
    
    func setCurrentHandle(to handle: ChromaColorHandle) {
        subject.addHandle(handle)
        let fakeTouch = FakeUITouch(locationInParent: handle.frame.origin)
        let _ = subject.beginTracking(fakeTouch, with: nil)
    }
}
