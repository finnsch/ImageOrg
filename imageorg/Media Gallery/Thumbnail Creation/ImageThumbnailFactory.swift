//
//  ImageThumbnailFactory.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class ImageThumbnailFactory: ThumbnailFactory {

    static var size = NSSize(width: 460, height: 360)
    static var quality: Float = 1.0

    var localFileManager = LocalFileManager()
    var thumbnailCoreDataService = ThumbnailCoreDataService()

    func createThumbnailImage(from filePath: String) -> NSImage? {
        guard let image = NSImage(byReferencingFile: filePath), image.isValid,
            let thumbnailImage = image.resized(to: ImageThumbnailFactory.size) else {
            return nil
        }

        return thumbnailImage
    }
}
