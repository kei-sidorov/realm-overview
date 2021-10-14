//
//  OrdersListPresenter.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 04.10.2021.
//

import Foundation

final class OrdersListPresenter {
    enum OrderListEvent {
        case error
        case filter(completion: (([Order.Query]) -> Void))
    }
    
    var coordinator: AnyRouter<OrderListEvent>?
    
    private(set) var ordersList = [Order]()
    
    private var orderNotificationToken: ObservationToken?
    private let orderStorage: OrderStorageProtocol
    private let productStorage: ProductStorageProtocol
    
    private weak var view: OrdersListViewProtocol?
    
    init(
        orderStorage: OrderStorageProtocol,
        productStorage: ProductStorageProtocol
    ) {
        self.orderStorage = orderStorage
        self.productStorage = productStorage
    }
}

extension OrdersListPresenter: OrdersListPresenterProtocol {
    
    // MARK: - View events
    
    func viewDidLoad(_ view: OrdersListViewProtocol) {
        self.view = view
        observeOrders(queries: [])
    }
    
    func viewDidDisappear() {
        /// This method is called only for resetting observation token to no queries, because there is no reset option in sort alert controller
        observeOrders(queries: [])
    }
    
    // MARK: - User actions
    
    func didTapDeleteOrder(at index: Int) {
        orderStorage.remove(ordersList[index]) { [weak self] result in
            if case .failure = result {
                self?.coordinator?.route(event: .error)
            }
        }
    }
    
    func didChangeFilter(queries: [Order.Query]) {
        observeOrders(queries: queries)
    }
    
    func didTapFilter() {
        coordinator?.route(event: .filter { [weak self] queries in
            self?.observeOrders(queries: queries)
        })
    }
}

// MARK: - Observation methods

private extension OrdersListPresenter {
    func observeOrders(queries: [Order.Query]) {
        orderNotificationToken = orderStorage.observeOrders(queries) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let orders):
                self.ordersList = orders.sorted(by: { $0.createdAt > $1.createdAt })
                self.view?.updateOrdersTableView()
            case .failure:
                self.coordinator?.route(event: .error)
            }
        }
    }
}
