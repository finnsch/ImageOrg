//
//  FileAttributesParser.swift
//  imageorg
//
//  Created by Finn Schlenk on 28.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Foundation

class FileAttributesParser {

    var fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func parse(url: URL) -> FileAttributes {
        let dictionary = try! fileManager.attributesOfItem(atPath: url.path)
        let attributes = NSDictionary(dictionary: dictionary)

        let creationDate = attributes.fileCreationDate()!
        let modificationDate = attributes.fileModificationDate()!
        let mimeType = url.mimeType
        let fileExtension = url.pathExtension
        let name = url.deletingPathExtension().lastPathComponent
        let size = Int(attributes.fileSize())

        var whereFrom: String? = nil
        if let extendedAttributes = attributes["NSFileExtendedAttributes"] as? [String: Any],
            let whereFromData = extendedAttributes["com.apple.metadata:kMDItemWhereFroms"] as? Data {
            whereFrom = String(data: whereFromData, encoding: String.Encoding.utf8)
        }

        return FileAttributes(creationDate: creationDate, modificationDate: modificationDate,
                              mimeType: mimeType, name: name, size: size, url: url,
                              fileExtension: fileExtension, whereFrom: whereFrom)
    }
}
