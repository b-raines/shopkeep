//
//  LineItemView.swift
//  ShoppingList
//
//  Created by Brent Raines on 8/17/16.
//  Copyright © 2016 Brent Raines. All rights reserved.
//

import UIKit

class LineItemView: UIView {
    let categoryLabel = UILabel()
    let priceLabel = UILabel()
    
    convenience init(category: String, price: String?) {
        self.init(frame: CGRect.zero)
        let regularFont = [NSFontAttributeName: UIFont.systemFontOfSize(14)]
        let boldFont = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15)]
        let fontAttrs = category == "Total" ? boldFont : regularFont
        
        categoryLabel.attributedText = NSAttributedString(
            string: category,
            attributes: fontAttrs
        )
        
        if let price = price {
            priceLabel.attributedText = NSAttributedString(
                string: price,
                attributes: fontAttrs
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.numberOfLines = 0
        priceLabel.numberOfLines = 0
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .Left
        priceLabel.textAlignment = .Right
        
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        categoryLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 16).active = true
        categoryLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 16).active = true
        priceLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 16).active = true
        priceLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 16).active = true
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[categoryLabel]-40-[priceLabel]|",
            options: [],
            metrics: nil,
            views: ["categoryLabel": categoryLabel, "priceLabel": priceLabel]
        ))
    }
}
