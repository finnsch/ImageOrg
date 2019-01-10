//
//  DragView.swift
//  imageorg
//
//  Created by Finn Schlenk on 24.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

protocol DragViewDelegate {
    func didDrag(filePaths: [String])
}

class DragView: NSView, NibLoadable {

    @IBOutlet weak var dragInfoTextField: NSTextField! {
        didSet {
            dragInfoTextField.isHidden = true
        }
    }
    var contentView: NSView! {
        return self
    }
    var delegate: DragViewDelegate?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        setupView()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        setupView()
    }

    func setupView() {
        wantsLayer = true

        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
    }
}

// MARK: - NSDraggingDestination
extension DragView {

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        layer?.backgroundColor = NSColor.darkGray.withAlphaComponent(0.5).cgColor
        dragInfoTextField.isHidden = false
        return .copy
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        layer?.backgroundColor = nil
        dragInfoTextField.isHidden = true
    }

    override func draggingEnded(_ sender: NSDraggingInfo) {
        layer?.backgroundColor = nil
        dragInfoTextField.isHidden = true
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let paths = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? [String] else {
            return false
        }

        delegate?.didDrag(filePaths: paths)

        return true
    }
}
