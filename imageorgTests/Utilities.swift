//
//  TemporaryFile.swift
//  imageorgTests
//
//  Created by Finn Schlenk on 28.12.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Foundation

func makeTemporaryFilePathForTest(named testName: String = #function) -> URL {
    let path = NSTemporaryDirectory() + "\(testName)"
    try? FileManager.default.removeItem(atPath: path)
    return URL(fileURLWithPath: path)
}
