//
//  MediaToolbarConfiguration.swift
//  imageorg
//
//  Created by Finn Schlenk on 10.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaToolbarConfiguration {

    var items: [MediaToolbarItem] = []
}

class MediaGalleryToolbarConfiguration: MediaToolbarConfiguration {

    init(toolbar: NSToolbar) {
        super.init()

        items = [
            MediaToolbarItem(index: 0, identifier: NSToolbarItem.Identifier.flexibleSpace.rawValue),
            MediaToolbarItem(index: 1, identifier: "SidebarToolbarItem"),
        ]
    }
}

class MediaDetailToolbarConfiguration: MediaToolbarConfiguration {

    init(toolbar: NSToolbar, isFavorite: Bool) {
        super.init()

        var favoriteItem = MediaToolbarItem(index: 3, identifier: "IsNotFavoriteToolbarItem")

        if isFavorite {
            favoriteItem = MediaToolbarItem(index: 3, identifier: "IsFavoriteToolbarItem")
        }

        items = [
            MediaToolbarItem(index: 0, identifier: "GoBackToolbarItem"),
            MediaToolbarItem(index: 1, identifier: NSToolbarItem.Identifier.flexibleSpace.rawValue),
            MediaToolbarItem(index: 2, identifier: "DeleteToolbarItem"),
            favoriteItem,
            MediaToolbarItem(index: 4, identifier: "ZoomInToolbarItem"),
            MediaToolbarItem(index: 5, identifier: "ZoomOutToolbarItem"),
            MediaToolbarItem(index: 6, identifier: NSToolbarItem.Identifier.flexibleSpace.rawValue),
            MediaToolbarItem(index: 7, identifier: "SidebarToolbarItem")
        ]
    }
}
