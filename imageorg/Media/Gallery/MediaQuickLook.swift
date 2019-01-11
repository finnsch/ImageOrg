//
//  MediaQuickLook.swift
//  imageorg
//
//  Created by Finn Schlenk on 11.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa
import Quartz
import QuickLook

class MediaQuickLook: NSView {

    var mediaStore = MediaStore.shared

    var handleClosePreviewPanel: (() -> ())?

    override func becomeFirstResponder() -> Bool {
        return true
    }

    func show() {
        window?.makeFirstResponder(self)
        QLPreviewPanel.shared()?.makeKeyAndOrderFront(self)
    }

    private func closePreviewPanel() {
        removeFromSuperview()
        handleClosePreviewPanel?()
    }
}

extension MediaQuickLook: QLPreviewPanelDataSource, QLPreviewPanelDelegate {

    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        return mediaStore.selectedMedia != nil
    }

    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        if let sharedPanel = QLPreviewPanel.shared() {
            sharedPanel.dataSource = self
            sharedPanel.delegate = self

            if let index = mediaStore.mediaItems.firstIndex(where: { $0.id == mediaStore.selectedMedia!.id }) {
                sharedPanel.currentPreviewItemIndex = index
            }
        }
    }

    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
        if let sharedPanel = QLPreviewPanel.shared() {
            sharedPanel.dataSource = nil
            sharedPanel.delegate = nil
        }

        closePreviewPanel()
    }

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return mediaStore.numberOfItems
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return mediaStore.mediaItems[index].originalFileURL as QLPreviewItem
    }
}
