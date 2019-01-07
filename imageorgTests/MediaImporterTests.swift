//
//  MediaImporterTests.swift
//  imageorgTests
//
//  Created by Finn Schlenk on 28.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import XCTest
@testable import imageorg

class MediaImporterTests: XCTestCase {

    var mediaImporter: MediaLocalFileImporter!

    override func setUp() {
    }

    override func tearDown() {
        mediaImporter = nil
    }

    func testImportMediaWithImage() {
        let image = createImage()
        let mediaImporter = createMediaImporter(for: image)

        let receivedMedia = mediaImporter.importMedia()

        XCTAssertEqual(receivedMedia[0], image)
    }

    func testImportMediaWithImageAndThumbnail() {
        let image = createImage()
        image.thumbnail = MockThumbnail(media: image)
        let mediaImporter = createMediaImporter(for: image, mockThumbnails: true)

        let receivedMedia = mediaImporter.importMedia()

        XCTAssertNotNil(receivedMedia[0].thumbnail)
        XCTAssertEqual(receivedMedia[0], image)
    }

    func testImportMediaWithVideo() {
        let video = createVideo()
        let mediaImporter = createMediaImporter(for: video)

        let receivedMedia = mediaImporter.importMedia()

        XCTAssertEqual(receivedMedia, [video])
    }

    func testImportMediaWithVideoAndThumbnail() {
        let video = createVideo()
        video.thumbnail = MockThumbnail(media: video)
        let mediaImporter = createMediaImporter(for: video, mockThumbnails: true)

        let receivedMedia = mediaImporter.importMedia()

        XCTAssertNotNil(receivedMedia[0].thumbnail)
        XCTAssertEqual(receivedMedia[0], video)
    }

    func testImportMediaWithUnsupportedType() {
        let webmVideo = createVideo()
        webmVideo.url = URL(staticString: "/Users/test/Pictures/video.webm")
        webmVideo.mimeType = "video/webm"
        let mediaImporter = createMediaImporter(for: webmVideo)

        let receivedMedia = mediaImporter.importMedia()

        XCTAssertEqual(receivedMedia.count, 0)
    }

    // MARK: - Helper methods

    func createImage() -> Media {
        let fileURL = URL(staticString: "/Users/test/Pictures/picture.jpeg")
        let creationDate = Date()
        let modificationDate = Date()
        let size = 1024
        let whereFrom: String? = "https://imgur.com"

        return Media(name: "picture", url: fileURL, size: size,
                     mimeType: "image/jpeg", thumbnail: nil, whereFrom: whereFrom,
                     creationDate: creationDate, modificationDate: modificationDate)
    }

    func createVideo() -> Media {
        let fileURL = URL(staticString: "/Users/test/Pictures/video.mp4")
        let creationDate = Date()
        let modificationDate = Date()
        let size = 10240
        let whereFrom: String? = "https://gfycat.com"

        return Media(name: "video", url: fileURL, size: size,
                     mimeType: "video/mp4", thumbnail: nil, whereFrom: whereFrom,
                     creationDate: creationDate, modificationDate: modificationDate)
    }

    func createMediaImporter(for media: Media, mockThumbnails: Bool = false) -> MediaLocalFileImporter {
        let fileAttributes = createFileAttributes(from: media)
        let mockFileManager = MockFileManager(fileAttributes: fileAttributes)
        let fileAttributesParser = FileAttributesParser(fileManager: mockFileManager)
        let mediaFactory = MediaFactory(fileAttributesParser: fileAttributesParser)

        if mockThumbnails {
            mediaFactory.createImageThumbnail = { media in
                return MockThumbnail(media: media)
            }
            mediaFactory.createVideoThumbnail = { media in
                return MockThumbnail(media: media)
            }
        }

        return MediaLocalFileImporter(filePaths: [media.url.absoluteString],
                             mediaFactory: mediaFactory)
    }

    func createFileAttributes(from media: Media) -> [FileAttributeKey: Any] {
        return [
            FileAttributeKey.creationDate: media.creationDate,
            FileAttributeKey.modificationDate: media.modificationDate,
            FileAttributeKey.size: media.size,
            FileAttributeKey(rawValue: "NSFileExtendedAttributes"): [
                "com.apple.metadata:kMDItemWhereFroms": media.whereFrom?.data(using: .utf8)
            ]
        ]
    }
}
