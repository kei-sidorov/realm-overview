//
//  ProductsCountChooserPresenter.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 22.09.2021.
//

import Foundation

final class ProductsCountChooserPresenter {
    enum ProductCountChooserEvent {
        case error
        case dismiss
    }
    
    var coordinator: AnyRouter<ProductCountChooserEvent>?
    
    private let orderStorage: OrderStorageProtocol
    private let currentOrderId: String
    private let currentProduct: Product
    private var currentOrder: Order?
    
    private var productCount = 0 {
        didSet {
            let price = currentProduct.price.usd
            let finalPrice = Decimal(productCount) * price
            view?.updateLabels(count: String(productCount), totalPrice: "\(finalPrice) $")
        }
    }
    
    private weak var view: ProductsCountChooserViewProtocol?
    
    init(
        orderStorage: OrderStorageProtocol,
        currentOrderId: String,
        currentProduct: Product
    ) {
        self.orderStorage = orderStorage
        self.currentOrderId = currentOrderId
        self.currentProduct = currentProduct
    }
}

extension ProductsCountChooserPresenter: ProductsCountChooserPresenterProtocol {
    
    // MARK: - View events
    
    func viewDidLoad(_ view: ProductsCountChooserViewProtocol) {
        self.view = view
        productCount = 1
        setupCurrentOrder()
    }
    
    // MARK: - User actions
    
    func didTapPlus() {
        guard productCount > 0 else { return }
        productCount += 1
    }
    
    func didTapMinus() {
        guard productCount > 1 else { return }
        productCount -= 1
    }
    
    func didTapDone() {
        appendNewItemToCurrentOrder()
        coordinator?.route(event: .dismiss)
    }
}

// MARK: - Internal methods

private extension ProductsCountChooserPresenter {
    func setupCurrentOrder() {
        orderStorage.getOrder(byId: currentOrderId) { [weak self] result in
            switch result {
            case .success(let order):
                self?.currentOrder = order
            case .failure:
                self?.coordinator?.route(event: .error)
            }
        }
    }
    
    func appendNewItemToCurrentOrder() {
        guard let currentOrder = currentOrder else { return }
        var orderItems = currentOrder.items
        orderItems.append(
            OrderItem(
                productId: currentProduct.id,
                price: currentProduct.price,
                count: productCount
            )
        )
        orderStorage.update(
            Order(
                id: currentOrder.id,
                code: currentOrder.code,
                createdAt: currentOrder.createdAt,
                status: currentOrder.status,
                items: orderItems,
                totalItems: orderItems.count,
                totalPrice: orderItems.reduce(0) { $0 + Decimal($1.count) * $1.price.usd }
            )
        ) { [weak self] result in
            if case .failure = result {
                self?.coordinator?.route(event: .error)
            }
        }
    }
}
