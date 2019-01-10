//
//  FavoriteButton.swift
//  imageorg
//
//  Created by Finn Schlenk on 09.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class FavoriteButton: NSButton {

    var isFavorite: Bool = false {
        didSet {
            updateImage()
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        updateImage()
    }

    private func updateImage() {
        if isFavorite {
            image = NSImage(named: "HeartIcon")?.tinting(with: NSColor.controlAccentColor)
        } else {
            image = NSImage(named: "HeartOutlineIcon")?.tinting(with: NSColor.controlAccentColor)
        }
    }
}
