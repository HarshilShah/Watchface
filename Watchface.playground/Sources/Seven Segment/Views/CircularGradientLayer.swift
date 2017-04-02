//
//  CACircularGradientLayer.swift
//  StepUp
//
//  Created by Harshil Shah on 18/06/16.
//  Copyright © 2016 Harshil Shah. All rights reserved.
//

import UIKit
import CoreGraphics

internal class CircularGradientLayer: CALayer {
    
    // MARK: Static variables
    
    static let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    // MARK: Public variables
    
    internal var startCenter: CGPoint = .zero
    internal var endCenter: CGPoint = .zero

    internal var internalRadius: CGFloat = 0
    internal var externalRadius: CGFloat = 0
    
    internal var gradient = CGGradient(
        colorsSpace: colorSpace,
        colors: [UIColor.white.cgColor, UIColor.black.cgColor] as CFArray,
        locations: [0, 1])!
    
    // MARK:- Initialisers
    
    internal override init() {
        super.init()
    }
    
    internal override init(layer: Any) {
        super.init(layer: layer)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        needsDisplayOnBoundsChange = true
    }
    
    private var options: CGGradientDrawingOptions = .drawsAfterEndLocation
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.drawRadialGradient(gradient, startCenter: startCenter, startRadius: internalRadius, endCenter: endCenter, endRadius: externalRadius, options: options)
    }
    
}
