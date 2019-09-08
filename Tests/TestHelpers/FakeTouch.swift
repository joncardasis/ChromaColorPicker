//
//  FakeTouch.swift
//  ChromaColorPickerTests
//
//  Created by Jon Cardasis on 9/8/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

class FakeUITouch: UITouch {
    
    let locationInParent: CGPoint
    
    init(locationInParent: CGPoint) {
        self.locationInParent = locationInParent
    }
    
    override func location(in view: UIView?) -> CGPoint {
        return locationInParent
    }
}

class FakeEventReceiver: NSObject {
    var eventCaught: (() -> ())?
    let event: UIControl.Event
    
    init(listensFor event: UIControl.Event) {
        self.event = event
    }
    
    @objc func catchEvent(_ sender: UIControl) {
        if sender.allControlEvents.contains(event) {
            eventCaught?()
        }
    }
}
