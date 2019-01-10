//
//  NibLoadable.swift
//  imageorg
//
//  Created by Finn Schlenk on 24.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Cocoa

protocol NibLoadable {
    var contentView: NSView! { get }
    static var nibName: String? { get }
    static func createFromNib(in bundle: Bundle) -> Self?
}

extension NibLoadable where Self: NSView {

    static var nibName: String? {
        return String(describing: Self.self)
    }

    func createFromNib(in bundle: Bundle = Bundle.main) {
        guard let nibName = type(of: self).nibName else { return }

        let nib = NSNib(nibNamed: NSNib.Name(nibName), bundle: bundle)!
        nib.instantiate(withOwner: self, topLevelObjects: nil)

        let contentConstraints = contentView.constraints
        contentView.subviews.forEach({ addSubview($0) })

        for constraint in contentConstraints {
            let firstItem = (constraint.firstItem as? NSView == contentView) ? self : constraint.firstItem
            let secondItem = (constraint.secondItem as? NSView == contentView) ? self : constraint.secondItem
            addConstraint(NSLayoutConstraint(item: firstItem as Any, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
        }
    }

    static func createFromNib(in bundle: Bundle = Bundle.main) -> Self? {
        guard let nibName = nibName else { return nil }
        var topLevelArray: NSArray? = nil
        bundle.loadNibNamed(NSNib.Name(nibName), owner: self, topLevelObjects: &topLevelArray)
        guard let results = topLevelArray else { return nil }
        let views = Array<Any>(results).filter { $0 is Self }
        return views.last as? Self
    }
}
