//
//  CustomImageView.swift
//  imageorg
//
//  Created by Finn Schlenk on 21.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class CustomImageView: NSImageView {

    private var borderColor: NSColor {
        if NSAppearance.current.isDarkMode {
            return NSColor.controlAccentColor.withAlphaComponent(0.8)
        }

        return NSColor.controlAccentColor
    }

    var isSelected: Bool = false {
        didSet {
            if isSelected {
                layer?.borderWidth = 2.0
                layer?.borderColor = borderColor.cgColor
            } else {
                layer?.borderWidth = 0.0
            }
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    func setupView() {
        wantsLayer = true
        layer?.cornerRadius = 4.0
        layer?.masksToBounds = true
    }
}
