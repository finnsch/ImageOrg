//
//  MediaSidebarViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 21.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaSidebarViewController: MediaViewController {

    @IBOutlet weak var metaInfoStackView: NSStackView!
    @IBOutlet weak var fileNameTextField: NSTextField! {
        didSet {
            fileNameTextField.refusesFirstResponder = true
        }
    }
    @IBOutlet weak var fileSizeTextField: NSTextField!
    @IBOutlet weak var fileTypeTextField: NSTextField!
    @IBOutlet weak var filePathTextField: ClickableTextField!
    @IBOutlet weak var whereFromStackView: NSStackView!
    @IBOutlet weak var whereFromUrlTextField: ClickableTextField!
    @IBOutlet weak var creationDateTextField: NSTextField!
    @IBOutlet weak var modificationDateTextField: NSTextField!

    var mediaStore = MediaStore.shared
    let mediaCoreDataService = MediaCoreDataService()

    override func viewDidLoad() {
        super.viewDidLoad()

        let doubleClickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick))
        doubleClickGesture.numberOfClicksRequired = 2

        filePathTextField.addGestureRecognizer(doubleClickGesture)

        resetView()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        mediaStore.add(delegate: self)
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        setupView()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()

        mediaStore.remove(delegate: self)
    }

    func setupView() {
        guard let media = mediaStore.selectedMedia else {
            return
        }

        // bytes to kilobytes
        let fileSize = Int(media.fileSize / 1000)
        let filePath = media.originalFilePath

        fileNameTextField.toolTip = media.name
        fileNameTextField.stringValue = media.name
        fileSizeTextField.stringValue = "\(fileSize) KB"
        fileTypeTextField.stringValue = media.mimeType

        let filePathParagraphStyle = NSMutableParagraphStyle()
        filePathParagraphStyle.alignment = .right
        filePathParagraphStyle.lineBreakMode = .byTruncatingHead
        let filePathAttributedString = NSMutableAttributedString(string: filePath, attributes: [NSAttributedString.Key.paragraphStyle: filePathParagraphStyle])
        filePathAttributedString.setAsLink(textToFind: filePath, link: filePath)
        filePathTextField.toolTip = filePath
        filePathTextField.attributedStringValue = filePathAttributedString
        filePathTextField.link = filePath

        if let whereFrom = media.whereFrom, whereFrom.isValidURL {
            let whereFromParagraphStyle = NSMutableParagraphStyle()
            whereFromParagraphStyle.alignment = .right
            whereFromParagraphStyle.lineBreakMode = .byTruncatingHead
            let whereFromAttributedString = NSMutableAttributedString(string: whereFrom, attributes: [NSAttributedString.Key.paragraphStyle: filePathParagraphStyle])
            whereFromAttributedString.setAsLink(textToFind: whereFrom, link: whereFrom)
            whereFromUrlTextField.attributedStringValue = whereFromAttributedString
            whereFromStackView.isHidden = false
        } else {
            whereFromStackView.isHidden = true
        }

        creationDateTextField.stringValue = Date(date: media.creationDate).toString()

        if let modificationDate = media.modificationDate {
            modificationDateTextField.stringValue = Date(date: modificationDate).toString()
        }
    }

    func resetView() {
        fileNameTextField.toolTip = nil
        fileNameTextField.stringValue = "-"
        fileSizeTextField.stringValue = "-"
        fileTypeTextField.stringValue = "-"
        filePathTextField.toolTip = nil
        filePathTextField.attributedStringValue = NSAttributedString()
        whereFromUrlTextField.attributedStringValue = NSAttributedString()
        whereFromStackView.isHidden = false
        creationDateTextField.stringValue = "-"
        modificationDateTextField.stringValue = "-"
    }

    @objc func handleClick() {
        guard let media = mediaStore.selectedMedia else {
            return
        }

        NSWorkspace.shared.openFile(media.originalFilePath)
    }

    @IBAction func didChangeFileNameTextField(_ sender: NSTextField) {
        guard var media = mediaStore.selectedMedia else {
            return
        }

        media.name = sender.stringValue
        media = mediaCoreDataService.update(media: media)
        mediaStore.update(media: media)

        DispatchQueue.main.async {
            // Unfocus text field
            sender.window?.makeFirstResponder(nil)
        }
    }
}

extension MediaSidebarViewController: MediaStoreDelegate {

    func didSelect(media: Media?) {
        guard let _ = media else {
            resetView()
            return
        }
        setupView()
    }

    func didUpdate(media: Media, at index: Int) {
        setupView()
    }
}
