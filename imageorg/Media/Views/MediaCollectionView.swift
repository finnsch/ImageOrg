//
//  MediaCollectionView.swift
//  imageorg
//
//  Created by Finn Schlenk on 27.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaCollectionView: NSCollectionView {

    private var isSingleItemSelected: Bool {
        return selectionIndexPaths.count == 1
    }

    private var areMultipleItemsSelected: Bool {
        return selectionIndexPaths.count > 1
    }

    lazy var contextMenu = MediaCollectionViewContextMenu(title: "")

    override func menu(for event: NSEvent) -> NSMenu? {
        let point = convert(event.locationInWindow, from:nil)
        let count = numberOfItems(inSection: 0)

        for index in 0 ..< count
        {
            let itemFrame = frameForItem(at: index)
            if NSMouseInRect(point, itemFrame, isFlipped)
            {
                selectItem(at: index)
                break
            }
        }

        return contextMenu
    }

    private func selectItem(at index: Int) {
        deselectPreviousSingleItem()
        let indexPaths: Set<IndexPath> = [IndexPath(item: index, section: 0)]
        selectItems(at: indexPaths, scrollPosition: .centeredHorizontally)
    }

    private func deselectPreviousSingleItem() {
        guard isSingleItemSelected else {
            return
        }

        deselectItems(at: selectionIndexPaths)
    }

    func showDeletionConfirmationAlert(completionHandler: @escaping () -> ()) {
        guard areMultipleItemsSelected else {
            completionHandler()
            return
        }

        let alert = DeletionConfirmationAlert(numberOfItems: selectionIndexes.count)
        alert.beginSheetModal(for: window!) { response in
            guard response == .OK else {
                return
            }

            completionHandler()
        }
    }
}
