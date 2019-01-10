//
//  MediaToolbarItem.swift
//  imageorg
//
//  Created by Finn Schlenk on 10.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaToolbarItem {

    var index: Int
    var identifier: NSToolbarItem.Identifier

    init(index: Int, identifier: String) {
        self.index = index
        self.identifier = NSToolbarItem.Identifier(identifier)
    }
}
