//
//  LocalFileManager.swift
//  imageorg
//
//  Created by Finn Schlenk on 29.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Foundation

class LocalFileManager {

    enum FileManagerError: Error {
        case invalidPath
        case fileExists
        case fileDoesNotExist
        case fileNotCreated
        case fileGotNoContents
        case directoryNotCreated
    }

    let fileManager = FileManager.default

    func read(at path: String) throws -> Data {
        guard fileManager.fileExists(atPath: path) else {
            throw FileManagerError.fileDoesNotExist
        }

        guard let data = fileManager.contents(atPath: path) else {
            throw FileManagerError.fileGotNoContents
        }

        return data
    }

    func save(data: Data?, to path: String) throws {
        guard !fileManager.fileExists(atPath: path) else {
            throw FileManagerError.fileExists
        }

        guard let directoryPath = stripFileName(fromPath: path) else {
            throw FileManagerError.invalidPath
        }

        try createDirectory(atPath: directoryPath)

        guard fileManager.createFile(atPath: path, contents: data) else {
            throw FileManagerError.fileNotCreated
        }
    }

    func contents(of path: String) throws -> [URL] {
        let url = URL(fileURLWithPath: path)

        // if the url is a directory
        if url.hasDirectoryPath {
            let urls = try getContentsOfDirectory(at: url)
            return urls
        }

        return [url]
    }

    private func getContentsOfDirectory(at url: URL) throws -> [URL] {
        do {
            let urls = try fileManager.contentsOfDirectory(at: url,
                                                           includingPropertiesForKeys: nil,
                                                           options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            return urls
        } catch {
            throw FileManagerError.invalidPath
        }
    }

    private func stripFileName(fromPath path: String) -> String? {
        guard let url = URL(string: path), let pathWithoutFilename = url.pathWithoutFilename else {
            return nil
        }

        return pathWithoutFilename.absoluteString
    }

    private func createDirectory(atPath path: String) throws {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        } catch {
            throw FileManagerError.directoryNotCreated
        }
    }
}
