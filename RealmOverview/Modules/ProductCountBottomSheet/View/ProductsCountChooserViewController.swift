//
//  ProductsCountChooserViewController.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 24.08.2021.
//

import UIKit

final class ProductsCountChooserViewController: UIViewController {
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    @IBAction private func didTapPlusButton(_ sender: UIButton) {
        presenter.didTapPlus()
    }
    
    @IBAction private func didTapMinusButton(_ sender: UIButton) {
        presenter.didTapMinus()
    }
    
    @IBAction private func didTapDoneButton(_ sender: UIButton) {
        presenter.didTapDone()
    }
    
    var presenter: ProductsCountChooserPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(self)
    }
}

// MARK: - View protocol

extension ProductsCountChooserViewController: ProductsCountChooserViewProtocol {
    func updateLabels(count: String, totalPrice: String) {
        countLabel.text = count
        totalPriceLabel.text = totalPrice
    }
}
