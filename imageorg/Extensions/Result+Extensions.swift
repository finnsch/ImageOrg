//
//  Result+Extensions.swift
//  imageorg
//
//  Created by Finn Schlenk on 26.07.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

extension Result {

    var value: Success? {
        guard case .success(let value) = self else {
            return nil
        }

        return value
    }

    var error: Failure? {
        guard case .failure(let error) = self else {
            return nil
        }

        return error
    }
}
