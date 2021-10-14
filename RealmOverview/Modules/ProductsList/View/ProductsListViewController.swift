//
//  ProductsListViewController.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 20.08.2021.

import UIKit
import RealmSwift

final class ProductsListViewController: UIViewController {
    @IBOutlet private weak var productsTableView: UITableView!
    @IBOutlet private weak var tagsCollectionView: UICollectionView!
    
    @IBAction private func didTapSortBarButton(_ sender: UIBarButtonItem) {
        presenter.didTapSort()
    }
    
    @IBAction private func didTapPlusBarButton(_ sender: UIBarButtonItem) {
        presenter?.didTapPlusBarButton()
    }
    
    @IBAction private func didTapCartBarButton(_ sender: UIBarButtonItem) {
        presenter?.didTapCartBarButton()
    }
    
    var presenter: ProductsListPresenterProtocol!
}

// MARK: - View events

extension ProductsListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(self)
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

// MARK: - Table view configuration

extension ProductsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductCell.reuseId,
            for: indexPath
        ) as? ProductCell else {
            return UITableViewCell()
        }
        cell.configure(presenter.productsList[indexPath.item])
        cell.tapHandler = { [weak self] in
            guard let self = self else { return }
            self.presenter.didTapAddProduct(self.presenter.productsList[indexPath.item])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
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
            presenter.didTapDeleteProduct(at: indexPath.item)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectProduct(presenter.productsList[indexPath.item])
    }
}

// MARK: - Search bar configuration

extension ProductsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didChangeFilter(queries: [.title(searchText)])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.didChangeFilter(queries: [])
    }
}

// MARK: - View protocol

extension ProductsListViewController: ProductsListViewProtocol {
    func updateProductsTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.productsTableView.reloadData()
        }
    }
    
    func updateTagsCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.tagsCollectionView.reloadData()
        }
    }
}

// MARK: - Collection view configuration

extension ProductsListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.tagsList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagsCell.reuseId,
            for: indexPath
        ) as? TagsCell else {
            return UICollectionViewCell()
        }
        cell.configure(presenter.tagsList[indexPath.item])
        cell.tapHandler = { [weak self] in
            self?.presenter.didTapDeleteTag(at: indexPath.item)
        }
        return cell
    }
}

// MARK: - View configuration

private extension ProductsListViewController {
    func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
        configureCollectionView()
    }
    
    func configureTableView() {
        productsTableView.register(
            UINib(nibName: "ProductCell", bundle: .none),
            forCellReuseIdentifier: ProductCell.reuseId
        )
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 50, height: 35)
        tagsCollectionView.collectionViewLayout = layout
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.showsHorizontalScrollIndicator = false
        tagsCollectionView.register(
            UINib(nibName: "TagsCell", bundle: .none),
            forCellWithReuseIdentifier: TagsCell.reuseId
        )
    }
}
