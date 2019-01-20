//
//  MimeType.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

enum MimeType: String {
    case jpeg = "image/jpeg"
    case jpg = "image/jpg"
    case png = "image/png"
    case gif = "image/gif"
    case mp4 = "video/mp4"

    var isImage: Bool {
        switch self {
        case .jpeg, .jpg, .png:
            return true
        default:
            return false
        }
    }

    var isAnimatableImage: Bool {
        return self == .gif
    }

    var isVideo: Bool {
        return self == .mp4
    }

    var shortDescription: String {
        switch self {
        case .jpeg:
            return "jpeg"
        case .jpg:
            return "jpg"
        case .png:
            return "png"
        case .gif:
            return "gif"
        case .mp4:
            return "mp4"
        }
    }

    var color: NSColor? {
        switch self {
        case .jpeg, .jpg:
            return Colors.red
        case .png:
            return Colors.green
        case .gif:
            return Colors.blue
        case .mp4:
            return Colors.orange
        }
    }
}
