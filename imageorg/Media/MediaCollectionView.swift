//
//  MediaCollectionView.swift
//  imageorg
//
//  Created by Finn Schlenk on 27.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

enum SortOrder {
    case createdAt
    case name
}

protocol MediaCollectionViewDelegate: class {
    func didSelect(sortOrder: SortOrder)
}

class MediaCollectionView: NSCollectionView {

    weak var customDelegate: MediaCollectionViewDelegate?

    // The index of the item the user clicked.
    var clickedItemIndex: Int = NSNotFound

    var contextMenu: NSMenu {
        let menu = NSMenu(title: "Options")

        let sortByDateItem = NSMenuItem(title: "Sort by date", action: #selector(sortByDate), keyEquivalent: "")
        let sortByTitleItem = NSMenuItem(title: "Sort by title", action: #selector(sortByName), keyEquivalent: "")

        menu.addItem(sortByDateItem)
        menu.addItem(sortByTitleItem)

        return menu
    }

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

    @objc func sortByDate() {
        customDelegate?.didSelect(sortOrder: .createdAt)
        print("sort by date")
    }

    @objc func sortByName() {
        customDelegate?.didSelect(sortOrder: .name)
        print("sort by name")
    }
}
