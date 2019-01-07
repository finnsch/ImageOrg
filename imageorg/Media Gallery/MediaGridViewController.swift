//
//  ViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 21.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa
import AVKit
import Quartz
import QuickLook

protocol MediaGridDelegate: class {
    func didSelectItem(with media: Media?)
    func didSelectDetail(with media: Media?)
}

class MediaGridViewController: NSViewController {
    
    @IBOutlet weak var collectionView: MediaCollectionView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator! {
        didSet {
            progressIndicator.isHidden = true
        }
    }

    private let space: UInt16 = 0x31
    private let returnKey: UInt16 = 0x24

    var mediaItems: [Media] = []
    var selectedMedia: Media?
    var keyDownMonitor: Any!
    var sortOrder: SortOrder = .createdAt
    weak var delegate: MediaGridDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.customDelegate = self

        setupDragView()

        loadMedia()
    }

    override func viewDidAppear() {
        view.window?.makeFirstResponder(collectionView)

        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
    }

    override func viewDidDisappear() {
        NSEvent.removeMonitor(keyDownMonitor)
    }

    func setupDragView() {
        guard let dragView = DragView.createFromNib() else {
            return
        }
        view.addSubview(dragView)

        dragView.delegate = self
        dragView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dragView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            dragView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            dragView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            dragView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }

    func loadMedia() {
        collectionView.isHidden = true
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(self)

        if mediaItems.count > 0 {
            mediaItems = []
            collectionView.reloadData()
        }

        // Execute block on a background thread with a high priority
        DispatchQueue.global(qos: .userInitiated).async {
            let mediaCoreDataService = MediaCoreDataService()
            self.mediaItems = mediaCoreDataService.getMediaItems()

            self.reloadMediaItems()
            self.reloadCollectionView()
        }
    }

    func reloadMediaItems() {
        mediaItems = mediaItems.sorted(by: sortItems)
    }

    func reloadCollectionView() {
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }

            // Executes after collectionView has been layouted
            DispatchQueue.main.async {
                self.collectionView.isHidden = false
                // Scroll to the top
                self.collectionView.scroll(NSPoint.zero)
                self.progressIndicator.isHidden = true
                self.progressIndicator.stopAnimation(self)
            }
        }
    }

    func importMedia(filePaths: [String]) {
        let mediaFactory = MediaFactory()
        let mediaImporter = MediaLocalFileImporter(filePaths: filePaths, mediaFactory: mediaFactory)
        let _ = mediaImporter.importMedia()

        if let errorDescription = mediaImporter.errorDescription {
            showErrorAlert(with: errorDescription)
            return
        }

        loadMedia()
    }

    func showErrorAlert(with errorText: String) {
        let alert = NSAlert()
        alert.messageText = errorText
        alert.beginSheetModal(for: view.window!, completionHandler: nil)
    }

    func myKeyDown(with event: NSEvent) -> Bool {
        // handle keyDown only if current window has focus, i.e. is keyWindow
        guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return false }
        switch event.keyCode {
        case space where selectedMedia != nil:
            quickLook()
            return true
        case returnKey where selectedMedia != nil:
            showDetail()
            return true
        default:
            return false
        }
    }

    func quickLook() {
        QLPreviewPanel.shared()?.makeKeyAndOrderFront(self)
    }

    func showDetail() {
        delegate?.didSelectDetail(with: selectedMedia)
    }

    func sortItems(lhs: Media, rhs: Media) -> Bool {
        if sortOrder == .createdAt {
            return Date(date: lhs.creationDate).compare(Date(date: rhs.creationDate)) == .orderedDescending
        }

        return lhs.name.compare(rhs.name) == .orderedDescending
    }

    func showNext() {
        guard let index = mediaItems.firstIndex(where: { $0.id == selectedMedia!.id }) else {
            return
        }

        let nextIndex: Int = mediaItems.count <= index + 1 ? 0 : index + 1

        selectedMedia = mediaItems[nextIndex]
        showDetail()
    }

    func showPrevious() {
        guard let index = mediaItems.firstIndex(where: { $0.id == selectedMedia!.id }) else {
            return
        }

        let previousIndex: Int = 0 > index - 1 ? mediaItems.count - 1 : index - 1

        selectedMedia = mediaItems[previousIndex]
        showDetail()
    }
}

extension MediaGridViewController: MediaCollectionViewDelegate {

    func didSelect(sortOrder: SortOrder) {
        self.sortOrder = sortOrder
        reloadMediaItems()
        reloadCollectionView()
    }
}

extension MediaGridViewController: NSCollectionViewDelegate {

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        selectedMedia = nil

        delegate?.didSelectItem(with: nil)
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            print("Nothing selected")
            return
        }

        let media = mediaItems[indexPath.item]
        selectedMedia = media

        delegate?.didSelectItem(with: media)
    }
}

extension MediaGridViewController: NSCollectionViewDataSource {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {
            return item
        }
        let media = mediaItems[indexPath.item]

        collectionViewItem.title = media.name
        collectionViewItem.date = Date(date: media.creationDate)
        collectionViewItem.image = NSImage(byReferencingFile: media.thumbnail.filePath)
        collectionViewItem.onDoubleClick = { [weak self] in
            self?.selectedMedia = media
            self?.showDetail()
        }

        return collectionViewItem
    }
}

extension MediaGridViewController: QLPreviewPanelDataSource, QLPreviewPanelDelegate {

    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        return selectedMedia != nil
    }

    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        if let sharedPanel = QLPreviewPanel.shared() {
            sharedPanel.dataSource = self
            sharedPanel.delegate = self

            if let index = mediaItems.firstIndex(where: { $0.id == selectedMedia!.id }) {
                sharedPanel.currentPreviewItemIndex = index
            }
        }
    }

    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
        if let sharedPanel = QLPreviewPanel.shared() {
            sharedPanel.dataSource = nil
            sharedPanel.delegate = nil
        }
    }

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return mediaItems.count
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return mediaItems[index].originalFileURL as QLPreviewItem
    }
}

extension MediaGridViewController: DragViewDelegate {

    func didDrag(filePaths: [String]) {
        importMedia(filePaths: filePaths)
    }
}
