//
//  MediaFactory.swift
//  imageorg
//
//  Created by Finn Schlenk on 04.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaFactory {

    enum MediaError: Error {
        case notCreated
    }

    typealias CompletionHandler = (Result<Media, MediaImportError>) -> ()
    
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

    func createMedia(from url: URL, completionHandler handler: @escaping CompletionHandler) {
        self.sourceFileURL = url

        if url.mimeType.isImage() {
            return createImage(completionHandler: handler)
        } else if url.mimeType.isVideo() {
            return createVideo(completionHandler: handler)
        }

        handler(.failure(.typeNotSupported))
    }

    private func createImage(completionHandler handler: @escaping CompletionHandler) {
        let image = NSImage(byReferencing: sourceFileURL)
        var hashId: String!

        thumbnailFactory = ImageThumbnailFactory()

        guard image.isValid else {
            return handler(.failure(MediaImportError.imageInvalid))
        }

        do {
            hashId = try self.saveOnlyNewMedia()
        } catch let error as MediaImportError {
            return handler(.failure(error))
        } catch {}

        self.createThumbnail { result in
            guard let thumbnail = result.value else {
                return handler(.failure(result.error!))
            }

            let createdImage = self.mediaCoreDataService.createImage(
                hashId: hashId, name: self.sourceFileAttributes.name, description: nil,
                mimeType: self.sourceFileAttributes.mimeType, fileSize: self.sourceFileAttributes.size,
                filePath: self.destinationFilePath, originalFilePath: self.sourceFileURL.path,
                thumbnail: thumbnail
            )

            handler(.success(createdImage))
        }
    }

    private func createVideo(completionHandler handler: @escaping CompletionHandler) {
        var hashId: String!

        thumbnailFactory = VideoThumbnailFactory()

        do {
            hashId = try self.saveOnlyNewMedia()
        } catch let error as MediaImportError {
            return handler(.failure(error))
        } catch {}

        self.createThumbnail { result in
            guard let thumbnail = result.value else {
                return handler(.failure(result.error!))
            }

            let createdVideo = self.mediaCoreDataService.createVideo(
                hashId: hashId, name: self.sourceFileAttributes.name, description: nil,
                mimeType: self.sourceFileAttributes.mimeType, fileSize: self.sourceFileAttributes.size,
                filePath: self.destinationFilePath, originalFilePath: self.sourceFileURL.path,
                thumbnail: thumbnail
            )

            handler(.success(createdVideo))
        }
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

    private func createThumbnail(completionHandler handler: @escaping (Result<Thumbnail, MediaImportError>) -> ()) {
        thumbnailFactory.createThumbnail(from: sourceFileURL.path, saveAt: destinationDirectoryPath) { result in
            guard let thumbnail = result.value else {
                handler(.failure(MediaImportError.couldNotCreateThumbnail))
                return
            }

            handler(.success(thumbnail))
        }
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
