//
//  ThumbnailFactory.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

enum ThumbnailError: Error {
    case notCreated
}

protocol ThumbnailFactory {

    static var size: NSSize { get }
    static var quality: Float { get set }
    var localFileManager: LocalFileManager { get set }
    var thumbnailCoreDataService: ThumbnailCoreDataService { get set }

    func createThumbnail(from filePath: String, saveAt directoryPath: String, completionHandler handler: @escaping (Result<Thumbnail, ThumbnailError>) -> ())
    func createThumbnailImage(from filePath: String, completionHandler handler: @escaping (Result<NSImage, ThumbnailError>) -> ())
    func persistThumbnail(image: NSImage, to directoryPath: String) -> String
}

extension ThumbnailFactory {

    func createThumbnail(from filePath: String, saveAt directoryPath: String, completionHandler handler: @escaping (Result<Thumbnail, ThumbnailError>) -> ()) {
        createThumbnailImage(from: filePath) { result in
            DispatchQueue.main.async {
                guard let image = result.value else {
                    return handler(.failure(result.error!))
                }

                let destinationFilePath = self.persistThumbnail(image: image, to: directoryPath)
                let thumbnail = self.thumbnailCoreDataService.createThumbnail(filePath: destinationFilePath,
                                                                         width: Float(image.size.width),
                                                                         height: Float(image.size.height))

                handler(.success(thumbnail))
            }
        }
    }

    func persistThumbnail(image: NSImage, to directoryPath: String) -> String {
        let filePath = "\(directoryPath)thumbnail.jpg"
        let compressedThumbnailData = image.compressedData(quality: Self.quality)

        try? localFileManager.save(data: compressedThumbnailData, to: filePath)

        return filePath
    }
}
