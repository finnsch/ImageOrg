//
//  MediaCollectionViewContextMenu.swift
//  imageorg
//
//  Created by Finn Schlenk on 12.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

enum ContextMenuItem {
    case delete
    case sort
}

protocol ContextMenuDelegate: class {
    func didSelect(item: ContextMenuItem)
}

class MediaCollectionViewContextMenu: NSMenu {

    weak var customDelegate: ContextMenuDelegate?

    var sortOrderMenu = SortOrderMenu(title: "")

    override init(title: String) {
        super.init(title: title)

        let deleteItem = NSMenuItem(title: "Delete", action: #selector(delete), keyEquivalent: "")
        let sortItem = NSMenuItem(title: "Sort by", action: nil, keyEquivalent: "")
        deleteItem.target = self
        sortItem.target = self

        addItem(deleteItem)
        addItem(sortItem)
        setSubmenu(sortOrderMenu, for: sortItem)
    }

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    @objc func delete() {
        customDelegate?.didSelect(item: .delete)
    }
}
