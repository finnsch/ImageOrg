//
//  BadgeView.swift
//  imageorg
//
//  Created by Finn Schlenk on 19.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class BadgeView: NSView, NibLoadable {

    @IBOutlet weak var labelTextField: NSTextField!

    var contentView: NSView! {
        return self
    }
    var badge: Badge? {
        didSet {
            setupView()
        }
    }

    func setupView() {
        guard let badge = badge else {
            return
        }

        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = badge.color?.cgColor
        contentView.layer?.cornerRadius = 3.0
        labelTextField.textColor = .white
        labelTextField.drawsBackground = true
        labelTextField.backgroundColor = .clear
        labelTextField.stringValue = badge.title.uppercased()
    }
}
