//
//  BasketCell.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 20.08.2021.
//

import UIKit

final class BasketItemCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    static var reuseId: String {
        String(describing: self)
    }
    
    func configure(_ model: OrderItemModel) {
        nameLabel.text = model.name
        descriptionLabel.text = "$ \(model.price.usd) ✖️ \(model.count) pcs."
        priceLabel.text = String(describing: model.total.usd)
    }
}

