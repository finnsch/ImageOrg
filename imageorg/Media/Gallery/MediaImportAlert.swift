//
//  MediaImportAlert.swift
//  imageorg
//
//  Created by Finn Schlenk on 16.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaImportAlert: NSAlert {

    private var currentItem: Int = 0
    private var totalItems: Int
    private var progressView: MediaImportProgressView

    init(totalItems: Int) {
        self.totalItems = totalItems
        self.progressView = MediaImportProgressView.createFromNib()!

        super.init()

        icon = NSImage(imageLiteralResourceName: "NSInfo")
        accessoryView = NSView(frame: NSRect(x: 0, y: 0, width: 300, height: 20))
        messageText = "Importing items"
        addButton(withTitle: "Cancel")

        accessoryView?.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTextField.stringValue = "0/\(totalItems)"

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: accessoryView!.topAnchor, constant: 0),
            progressView.leadingAnchor.constraint(equalTo: accessoryView!.leadingAnchor, constant: 0),
            progressView.bottomAnchor.constraint(equalTo: accessoryView!.bottomAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: accessoryView!.trailingAnchor, constant: 0)
        ])
    }

    override func beginSheetModal(for sheetWindow: NSWindow, completionHandler handler: ((NSApplication.ModalResponse) -> Void)? = nil) {
        super.beginSheetModal(for: sheetWindow, completionHandler: handler)

        accessoryView?.window?.makeFirstResponder(sheetWindow)
    }

    func updateProgress() {
        currentItem += 1

        let rate = Double(currentItem) / Double(totalItems)
        let percentage = min(rate * 100.0, 100.0)

        progressView.progressBar.increment(by: percentage)
        progressView.progressTextField.stringValue = "\(currentItem)/\(totalItems)"
    }
}
