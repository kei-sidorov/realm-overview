//
//  ProductsListPresenter.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 21.09.2021.
//

import Foundation

final class ProductsListPresenter {
    enum ProductListEvent {
        case error
        case sort(completion: (([Product.Query]) -> Void))
        case detailScreen(currentProduct: Product?)
        case productCountChooserScreen(currentOrderId: String, currentProduct: Product)
        case basket(currentOrder: Order)
    }
    
    var coordinator: AnyRouter<ProductListEvent>?
    
    private(set) var productsList = [Product]()
    private(set) var tagsList = [Tag]()
    private(set) var currentOrder: Order?

    private let productStorage: ProductStorageProtocol
    private let orderStorage: OrderStorageProtocol
    private let tagStorage: TagStorageProtocol
    
    private var productNotificationToken: ObservationToken?
    private var tagNotificationToken: ObservationToken?
    
    private weak var view: ProductsListViewProtocol?
    
    init(
        productStorage: ProductStorageProtocol,
        orderStorage: OrderStorageProtocol,
        tagStorage: TagStorageProtocol
    ) {
        self.productStorage = productStorage
        self.orderStorage = orderStorage
        self.tagStorage = tagStorage
    }
}

extension ProductsListPresenter: ProductsListPresenterProtocol {
    
    // MARK: - View events
    
    func viewDidLoad(_ view: ProductsListViewProtocol) {
        self.view = view
        observeProducts(queries: [])
        observeTags(queries: [])
    }
    
    func viewDidAppear() {
        checkCurrentOrder()
    }
    
    // MARK: - User actions
    
    func didTapSort() {
        coordinator?.route(event: .sort { [weak self] queries in
            self?.observeProducts(queries: queries)
        })
    }
    
    func didChangeFilter(queries: [Product.Query]) {
        observeProducts(queries: queries)
    }
    
    func didTapPlusBarButton() {
        coordinator?.route(event: .detailScreen(currentProduct: .none))
    }
    
    func didTapCartBarButton() {
        guard let currentOrder = currentOrder else { return }
        coordinator?.route(event: .basket(currentOrder: currentOrder))
    }
    
    func didTapAddProduct(_ product: Product) {
        guard let currentOrder = currentOrder else { return }
        coordinator?.route(event: .productCountChooserScreen(currentOrderId: currentOrder.id, currentProduct: product))
    }
    
    func didTapDeleteProduct(at index: Int) {
        productStorage.remove(productsList[index]) { [weak self] result in
            if case .failure = result { self?.view?.updateProductsTableView() }
        }
    }
    
    func didSelectProduct(_ product: Product) {
        coordinator?.route(event: .detailScreen(currentProduct: product))
    }
    
    func didTapDeleteTag(at index: Int) {
        tagStorage.remove(tagsList[index]) { [weak self] result in
            if case .failure = result {
                self?.coordinator?.route(event: .error)
            }
        }
    }
}

// MARK: - Internal methods

private extension ProductsListPresenter {
    func checkCurrentOrder() {
        guard let order = currentOrder else {
            createEmptyOrder()
            return
        }
        orderStorage.getOrder(byId: order.id) { [weak self] result in
            let order = try? result.get()
            if order == nil || order?.status == .processing {
                self?.createEmptyOrder()
            }
        }
    }
    
    func createEmptyOrder() {
        let order = Order(
            id: UUID().uuidString,
            code: CodeGenerator.generate(),
            createdAt: Date(),
            status: .fillingUp,
            items: [OrderItem](),
            totalItems: 0,
            totalPrice: 0
        )
        orderStorage.save(order) { [weak self] result in
            if case .failure = result {
                self?.coordinator?.route(event: .error)
            }
        }
        self.currentOrder = order
    }
    
    func updateTagsList() {
        tagStorage.getTags(byQueries: .none) { [weak self] result in
            switch result {
            case .success(let tags):
                self?.tagsList = tags
                self?.view?.updateTagsCollectionView()
            case .failure:
                self?.coordinator?.route(event: .error)
            }
        }
    }
    
    // MARK: - Observation methods
    
    func observeProducts(queries: [Product.Query]) {
        productNotificationToken = productStorage.observeProducts(queries) { [weak self] result in
            switch result {
            case .success(let products):
                self?.productsList = products
                self?.view?.updateProductsTableView()
                self?.updateTagsList()
            case .failure:
                self?.coordinator?.route(event: .error)
            }
        }
    }
    
    func observeTags(queries: [Tag.Query]) {
        tagNotificationToken = tagStorage.observeTags(queries) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tags):
                self.tagsList = tags
                self.view?.updateTagsCollectionView()
            case .failure:
                self.coordinator?.route(event: .error)
            }
        }
    }
}


