//
//  MediaToolbar.swift
//  imageorg
//
//  Created by Finn Schlenk on 10.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaToolbar: NSToolbar {

    lazy var config: MediaToolbarConfiguration = MediaGalleryToolbarConfiguration(toolbar: self)

    func deleteItems() {
        config.items.forEach { _ in
            self.removeItem(at: 0)
        }
    }

    func replaceItems(for config: MediaToolbarConfiguration) {
        deleteItems()

        self.config = config

        config.items.forEach { item in
            self.insertItem(withItemIdentifier: item.identifier, at: item.index)
        }
    }
}
