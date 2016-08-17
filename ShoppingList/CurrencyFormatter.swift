//
//  CurrencyFormatter.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/17/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import Foundation

struct CurrencyFormatter {
    func priceInCents(displayPrice: String?) -> Int? {
        guard let displayPrice = displayPrice else { return nil }
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let priceInDollars = formatter.numberFromString(displayPrice)?.doubleValue ?? 0
        return Int(priceInDollars * 100)
    }
    
    func displayPrice(priceInCents: Int?) -> String? {
        guard let priceInCents = priceInCents else { return nil }
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter.stringFromNumber(Float(priceInCents)/100.0)
    }
}