//
//  MimeType.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

typealias MimeType = String

extension MimeType {
    func isImage() -> Bool {
        let imageTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif"]

        return imageTypes.contains(self)
    }

    func isAnimatableImage() -> Bool {
        let imageTypes = ["image/gif"]

        return imageTypes.contains(self)
    }

    func isVideo() -> Bool {
        let videoTypes = ["video/mp4"]

        return videoTypes.contains(self)
    }
}
