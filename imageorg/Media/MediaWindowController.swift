//
//  MediaWindowController.swift
//  imageorg
//
//  Created by Finn Schlenk on 22.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaWindowController: NSWindowController {

    @IBOutlet weak var mediaToolbar: MediaToolbar!

    var delete: (() -> ())?
    var goBack: (() -> ())?
    var toggleFavorite: (() -> ())?
    var toggleSidebar: (() -> ())?
    var zoomIn: (() -> ())?
    var zoomOut: (() -> ())?

    override func windowDidLoad() {
        super.windowDidLoad()
        
        setupView()

        guard let mediaGallerySplitViewController = storyboard?.instantiateController(withIdentifier: "MediaGallerySplitViewController") as? MediaSplitViewController else {
            return
        }

        let navigationController = NSNavigationController(rootViewController: mediaGallerySplitViewController)
        window?.contentViewController = navigationController
    }

    private func setupView() {
        window?.titleVisibility = .hidden
    }

    @IBAction func handleGoBackButton(_ sender: NSButton) {
        goBack?()
    }

    @IBAction func handleDeleteButton(_ sender: NSButton) {
        delete?()
    }

    @IBAction func handleFavoriteButton(_ sender: NSButton) {
        toggleFavorite?()
    }

    @IBAction func handleZoomInButton(_ sender: NSButton) {
        zoomIn?()
    }

    @IBAction func handleZoomOutButton(_ sender: NSButton) {
        zoomOut?()
    }
    
    @IBAction func handleSidebarButton(_ sender: NSButton) {
        toggleSidebar?()
    }
}
