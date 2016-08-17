//
//  ProductViewController.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/17/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProductViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    let product = MutableProperty<Product?>(nil)
    var disposables = [Disposable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        priceTextField.delegate = self
        categoryPicker.delegate = self
        categoryPicker.delegate = self
        
        disposables.append(product.producer.ignoreNil().startWithNext { [weak self] prod in
            self?.nameTextField.text = prod.title
            self?.priceTextField.text = CurrencyFormatter().displayPrice(prod.priceInCents)
        })
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 44))
        toolbar.tintColor = UIColor.darkGrayColor()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(handleDonePress))
        ]
        priceTextField.inputAccessoryView = toolbar
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideContentView(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func tappedOutsideContentView(sender: UIGestureRecognizer) {
        let tapLocation = sender.locationInView(view)
        if !contentView.pointInside(contentView.convertPoint(tapLocation, fromView: view), withEvent: nil) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func handleDonePress() {
        if priceTextField.isFirstResponder() {
            priceTextField.resignFirstResponder()
        }
    }
    
    @IBAction func addItem(sender: AnyObject) {
        guard let name = nameTextField.text, price = priceTextField.text else { return }
        let product = Product()
        product.title = name
        product.priceInCents = CurrencyFormatter().priceInCents(price) ?? 0
        product.subCategory = Product.allowedSubCategories[categoryPicker.selectedRowInComponent(0)]
        product.save()
        if product.errors.isEmpty {
            showInfoMessage(message: "\(name) Saved", completion: { [weak self] _ in
                self?.dismissViewControllerAnimated(true, completion: nil)
            })
        } else {
            var errorMessage = ""
            for error in product.errors {
                errorMessage += "\n\(error)"
            }
            showInfoMessage("Error", message: errorMessage, completion: nil)
        }
    }
    
    deinit {
        for disposable in disposables {
            disposable.dispose()
        }
    }
}

extension ProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameTextField {
            priceTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}

extension ProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Product.allowedSubCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Product.allowedSubCategories[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
