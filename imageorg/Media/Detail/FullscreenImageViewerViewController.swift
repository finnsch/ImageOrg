//
//  FullscreenImageViewerViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 24.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class FullscreenImageViewerViewController: NSViewController {

    var imageViewerViewController: ImageViewerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
    }

    func setup(with image: Image) {
        imageViewerViewController = ImageViewerViewController(nibName: "ImageViewerViewController", bundle: Bundle.main)
        addChild(imageViewerViewController!)
        view.addSubview(imageViewerViewController!.view)

        imageViewerViewController!.image = image
        imageViewerViewController!.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageViewerViewController!.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageViewerViewController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageViewerViewController!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            imageViewerViewController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
}
