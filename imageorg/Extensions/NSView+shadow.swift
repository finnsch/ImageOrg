//
//  NSView+shadow.swift
//  imageorg
//
//  Created by Finn Schlenk on 26.07.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

extension NSView {

    /// SwifterSwift: Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    func addShadow(ofColor color: NSColor = NSColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, shadowPath: CGPath? = nil, opacity: Float = 0.5) {
        wantsLayer = true
        layer?.shadowColor = color.cgColor
        layer?.shadowOffset = offset
        layer?.shadowRadius = radius
        layer?.shadowOpacity = opacity
        layer?.shadowPath = shadowPath ?? NSBezierPath(rect: bounds).cgPath
        layer?.masksToBounds = false
    }
}
