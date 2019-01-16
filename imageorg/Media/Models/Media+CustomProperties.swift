//
//  Media+CustomProperties.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

extension Media {

    var fileSizeString: String {
        // bytes to kilobytes
        let fileSizeKB = Int(fileSize / 1000)

        if fileSizeKB > 1000 {
            // kilobytes to megabytes
            let fileSizeMB = Int(fileSizeKB / 1000)

            return "\(fileSizeMB) MB"
        }

        return "\(fileSizeKB) KB"
    }

    var originalFileURL: URL {
        return URL(fileURLWithPath: originalFilePath)
    }

    func deleteFromFileSystem() throws {
        guard let url = URL(string: filePath)?.deletingLastPathComponent() else {
            return
        }

        let fileManager = LocalFileManager()

        try fileManager.delete(path: url.path)
    }
}
