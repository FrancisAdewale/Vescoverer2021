//
//  Storyboarded.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 14/12/2020.
//

import UIKit

protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    // Creates a view controller from our storyboard. This relies on view controllers having the same storyboard identifier as their class name. This method shouldn't be overridden in conforming types.
    static func instantiate() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}

