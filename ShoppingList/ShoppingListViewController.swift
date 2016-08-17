//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/16/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    // MARK: Properties
    let productCellIdentifier = "productCell"
    let viewModel = ProductsViewModel()
    
    @IBOutlet weak var productTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.delegate = self
        productTableView.dataSource = self
        
        viewModel.products.signal.observeNext { [weak self] _ in
            self?.productTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let productCell = sender as? ProductTableViewCell,
            productVC = segue.destinationViewController as? ProductViewController
            where segue.identifier == "editProducts" {
            productVC.product.value = productCell.product.value
        }
    }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.categories().count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.categories()[section]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let sectionCategory = viewModel.categories()[indexPath.section]
            viewModel.productsForCategory(sectionCategory)[indexPath.row].delete()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCategory = viewModel.categories()[section]
        return viewModel.productsForCategory(sectionCategory).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier, forIndexPath: indexPath)
        
        if let productCell = cell as? ProductTableViewCell {
            let sectionCategory = viewModel.categories()[indexPath.section]
            let product = viewModel.productsForCategory(sectionCategory)[indexPath.row]
            productCell.product.value = product
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let productCell = tableView.cellForRowAtIndexPath(indexPath) as? ProductTableViewCell {
            performSegueWithIdentifier("editProducts", sender: productCell)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
