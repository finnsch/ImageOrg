//
//  Data+sha256Hash.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

extension Data {
    public func sha256Hash() -> Data {
        let transform = SecDigestTransformCreate(kSecDigestSHA2, 256, nil)
        SecTransformSetAttribute(transform, kSecTransformInputAttributeName, self as CFTypeRef, nil)
        return SecTransformExecute(transform, nil) as! Data
    }

    public func uniqueHash() -> String {
        return sha256Hash().base64EncodedString()
    }
}
