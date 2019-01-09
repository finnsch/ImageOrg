//
//  MediaFactory.swift
//  imageorg
//
//  Created by Finn Schlenk on 04.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaFactory {
    
    private var localFileManager = LocalFileManager()
    private var thumbnailFactory: ThumbnailFactory = ImageThumbnailFactory()
    private var fileAttributesParser: FileAttributesParser
    private var mediaCoreDataService = MediaCoreDataService()

    private var sourceFileURL: URL!
    private var sourceFileAttributes: FileAttributes!
    private var destinationDirectoryPath: String!
    private var destinationFilePath: String!

    init(fileAttributesParser: FileAttributesParser = FileAttributesParser()) {
        self.fileAttributesParser = fileAttributesParser
    }

    func createMedia(from url: URL) throws -> Media {
        self.sourceFileURL = url

        if url.mimeType.isImage() {
            thumbnailFactory = ImageThumbnailFactory()
            return try createImage()
        } else if url.mimeType.isVideo() {
            thumbnailFactory = VideoThumbnailFactory()
            return try createVideo()
        }

        throw MediaImportError.typeNotSupported
    }

    private func createImage() throws -> Media {
        let image = NSImage(byReferencing: sourceFileURL)

        guard image.isValid else {
            throw MediaImportError.imageInvalid
        }

        let hashId = try saveOnlyNewMedia()
        let thumbnail = try createThumbnail()

        let createdImage = mediaCoreDataService.createImage(
            hashId: hashId, name: sourceFileAttributes.name, description: nil,
            mimeType: sourceFileAttributes.mimeType, fileSize: sourceFileAttributes.size,
            filePath: destinationFilePath, originalFilePath: sourceFileURL.path,
            thumbnail: thumbnail
        )

        return createdImage
    }

    private func createVideo() throws -> Media {
        let hashId = try saveOnlyNewMedia()
        let thumbnail = try createThumbnail()

        let createdVideo = mediaCoreDataService.createVideo(
            hashId: hashId, name: sourceFileAttributes.name, description: nil,
            mimeType: sourceFileAttributes.mimeType, fileSize: sourceFileAttributes.size,
            filePath: destinationFilePath, originalFilePath: sourceFileURL.path,
            thumbnail: thumbnail
        )

        return createdVideo
    }

    private func saveOnlyNewMedia() throws -> String {
        preparePaths()

        guard let data = readFile() else {
            throw MediaImportError.couldNotRead
        }

        let hashId = data.uniqueHash()
        guard !mediaCoreDataService.exists(with: hashId) else {
            throw MediaImportError.alreadyExists(sourceFileAttributes.name)
        }

        guard saveFile(data: data) else {
           throw MediaImportError.couldNotSave
        }

        return hashId
    }

    private func preparePaths() {
        sourceFileAttributes = fileAttributesParser.parse(url: sourceFileURL)
        destinationDirectoryPath = "\(Configuration.destinationPath)\(UUID().uuidString)/"
        destinationFilePath = "\(destinationDirectoryPath!)original.\(sourceFileAttributes.fileExtension)"
    }

    private func createThumbnail() throws -> Thumbnail {
        guard let thumbnail = thumbnailFactory.createThumbnail(from: sourceFileURL.path, saveAt: destinationDirectoryPath) else {
            throw MediaImportError.couldNotCreateThumbnail
        }

        return thumbnail
    }

    private func readFile() -> Data? {
        do {
            let data = try localFileManager.read(at: sourceFileURL.path)
            return data
        } catch {
            print(error)
            return nil
        }
    }

    private func saveFile(data: Data) -> Bool {
        do {
            try localFileManager.save(data: data, to: destinationFilePath)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
