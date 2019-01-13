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

class MediaGridViewController: MediaViewController {
    
    @IBOutlet weak var collectionView: MediaCollectionView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator! {
        didSet {
            progressIndicator.isHidden = true
        }
    }

    private let space: UInt16 = 0x31
    private let returnKey: UInt16 = 0x24

    var keyDownMonitor: Any!
    var mediaStore = MediaStore.shared
    var mediaDetailCoordinator: MediaDetailCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupDragView()
        loadMedia()
    }

    override func viewDidAppear() {
        mediaStore.add(delegate: self)

        NSApplication.shared.keyWindow?.title = "Gallery"

        view.window?.makeFirstResponder(collectionView)

        setupMediaDetailCoordinator()
        subscribeToKeyboardEvents()
    }

    override func viewDidDisappear() {
        unsubscribeFromKeyboardEvents()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contextMenu.customDelegate = self
        collectionView.contextMenu.sortOrderMenu.customDelegate = self
        collectionView.register(
            CollectionViewItem.self,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem")
        )
    }

    private func setupDragView() {
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

    private func setupMediaDetailCoordinator() {
        guard mediaDetailCoordinator == nil else {
            return
        }

        mediaDetailCoordinator = MediaDetailCoordinator(mediaToolbar: mediaToolbar,
                                                        navigationController: navigationController)
    }

    func importMedia(filePaths: [String]) {
        let mediaFactory = MediaFactory()
        let mediaImporter = MediaLocalFileImporter(filePaths: filePaths, mediaFactory: mediaFactory)
        let importedMedia = mediaImporter.importMedia()

        if let errorDescription = mediaImporter.errorDescription {
            showErrorAlert(with: errorDescription)
            return
        }

        let indexPaths = createIndexPathsToInsertItemsAtTheFront(for: importedMedia)
        loadMedia(at: indexPaths)
    }

    private func showErrorAlert(with errorText: String) {
        let alert = NSAlert()
        alert.messageText = errorText
        alert.beginSheetModal(for: view.window!, completionHandler: nil)
    }

    private func createIndexPathsToInsertItemsAtTheFront<Item>(for items: [Item]) -> Set<IndexPath> {
        let indexPaths = items.enumerated().map({ (index, _) -> IndexPath in
            return IndexPath(item: index, section: 0)
        })

        return Set(indexPaths)
    }

    func loadMedia(at indexPaths: Set<IndexPath>? = nil) {
        enableLoadingState()

        let mediaCoreDataService = MediaCoreDataService()
        self.mediaStore.mediaItems = mediaCoreDataService.getMediaItems()
        self.updateCollectionView(at: indexPaths)

        // Executes after collectionView has been layouted
        DispatchQueue.main.async {
            self.disableLoadingState()
            // Scroll to the top
            self.collectionView.scroll(NSPoint.zero)
        }
    }

    func updateCollectionView(at indexPaths: Set<IndexPath>? = nil) {
        if let indexPaths = indexPaths {
            self.collectionView.insertItems(at: indexPaths)
        } else {
            self.collectionView.reloadData()
        }
    }

    private func enableLoadingState() {
        collectionView.isHidden = true
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(self)
    }

    private func disableLoadingState() {
        self.collectionView.isHidden = false
        self.progressIndicator.isHidden = true
        self.progressIndicator.stopAnimation(self)
    }

    func quickLook() {
        let mediaQuickLook = MediaQuickLook(frame: view.frame)
        view.addSubview(mediaQuickLook)
        mediaQuickLook.show()
        mediaQuickLook.handleClosePreviewPanel = {
            // Return focus to the collection view after the preview panel has been closed.
            // That way the collection view is navigatable by keyboard.
            self.view.window?.makeFirstResponder(self.collectionView)
        }
    }

    func showDetail() {
        mediaDetailCoordinator.createAndShowMediaDetailView()
    }
}

extension MediaGridViewController: ContextMenuDelegate {

    func didSelect(item: ContextMenuItem) {
        if item == .delete {
            let selectionIndexes = collectionView.selectionIndexPaths.map { $0.item }
            let mediaItems = mediaStore.getAll(at: selectionIndexes)
            let mediaDestructor = MediaDestructor(mediaItems: mediaItems)
            mediaDestructor.delete()
            collectionView.deleteItems(at: collectionView.selectionIndexPaths)
        }
    }
}

extension MediaGridViewController: SortOrderMenuDelegate {

    func didSelect(sortOrder: SortOrder) {
        mediaStore.sortItems(by: sortOrder)
        updateCollectionView()
    }
}

extension MediaGridViewController: NSCollectionViewDelegate {

    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        mediaStore.selectedMedia = nil
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            print("Nothing selected")
            return
        }

        let media = mediaStore.mediaItems[indexPath.item]
        mediaStore.selectedMedia = media
    }
}

extension MediaGridViewController: NSCollectionViewDataSource {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaStore.numberOfItems
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {
            return item
        }
        let media = mediaStore.mediaItems[indexPath.item]

        collectionViewItem.title = media.name
        collectionViewItem.isFavorite = media.isFavorite
        collectionViewItem.date = Date(date: media.creationDate)
        collectionViewItem.image = NSImage(byReferencingFile: media.thumbnail.filePath)
        collectionViewItem.onDoubleClick = { [weak self] in
            self?.mediaStore.selectedMedia = media
            self?.showDetail()
        }

        return collectionViewItem
    }
}

extension MediaGridViewController: DragViewDelegate {

    func didDrag(filePaths: [String]) {
        importMedia(filePaths: filePaths)
    }
}

extension MediaGridViewController: MediaStoreDelegate {

    func didUpdate(media: Media, at index: Int) {
        let indexPaths: Set<IndexPath> = [IndexPath(item: index, section: 0)]

        collectionView.reloadItems(at: indexPaths)
    }

    func didDelete(media: Media, at index: Int) {
        let indexPaths: Set<IndexPath> = [IndexPath(item: index, section: 0)]

        collectionView.deleteItems(at: indexPaths)
    }
}

extension MediaGridViewController: KeyboardMonitoring {

    func handleKeyDown(with event: NSEvent) -> Bool {
        // handle keyDown only if current window has focus, i.e. is keyWindow

        guard let locWindow = self.view.window, let firstResponder = view.window?.firstResponder,
            NSApplication.shared.keyWindow === locWindow,
            firstResponder is MediaCollectionView else { return false }
        switch event.keyCode {
        case space where mediaStore.selectedMedia != nil:
            quickLook()
            return true
        case returnKey where mediaStore.selectedMedia != nil:
            showDetail()
            return true
        default:
            return false
        }
    }
}
