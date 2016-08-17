//
//  ProductsViewModel.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/16/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa
import Result

class ProductsViewModel {
    var notificationToken: NotificationToken?
    let products: AnyProperty<Results<Product>?>
    
    init() {
        let (signal, observer) = Signal<Results<Product>?, NoError>.pipe()
        let productResults = Persistence().objects(Product.self)
        notificationToken = productResults?.addNotificationBlock { changes in
            observer.sendNext(productResults)
        }
        
        products = AnyProperty(
            initialValue: Persistence().objects(Product.self),
            signal: signal
        )
    }
    
    func productsForCategory(category: String) -> [Product] {
        guard let productResults = products.value else { return [] }
        return Array(productResults.filter("subCategory == '\(category)'").sorted("complete", ascending: false))
    }
    
    func categories() -> [String] {
        guard let productResults = products.value else { return [] }
        let uniqueCategories = Set(productResults.flatMap { $0.subCategory })
        return Array(uniqueCategories).sort()
    }
    
    deinit {
        notificationToken?.stop()
    }
}