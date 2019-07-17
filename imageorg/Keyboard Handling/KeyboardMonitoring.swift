//
//  KeyMonitoring.swift
//  imageorg
//
//  Created by Finn Schlenk on 11.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

protocol KeyboardMonitoring: class {

    var keyDownMonitor: Any! { get set }

    func subscribeToKeyboardEvents()
    func unsubscribeFromKeyboardEvents()
    func handleKeyDown(with event: NSEvent) -> Bool
}

extension KeyboardMonitoring {

    func subscribeToKeyboardEvents() {
        keyDownMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { [weak self] event in
            guard let strongSelf = self else {
                return nil
            }

            if strongSelf.handleKeyDown(with: event) {
                return nil
            } else {
                return event
            }
        })
    }

    func unsubscribeFromKeyboardEvents() {
        NSEvent.removeMonitor(keyDownMonitor!)
    }
}
