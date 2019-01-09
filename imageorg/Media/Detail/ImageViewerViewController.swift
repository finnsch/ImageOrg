//
//  ImageViewerViewController.swift
//  imageorg
//
//  Created by Finn Schlenk on 23.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class ImageViewerViewController: NSViewController {

    var currentMagnification: CGFloat = 1.0
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var imageView: NSImageView!

    var image: Image? {
        didSet {
            guard let _ = image else {
                return
            }

            setupImageView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.magnification = 1.0
    }

    func setupImageView() {
        imageView.image = NSImage(byReferencingFile: image!.filePath)
        imageView.animates = true
        imageView.wantsLayer = true
        imageView.layer?.masksToBounds = true
        imageView.layer?.backgroundColor = NSColor.black.cgColor
    }

    func zoomIn() {
        currentMagnification += 0.5
        scrollView.magnification = currentMagnification
    }

    func zoomOut() {
        if currentMagnification <= 1.0 {
            currentMagnification -= 0.2
        } else {
            currentMagnification -= 0.5
        }


        scrollView.magnification = currentMagnification
    }

    func zoomToFit() {
        currentMagnification = 1.0
        scrollView.magnification = currentMagnification
    }
}
