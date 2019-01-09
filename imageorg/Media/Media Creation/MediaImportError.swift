//
//  MediaImportError.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

enum MediaImportError: Error {
    case typeNotSupported
    case imageInvalid
    case couldNotRead
    case couldNotSave
    case couldNotCreateThumbnail
    case alreadyExists(String)

    var errorMessage: String {
        switch self {
        case .alreadyExists(let name):
            return "Imported media \(name) already exists."
        case .couldNotCreateThumbnail:
            return "Could not create thumbnail."
        case .couldNotRead:
            return "Could not read file."
        case .couldNotSave:
            return "Could not save file."
        case .imageInvalid:
            return "Imported image is invalid."
        case .typeNotSupported:
            return "The media type is not supported."
        }
    }
}
