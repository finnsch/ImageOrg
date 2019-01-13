//
//  MediaDetailCoordinator.swift
//  imageorg
//
//  Created by Finn Schlenk on 11.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaDetailCoordinator {

    var mediaStore = MediaStore.shared
    var mediaToolbar: MediaToolbar?
    var navigationController: NSNavigationController?

    init(mediaToolbar: MediaToolbar?, navigationController: NSNavigationController?) {
        self.mediaToolbar = mediaToolbar
        self.navigationController = navigationController

        mediaStore.add(delegate: self)
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

        setupToolbar()

        navigationController?.pushViewController(mediaDetailSplitViewController, animated: false)
    }
}

extension MediaDetailCoordinator: MediaStoreDelegate {

    func didSelectPrevious() {
        navigationController?.popViewController(animated: false)
        createAndShowMediaDetailView()
    }

    func didSelectNext() {
        navigationController?.popViewController(animated: false)
        createAndShowMediaDetailView()
    }
}
