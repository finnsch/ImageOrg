//
//  NoClippingView.swift
//  imageorg
//
//  Created by Finn Schlenk on 10.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class NoClippingLayer: CALayer {
    override var masksToBounds: Bool {
        set {

        }
        get {
            return false
        }
    }
}

class NoClippingView: NSView {
    override var wantsDefaultClipping: Bool {
        return false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        layer = NoClippingLayer()
    }
}
