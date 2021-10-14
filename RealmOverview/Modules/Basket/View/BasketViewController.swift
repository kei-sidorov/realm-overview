//
//  BasketViewController.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 20.08.2021.

import UIKit
import RealmSwift

final class BasketViewController: UIViewController {
    @IBOutlet private weak var productsTableView: UITableView!
    
    @IBAction private func didTapProcessButton(_ sender: UIBarButtonItem) {
        presenter.didTapProcessButton()
    }
    
    var presenter: BasketPresenterProtocol!
}

// MARK: - View events

extension BasketViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(self)
        configureUI()
    }
}

// MARK: - Table view configuration

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BasketItemCell.reuseId,
            for: indexPath
        ) as? BasketItemCell else {
            return UITableViewCell()
        }
        cell.configure(presenter.orderItems[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if case .delete = editingStyle {
            presenter.didDeleteItem(at: indexPath.item)
        }
    }
}

// MARK: - View protocol

extension BasketViewController: BasketViewProtocol {
    func updateBasketTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.productsTableView.reloadData()
        }
    }
}

// MARK: - View configuration

private extension BasketViewController {
    func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
    }
    
    func configureTableView() {
        productsTableView.register(
            UINib(nibName: "BasketItemCell", bundle: .none),
            forCellReuseIdentifier: BasketItemCell.reuseId
        )
    }
}
