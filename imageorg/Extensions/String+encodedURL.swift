//
//  String+encodeURL.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

extension String {
    func encodedURL() -> URL? {
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }

        return URL(string: encodedString)
    }
}
