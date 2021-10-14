//
//  BasketPresenter.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 21.09.2021.
//

import Foundation

final class BasketPresenter {
    enum BasketListEvent {
        case ordersScreen
    }
    
    var coordinator: AnyRouter<BasketListEvent>?
    
    private(set) var orderItems: [OrderItemModel] = [] {
        didSet {
            view?.updateBasketTableView()
        }
    }

    private var order: Order {
        didSet {
            updateOrderItems(forOder: order)
        }
    }
    private let orderStorage: OrderStorageProtocol
    private let productsStorage: ProductStorageProtocol
    
    private weak var view: BasketViewProtocol?
    
    init(
        order: Order,
        orderStorage: OrderStorageProtocol,
        productsStorage: ProductStorageProtocol
    ) {
        self.order = order
        self.orderStorage = orderStorage
        self.productsStorage = productsStorage
        
        updateOrder()
    }
    
    private func updateOrder() {
        let id = order.id
        orderStorage.getOrder(byId: id) { [weak self] result in
            guard let order = try? result.get() else { return }
            self?.order = order
        }
    }
    
    private func updateOrderItems(forOder: Order) {
        self.orderItems = order.items.compactMap { item in
            guard let product = try? productsStorage.getProduct(byId: item.productId).get() else {
                return nil
            }
            return OrderItemModel(
                name: product.title,
                price: item.price,
                total: Price(usd: Decimal(item.count) * item.price.usd),
                count: item.count
            )
        }
    }
}

extension BasketPresenter: BasketPresenterProtocol {
    
    // MARK: - View events
    
    func viewDidLoad(_ view: BasketViewProtocol) {
        self.view = view
        view.updateBasketTableView()
    }
    
    // MARK: - User actions
    
    func didTapProcessButton() {
        let order = Order(
            id: order.id,
            code: order.code,
            createdAt: order.createdAt,
            status: .processing,
            items: order.items,
            totalItems: order.items.count,
            totalPrice: order.items.reduce(0) { $0 + Decimal($1.count) * $1.price.usd }
        )
        orderStorage.update(order) { [weak self] _ in
            DispatchQueue.main.async {
                self?.coordinator?.route(event: .ordersScreen)
            }
        }
    }
    
    func didDeleteItem(at index: Int) {
        var orderItems = order.items
        orderItems.remove(at: index)
        order = Order(
            id: order.id,
            code: order.code,
            createdAt: order.createdAt,
            status: order.status,
            items: orderItems,
            totalItems: orderItems.count,
            totalPrice: orderItems.reduce(0) { $0 + Decimal($1.count) * $1.price.usd }
        )
        orderStorage.update(order) { [view] _ in
            view?.updateBasketTableView()
        }
    }
}
