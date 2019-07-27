//
//  HeartView.swift
//  imageorg
//
//  Created by Finn Schlenk on 10.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class HeartView: HoverView, NibLoadable {

    @IBOutlet var contentView: NSView!
    @IBOutlet weak var backgroundView: NSView!
    @IBOutlet weak var heartIconImageView: NSImageView! {
        didSet {
            heartIconImageView.image = heartIconImageView.image?.tinting(with: NSColor.controlAccentColor)
        }
    }

    var handleClick: () -> () = {}

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
        handleMouseOverEntered = {
            let scaleUp = CABasicAnimation(keyPath: "transform")
            scaleUp.duration = 0.25
            scaleUp.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            scaleUp.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0))
            scaleUp.fillMode = .both
            scaleUp.isRemovedOnCompletion = false
            self.backgroundView.layer?.add(scaleUp, forKey: nil)
        }

        handleMouseOverExited = {
            let scaleBack = CABasicAnimation(keyPath: "transform")
            scaleBack.duration = 0.25
            scaleBack.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0))
            scaleBack.toValue = NSValue(caTransform3D: CATransform3DIdentity)
            scaleBack.fillMode = .both
            scaleBack.isRemovedOnCompletion = false
            self.backgroundView.layer?.add(scaleBack, forKey: nil)
        }

        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = NSColor.heartViewBackgroundColor.cgColor
        backgroundView.layer?.cornerRadius = 12.0

        addShadow(ofColor: .black, radius: 10.0, offset: .init(width: -5, height: -5), opacity: 0.4)
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        guard !isHidden, bounds.contains(point) else {
            return nil
        }

        return self
    }

    override func mouseDown(with event: NSEvent) {
        handleClick()
    }
}
