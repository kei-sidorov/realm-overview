//
//  OrderListViewController.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 23.08.2021.
//

import UIKit

final class OrderListViewController: UIViewController {
    @IBOutlet private weak var ordersTableView: UITableView!
    
    @IBAction private func didTapFilterBarButton(_ sender: UIBarButtonItem) {
        presenter.didTapFilter()
    }
    
    private let searchController = UISearchController()
    var presenter: OrdersListPresenterProtocol!
}

// MARK: - View events

extension OrderListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(self)
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
}

// MARK: Table view configuration

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.ordersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OrderCell.reuseId,
            for: indexPath
        ) as? OrderCell else {
            return UITableViewCell()
        }
        cell.configure(presenter.ordersList[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            presenter.didTapDeleteOrder(at: indexPath.item)
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ordersTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Search bar configuration

extension OrderListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didChangeFilter(queries: [.code(searchText)])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.didChangeFilter(queries: [])
    }
}

// MARK: - View protocol

extension OrderListViewController: OrdersListViewProtocol {
    func updateOrdersTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.ordersTableView.reloadData()
        }
    }
}

// MARK: - View configuration

private extension OrderListViewController {
    func configureUI() {
        title = "Orders List"
        navigationController?.navigationBar.prefersLargeTitles = true
        ordersTableView.register(UINib(nibName: "OrderCell", bundle: .none), forCellReuseIdentifier: OrderCell.reuseId)
        configureSearchBar()
    }
    
    func configureSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Code"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}
