//
//  FileAttributes.swift
//  imageorg
//
//  Created by Finn Schlenk on 28.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Foundation

struct FileAttributes {

    var creationDate: Date
    var modificationDate: Date
    var mimeType: MimeType
    var name: String
    var size: Int
    var url: URL
    var fileExtension: String
    var whereFrom: String?
}
