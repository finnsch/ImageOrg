//
//  ClickableTextField.swift
//  imageorg
//
//  Created by Finn Schlenk on 23.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class ClickableTextField: NSTextField {

    var link: String?

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)

        guard let link = link,
            let url = URL(string: link) else {
            return
        }

        NSWorkspace.shared.open(url)
    }
    
}
