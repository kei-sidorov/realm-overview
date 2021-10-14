//
//  ProductCell.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 20.08.2021.
//

import UIKit

final class ProductCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBAction private func didTapAddButton(_ sender: UIButton) {
        tapHandler?()
    }
    
    static var reuseId: String {
        String(describing: self)
    }
    
    var tapHandler: (() -> Void)?
    
    func configure(_ model: Product) {
        nameLabel.text = model.title
        descriptionLabel.text = model.descriptionText
        priceLabel.text = String(describing: model.price.usd)
    }
}

