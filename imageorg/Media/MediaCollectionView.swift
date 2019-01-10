//
//  MediaCollectionView.swift
//  imageorg
//
//  Created by Finn Schlenk on 27.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaCollectionView: NSCollectionView {

    // The index of the item the user clicked.
    var clickedItemIndex: Int = NSNotFound

    var contextMenu: SortOrderMenu = SortOrderMenu(title: "")

    override func menu(for event: NSEvent) -> NSMenu? {
        clickedItemIndex = NSNotFound

        let point = convert(event.locationInWindow, from:nil)
        let count = numberOfItems(inSection: 0)

        for index in 0 ..< count
        {
            let itemFrame = frameForItem(at: index)
            if NSMouseInRect(point, itemFrame, isFlipped)
            {
                self.clickedItemIndex = index
                break
            }
        }

        return contextMenu
    }
}
