//
//  HeartView.swift
//  imageorg
//
//  Created by Finn Schlenk on 10.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class HeartView: NSView, NibLoadable {

    @IBOutlet var contentView: NSView!
    @IBOutlet weak var backgroundView: NSView!
    @IBOutlet weak var heartIconImageView: NSImageView! {
        didSet {
            heartIconImageView.image = heartIconImageView.image?.tinting(with: NSColor.controlAccentColor)
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        createFromNib()
        setupView()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        createFromNib()
        setupView()
    }

    func setupView() {
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = NSColor.white.cgColor
        backgroundView.layer?.cornerRadius = 12.0
    }
}
