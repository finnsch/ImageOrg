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

    var isFavorite: Bool
    var isImage: Bool
    var currentIndex: Int = 0

    init(toolbar: NSToolbar, isFavorite: Bool, isImage: Bool) {
        self.isFavorite = isFavorite
        self.isImage = isImage

        super.init()

        items = [
            createOuterLeftItems(),
            createFavoriteItem(),
            createZoomItems(),
            createOuterRightItems()
        ].flatMap({ $0 })
    }

    func createOuterLeftItems() -> [MediaToolbarItem] {
        currentIndex = 3

        return [
            MediaToolbarItem(index: 0, identifier: "GoBackToolbarItem"),
            MediaToolbarItem(index: 1, identifier: NSToolbarItem.Identifier.flexibleSpace.rawValue),
            MediaToolbarItem(index: 2, identifier: "DeleteToolbarItem")
        ]
    }

    func createFavoriteItem() -> [MediaToolbarItem] {
        var favoriteItem = MediaToolbarItem(index: currentIndex, identifier: "IsNotFavoriteToolbarItem")

        if isFavorite {
            favoriteItem = MediaToolbarItem(index: currentIndex, identifier: "IsFavoriteToolbarItem")
        }

        currentIndex = 4

        return [favoriteItem]
    }

    func createZoomItems() -> [MediaToolbarItem] {
        var zoomItems: [MediaToolbarItem] = []

        if isImage {
            zoomItems = [
                MediaToolbarItem(index: currentIndex, identifier: "ZoomOutToolbarItem"),
                MediaToolbarItem(index: currentIndex + 1, identifier: "ZoomInToolbarItem")
            ]

            currentIndex = 6
        }

        return zoomItems
    }

    func createOuterRightItems() -> [MediaToolbarItem] {
        let items = [
            MediaToolbarItem(index: currentIndex, identifier: NSToolbarItem.Identifier.flexibleSpace.rawValue),
            MediaToolbarItem(index: currentIndex + 1, identifier: "SidebarToolbarItem")
        ]

        currentIndex = 8

        return items
    }
}
