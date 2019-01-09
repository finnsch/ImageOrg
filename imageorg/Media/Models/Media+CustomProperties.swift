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
        return URL(string: originalFilePath)!
    }
}
