//
//  Result.swift
//  imageorg
//
//  Created by Finn Schlenk on 06.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Foundation

enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)

    public typealias Success = Value
    public typealias Failure = Error
}

extension Result {

    var value: Value? {
        guard case .success(let value) = self else {
            return nil
        }

        return value
    }

    var error: Error? {
        guard case .failure(let error) = self else {
            return nil
        }

        return error
    }
}
