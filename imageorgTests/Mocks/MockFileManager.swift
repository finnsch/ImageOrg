//
//  MockFileManager.swift
//  imageorgTests
//
//  Created by Finn Schlenk on 28.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Foundation

class MockFileManager: FileManager {

    private var fileAttributes: [FileAttributeKey : Any] = [:]

    init(fileAttributes: [FileAttributeKey : Any]) {
        super.init()

        self.fileAttributes = fileAttributes
    }

    override func attributesOfItem(atPath path: String) throws -> [FileAttributeKey : Any] {
        return self.fileAttributes
    }
}
