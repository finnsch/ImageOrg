//
//  MockImageThumbnail.swift
//  imageorgTests
//
//  Created by Finn Schlenk on 31.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa
@testable import imageorg

class MockThumbnail: Thumbnail {
    var image: NSImage

    static var size: NSSize = NSSize(width: 1, height: 1)

    required init?(media: Media) {
        self.image = NSImage(size: MockThumbnail.size)
    }
}
