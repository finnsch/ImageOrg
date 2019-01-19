//
//  MediaImporter.swift
//  imageorg
//
//  Created by Finn Schlenk on 28.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaLocalFileImporter {

    typealias CompletionHandler = (Result<[Media], MediaImportError>) -> ()

    private let localFileManager = LocalFileManager()
    private var filePaths: [String] = []
    private var fileURLs: [URL] = []
    private var media: [Media] = []
    private var importErrors: [MediaImportError] = []

    var handleProgress: (() -> ())?

    var errorDescription: String? {
        guard importErrors.count > 0 else {
            return nil
        }

        return importErrors
            .map({ $0.errorMessage })
            .joined(separator: "\n")
    }

    init(filePaths: [String]) {
        self.filePaths = filePaths
    }

    func importMedia(completionHandler handler: @escaping CompletionHandler) {
        getContentsOfPaths()
        createMedia(completionHandler: handler)
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

    private func createMedia(completionHandler handler: @escaping CompletionHandler) {
        let dispatchGroup = DispatchGroup()

        fileURLs.forEach({ url in
            dispatchGroup.enter()

            let mediaFactory = MediaFactory()
            mediaFactory.createMedia(from: url, completionHandler: { result in
                guard let media = result.value else {
                    self.importErrors.append(result.error!)
                    dispatchGroup.leave()

                    return
                }

                self.updateProgress()
                self.media.append(media)
                dispatchGroup.leave()
            })
        })

        dispatchGroup.notify(queue: .main) {
            handler(.success(self.media))
        }
    }

    private func updateProgress() {
        handleProgress?()
    }
}
