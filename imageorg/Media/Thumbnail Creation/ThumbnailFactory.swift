//
//  ThumbnailFactory.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

protocol ThumbnailFactory {

    static var size: NSSize { get }
    static var quality: Float { get set }
    var localFileManager: LocalFileManager { get set }
    var thumbnailCoreDataService: ThumbnailCoreDataService { get set }

    func createThumbnail(from filePath: String, saveAt directoryPath: String) -> Thumbnail?
    func createThumbnailImage(from filePath: String) -> NSImage?
    func persistThumbnail(image: NSImage, to directoryPath: String) -> String
}

extension ThumbnailFactory {

    func createThumbnail(from filePath: String, saveAt directoryPath: String) -> Thumbnail? {
        guard let image = createThumbnailImage(from: filePath) else {
            return nil
        }

        let destinationFilePath = persistThumbnail(image: image, to: directoryPath)
        let thumbnail = thumbnailCoreDataService.createThumbnail(filePath: destinationFilePath,
                                                                 width: Float(image.size.width),
                                                                 height: Float(image.size.height))

        return thumbnail
    }

    func persistThumbnail(image: NSImage, to directoryPath: String) -> String {
        let filePath = "\(directoryPath)thumbnail.jpg"
        let compressedThumbnailData = image.compressedData(quality: Self.quality)

        try? localFileManager.save(data: compressedThumbnailData, to: filePath)

        return filePath
    }
}
