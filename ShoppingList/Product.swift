//
//  Product.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/16/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa
import Result

class Product: Object {
    enum Error {
        case IncorrectCategory(category: String)
        case EmptyTitle
        
        var message: String {
            switch self {
            case .IncorrectCategory(let category):
                return "\(category) is not an allowed category"
            case .EmptyTitle:
                return "You must enter a name"
            }
        }
    }
    
    dynamic var title: String = ""
    dynamic var priceInCents: Int = 0
    dynamic var complete: Bool = false
    dynamic var subCategory: String = "Other"
    var errors = [String]()
    
    static let allowedSubCategories = ["Dairy", "Bread", "Produce", "Meat", "Frozen", "Other"]
    
    override static func ignoredProperties() -> [String] {
        return ["errors"]
    }
    
    func save(update update: Bool = false, errorHandler: ((ErrorType) -> ())? = nil) {
        errors = []
        validate()
        guard errors.isEmpty else { return }
        Persistence().add(self, update: update) { [weak self] error in
            self?.errors.append(String(error))
        }
    }
    
    func delete() {
        Persistence().delete(self)
    }
    
    private func validate() -> Bool {
        var valid = true
        if !Product.allowedSubCategories.contains(subCategory) {
            errors.append(Error.IncorrectCategory(category: subCategory).message)
            valid = false
        }
        if title.isEmpty {
            errors.append(Error.EmptyTitle.message)
            valid = false
        }
        
        return valid
    }
}