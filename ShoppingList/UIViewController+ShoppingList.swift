//
//  UIViewController+ShoppingList.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/17/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import UIKit

extension UIViewController {
    func showInfoMessage(title: String? = nil, message: String? = nil, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        presentViewController(alert, animated: true, completion: { [weak self] _ in
            let delayTime = Double(message?.characters.count ?? 0) * 0.05
            delay(delayTime) {
                self?.dismissViewControllerAnimated(true, completion: {
                    completion?()
                })
            }
        })
    }
}