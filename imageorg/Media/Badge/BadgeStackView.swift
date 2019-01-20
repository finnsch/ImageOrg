//
//  BadgeStackView.swift
//  imageorg
//
//  Created by Finn Schlenk on 19.01.19.
//  Copyright © 2019 Finn Schlenk. All rights reserved.
//

import Cocoa

class BadgeStackView: NSStackView, NibLoadable {

    var contentView: NSView! {
        return self
    }

    var badges: [Badge] = [] {
        didSet {
            setupView()
        }
    }

    func setupView() {
        alignment = .leading

        removesBadges()
        let badgeViews = createBadges()

        badgeViews.forEach({ view in
            self.addView(view, in: .leading)
        })
    }

    private func createBadges() -> [BadgeView] {
        return badges.compactMap({ badge -> BadgeView? in
            guard let badgeView = BadgeView.createFromNib() else {
                return nil
            }

            badgeView.badge = badge

            return badgeView
        })
    }

    private func removesBadges() {
        subviews.forEach({ self.removeView($0) })
    }
}
