//
//  ImageTransformer.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

@objc(ImageTransformer)
class ImageTransformer: ValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        return NSImage(data: data)
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? NSImage else { return nil }

        return image.tiffRepresentation
    }
}
