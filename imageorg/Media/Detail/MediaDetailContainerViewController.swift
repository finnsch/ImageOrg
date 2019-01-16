//
//  MediaDetailContainerViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 11.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaDetailContainerViewController: NSViewController {

    @IBOutlet weak var containerView: NSView!

    var mediaStore = MediaStore.shared
    var mediaDetailSplitViewController: MediaSplitViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        createAndShowMediaDetailView()
        mediaStore.add(delegate: self)
    }

    override func viewDidAppear() {
        setupToolbar()
    }

    func setupToolbar() {
        guard let mediaToolbar = mediaToolbar, let media = mediaStore.selectedMedia else {
            return
        }

        let configuration = MediaDetailToolbarConfiguration(toolbar: mediaToolbar, isFavorite: media.isFavorite, isImage: media is Image)
        mediaToolbar.replaceItems(for: configuration)
    }

    func createAndShowMediaDetailView() {
        guard let mediaDetailSplitViewController = NSStoryboard.main?.instantiateController(withIdentifier: "MediaDetailSplitViewController") as? MediaSplitViewController else {
            return
        }


        self.mediaDetailSplitViewController = mediaDetailSplitViewController
        embedChildViewController(mediaDetailSplitViewController, container: containerView)
    }
}

extension MediaDetailContainerViewController: MediaStoreDelegate {

    func didSelectPrevious() {
        if let mediaDetailSplitViewController = mediaDetailSplitViewController {
            unembedChildViewController(mediaDetailSplitViewController)
        }

        setupToolbar()
        createAndShowMediaDetailView()
    }

    func didSelectNext() {
        if let mediaDetailSplitViewController = mediaDetailSplitViewController {
            unembedChildViewController(mediaDetailSplitViewController)
        }

        setupToolbar()
        createAndShowMediaDetailView()
    }
}
