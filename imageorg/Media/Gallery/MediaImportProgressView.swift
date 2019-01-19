//
//  MediaImportProgressView.swift
//  imageorg
//
//  Created by Finn Schlenk on 16.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class MediaImportProgressView: NSView, NibLoadable {

    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var progressTextField: NSTextField!
    
    var contentView: NSView! {
        return self
    }
}
