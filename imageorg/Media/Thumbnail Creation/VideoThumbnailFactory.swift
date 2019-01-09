//
//  VideoThumbnailFactory.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa
import AVKit

class VideoThumbnailFactory: ThumbnailFactory {

    static var size = NSSize(width: 460, height: 360)
    static var quality: Float = 0.7

    var localFileManager = LocalFileManager()
    var thumbnailCoreDataService = ThumbnailCoreDataService()

    func createThumbnailImage(from filePath: String) -> NSImage? {
        let asset = AVAsset(url: URL(fileURLWithPath: filePath))
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        var thumbnailImage: NSImage?

        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let frame = NSImage(cgImage: imageRef, size: NSZeroSize)
            thumbnailImage = frame.resized(to: VideoThumbnailFactory.size)
        } catch let error as NSError {
            print(error)
        }

        return thumbnailImage
    }
}
