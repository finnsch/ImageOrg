//
//  MediaImporter.swift
//  imageorg
//
//  Created by Finn Schlenk on 28.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaLocalFileImporter {

    private let localFileManager = LocalFileManager()
    private var filePaths: [String] = []
    private var fileURLs: [URL] = []
    private var media: [Media] = []
    private var mediaFactory: MediaFactory
    private var importErrors: [MediaImportError] = []

    var errorDescription: String? {
        guard importErrors.count > 0 else {
            return nil
        }

        return importErrors
            .map({ $0.errorMessage })
            .joined(separator: "\n")
    }

    init(filePaths: [String], mediaFactory: MediaFactory) {
        self.filePaths = filePaths
        self.mediaFactory = mediaFactory
    }

    func importMedia() -> [Media] {
        getContentsOfPaths()
        createMedia()

        return self.media
    }

    private func getContentsOfPaths() {
        do {
            self.fileURLs = try self.filePaths
                .flatMap({ filePath in
                    return try localFileManager.contents(of: filePath)
                })
        } catch {
            print(error)
        }
    }

    private func createMedia() {
        do {
            self.media = try self.fileURLs.map({ url in
                return try mediaFactory.createMedia(from: url)
            })
        } catch let error as MediaImportError {
            self.importErrors = [error]
        } catch {
            print(error)
        }
    }
}
