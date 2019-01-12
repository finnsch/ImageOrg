//
//  CollectionViewItem.swift
//  imageorg
//
//  Created by Finn Schlenk on 21.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var dateTextField: NSTextField!
    @IBOutlet weak var heartView: HeartView! {
        didSet {
            heartView.isHidden = true
        }
    }

    var onDoubleClick: (() -> Void)?
    @objc dynamic var date: Date?
    @objc dynamic var dateString: String? {
        return date?.toString()
    }
    var isFavorite: Bool = false {
        didSet {
            guard isFavorite else {
                heartView.isHidden = true
                return
            }

            heartView.isHidden = false
        }
    }
    var image: NSImage? {
        didSet {
            guard isViewLoaded else { return }
            if let image = image {
                imageView?.image = image
            } else {
                imageView?.image = nil
            }
        }
    }

    override var title: String? {
        didSet {
            titleTextField.stringValue = title ?? ""
        }
    }

    override var isSelected: Bool {
        didSet {
            guard let imageView = imageView as? CustomImageView else {
                return
            }

            imageView.isSelected = isSelected
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.cornerRadius = 2.0
        view.layer?.masksToBounds = true
    }

    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)

        if theEvent.clickCount == 2 {
            onDoubleClick?()
        }
    }

    func makeContextMenu(event: NSEvent) {
        let menu = NSMenu(title: "Options")

        let sortByDateItem = NSMenuItem(title: "Sort by date", action: #selector(sortByDate), keyEquivalent: "")
        let sortByTitleItem = NSMenuItem(title: "Sort by title", action: #selector(sortByTitle), keyEquivalent: "")

        menu.addItem(sortByDateItem)
        menu.addItem(sortByTitleItem)

        NSMenu.popUpContextMenu(menu, with: event, for: view)
    }

    @objc func sortByDate() {
        print("sort by date")
    }

    @objc func sortByTitle() {
        print("sort by title")
    }

    // Enables us to bind `dateTextField`'s value to the computed property of `dateString`
    // StackOverflow: https://stackoverflow.com/questions/35892657/swift-cocoa-binding-value-to-a-computed-property-does-not-work
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if key == "dateString" {
            return Set(["date"])
        }

        return super.keyPathsForValuesAffectingValue(forKey: key)
    }
}
