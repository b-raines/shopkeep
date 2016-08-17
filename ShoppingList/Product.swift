//
//  Product.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/16/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import Foundation

struct Product {
    static let persistenceKey = "products"
    let title: String
    let priceInCents: Int
    
    static func all() -> [Product] {
        return NSUserDefaults.standardUserDefaults().stringArrayForKey(persistenceKey)?.flatMap {
            return Product(title: $0)
        } ?? []
    }
    
    init(title: String) {
        self.title = title
        self.priceInCents = NSUserDefaults.standardUserDefaults().integerForKey(title)
    }
    
    func displayPrice() -> String? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter.stringFromNumber(Float(priceInCents)/100.0)
    }
}