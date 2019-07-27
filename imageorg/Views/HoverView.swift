//
//  HoverView.swift
//  imageorg
//
//  Created by Finn Schlenk on 27.07.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class HoverView: NSView {

    override var wantsUpdateLayer: Bool {
        return true
    }

    private var isMouseOver = false {
        didSet {
            needsDisplay = true
        }
    }

    var handleMouseOverEntered: () -> () = {}
    var handleMouseOverExited: () -> () = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay

        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeInKeyWindow, .mouseEnteredAndExited],
            owner: self,
            userInfo: nil
        )

        addTrackingArea(trackingArea)
    }

    override func updateLayer() {
        super.updateLayer()

        if isMouseOver {
            handleMouseOverEntered()
        } else {
            handleMouseOverExited()
        }
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        isMouseOver = true
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        isMouseOver = false
    }
}
