//
//  DetailProductPresenter.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 05.10.2021.
//

import Foundation

enum DetailProductState {
    case addNewProduct
    case editProduct
}

final class DetailProductPresenter {
    enum DetailProductEvent {
        case error
        case back
    }
    
    var coordinator: AnyRouter<DetailProductEvent>?
    
    let currentProduct: Product?
    private(set) var tagsList: [Tag]
    
    private let productStorage: ProductStorageProtocol
    
    private weak var view: DetailProductViewProtocol?
    
    init(productStorage: ProductStorageProtocol, currentProduct: Product?) {
        self.productStorage = productStorage
        self.currentProduct = currentProduct
        self.tagsList = currentProduct?.tags ?? []
    }
}

extension DetailProductPresenter: DetailProductPresenterProtocol {
    
    // MARK: - View events
    
    func viewDidLoad(_ view: DetailProductViewProtocol) {
        self.view = view
        if currentProduct == nil {
            view.setupTitle("New product")
        } else {
            view.setupTitle("Edit product")
            setupUI()
        }
    }
    
    // MARK: - User actions
    
    func didTapAddTag(title: String) {
        guard !title.isEmpty, !tagsList.contains(where: { $0.title == title }) else { return }
        let tag = Tag(id: UUID().uuidString, title: title, count: 0)
        tagsList.append(tag)
        view?.updateTagsCollectionView()
    }
    
    func didTapSave(title: String?, description: String?, price: String?) {
        let product = createProduct(title: title, description: description, price: price)
        saveOrUpdateProduct(product)
        view?.updateTagsCollectionView()
        coordinator?.route(event: .back)
    }
    
    func didTapDeleteTag(at index: Int) {
        tagsList.remove(at: index)
        view?.updateTag(at: index)
    }
}

// MARK: - Internal methods

private extension DetailProductPresenter {
    func setupUI() {
        guard let currentProduct = currentProduct else { return }
        view?.setupLabels(
            title: currentProduct.title,
            description: currentProduct.descriptionText,
            price: "\(currentProduct.price.usd)"
        )
    }
    
    func createProduct(title: String?, description: String?, price: String?) -> Product {
        Product(
            id: currentProduct?.id ?? UUID().uuidString,
            title: title ?? "",
            descriptionText: description ?? "",
            price: Price(usd: Decimal(string: price ?? "") ?? 0),
            tags: tagsList)
    }
    
    func saveOrUpdateProduct(_ product: Product) {
        if currentProduct == nil {
            productStorage.save(product) { [weak self] result in
                if case .failure = result {
                    self?.coordinator?.route(event: .error)
                }
            }
        } else {
            productStorage.update(product) { [weak self] result in
                if case .failure = result {
                    self?.coordinator?.route(event: .error)
                }
            }
        }
    }
}
