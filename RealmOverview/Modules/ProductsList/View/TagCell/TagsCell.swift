//
//  TagsCell.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 27.08.2021.
//

import UIKit

final class TagsCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    @IBAction private func didTapClearButton(_ sender: UIButton) {
        tapHandler?()
    }
    
    static var reuseId: String {
        String(describing: self)
    }
    
    var tapHandler: (() -> Void)?
    
    func configure(_ model: Tag) {
        titleLabel.text = model.title
        countLabel.text = model.count > 0 ? String(model.count) : ""
    }
}

