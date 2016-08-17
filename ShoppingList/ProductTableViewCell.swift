//
//  ProductTableViewCell.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/16/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProductTableViewCell: UITableViewCell {
    let product = MutableProperty<Product?>(nil)
    var disposables = [Disposable]()
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        disposables.append(product.producer.ignoreNil().startWithNext { [weak self] prod in
            self?.productTitleLabel.text = prod.title
            self?.productPriceLabel.text = CurrencyFormatter().displayPrice(prod.priceInCents)
            let imageName = prod.complete ? "complete_checkbox" : "incomplete_checkbox"
            self?.checkboxButton.setImage(UIImage(named: imageName), forState: .Normal)
        })
    }
    
    @IBAction func toggleItemComplete(sender: AnyObject) {
        let currentState = product.value?.complete ?? false
        Persistence().write({ [weak self] _ in
            self?.product.value?.complete = !currentState
        }) { [weak self] error in
            self?.product.value?.errors.append(String(error))
        }
    }
    
    deinit {
        for disposable in disposables {
            disposable.dispose()
        }
    }
}
