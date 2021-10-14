//
//  OrderCell.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 23.08.2021.
//

import UIKit

final class OrderCell: UITableViewCell {
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var totalItemsLabel: UILabel!
    
    static var reuseId: String {
        String(describing: self)
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        statusLabel.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
    }
    
    func configure(_ model: Order) {
        codeLabel.text = model.code
        createdDateLabel.text = "Created at: \(OrderCell.dateFormatter.string(from: model.createdAt))"
        totalItemsLabel.text = "Total items: \(model.totalItems) ($ \(model.totalPrice))"
        
        switch model.status {
        case .accepted:
            statusLabel.text = "Accepted"
            statusLabel.backgroundColor = .systemBlue
        case .done:
            statusLabel.text = "Done"
            statusLabel.backgroundColor = .systemGreen
        case .processing:
            statusLabel.text = "Processing"
            statusLabel.backgroundColor = .systemOrange
        case .unknown:
            statusLabel.text = "Unknown"
            statusLabel.backgroundColor = .black
        case .fillingUp:
            statusLabel.text = "Filling Up"
            statusLabel.backgroundColor = .systemBlue
        }
    }
}
