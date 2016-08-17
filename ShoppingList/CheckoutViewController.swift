//
//  CheckoutViewController.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/17/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {

    // MARK: Properties
    let viewModel = ProductsViewModel()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideContentView(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for category in viewModel.categories() {
            let categoryAggregatePrice = viewModel
                .productsForCategory(category)
                .filter({ $0.complete })
                .map({ $0.priceInCents })
                .reduce(0, combine: +)
            if categoryAggregatePrice > 0 {
                stackView.addArrangedSubview(
                    LineItemView(category: category, price: CurrencyFormatter().displayPrice(categoryAggregatePrice))
                )
            }
        }
        
        let totalAggregatePrice = viewModel
            .products
            .value?
            .filter({ $0.complete })
            .flatMap({ $0.priceInCents })
            .reduce(0, combine: +)
        
        stackView.addArrangedSubview(
            LineItemView(category: "Total", price: CurrencyFormatter().displayPrice(totalAggregatePrice))
        )
    }
    
    func tappedOutsideContentView(sender: UIGestureRecognizer) {
        let tapLocation = sender.locationInView(view)
        if !contentView.pointInside(contentView.convertPoint(tapLocation, fromView: view), withEvent: nil) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
