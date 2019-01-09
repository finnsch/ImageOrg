//
//  Media+CustomProperties.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

extension Media {

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
