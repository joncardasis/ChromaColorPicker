//
//  SliderTrackView.swift
//  ChromaColorPicker
//
//  Created by Jon Cardasis on 4/13/19.
//  Copyright © 2019 Jonathan Cardasis. All rights reserved.
//

import UIKit

internal class SliderTrackView: UIView {
    typealias GradientValues = (start: UIColor, end: UIColor)
    
    var gradientValues: GradientValues = (.white, .black) {
        didSet { updateGradient(for: gradientValues) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = layer.bounds
        gradient.cornerRadius = layer.cornerRadius
    }
    
    func updateGradient(for values: GradientValues) {
        gradient.colors = [values.start.cgColor, values.end.cgColor]
    }
    
    // MARK: - Private
    private let gradient = CAGradientLayer()
    
    private func commonInit() {
        gradient.masksToBounds = true
        gradient.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        updateGradient(for: gradientValues)
        layer.addSublayer(gradient)
    }
}
