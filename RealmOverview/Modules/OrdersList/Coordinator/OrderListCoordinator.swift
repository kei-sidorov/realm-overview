//
//  OrderListCoordinator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 07.10.2021.
//

import UIKit

final class OrderListCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    private let productStorage: ProductStorageProtocol
    private let orderStorage: OrderStorageProtocol
    
    init(
        navigationController: UINavigationController,
        productStorage: ProductStorageProtocol,
        orderStorage: OrderStorageProtocol
    ) {
        self.navigationController = navigationController
        self.productStorage = productStorage
        self.orderStorage = orderStorage
    }
    
    func start() {
        let viewController = StoryboardScene.OrderList.orderListViewController.instantiate()
        let presenter = OrdersListPresenter(orderStorage: orderStorage, productStorage: productStorage)
        presenter.coordinator = asRouter()
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Router configuration

extension OrderListCoordinator: RouterType {
    func route(event: OrdersListPresenter.OrderListEvent) {
        switch event {
        case .error:
            showErrorAlert()
        case .filter(let completion):
            showSortAlertController(completion: completion)
        }
    }
}

// MARK: - Alerts configuration

private extension OrderListCoordinator {
    func showErrorAlert() {
        let alertController = UIAlertController(
            title: "Something gone wrong",
            message: .none,
            preferredStyle: .alert
        )
        let alertOkAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOkAction)
        navigationController.present(alertController, animated: true)
    }
    
    func showSortAlertController(completion: @escaping ([Order.Query]) -> Void) {
        let alertController = UIAlertController(title: .none, message: "Sort by", preferredStyle: .actionSheet)
        let accepted = UIAlertAction(title: "Accepted", style: .default) { _ in
            completion([.status(.accepted)])
        }
        
        let done = UIAlertAction(title: "Done", style: .default) { _ in
            completion([.status(.done)])
        }
        
        let processing = UIAlertAction(title: "Processing", style: .default) { _ in
            completion([.status(.processing)])
        }
        
        let unknown = UIAlertAction(title: "Unknown", style: .default) { _ in
            completion([.status(.unknown)])
        }
        
        let itemsLess = UIAlertAction(title: "Items < 5", style: .default) { _ in
            completion([.totalItemsLess(than: 5)])
        }
        
        let itemsMore = UIAlertAction(title: "Items > 5", style: .default) { _ in
            completion([.totalItemsMore(than: 5)])
        }
        
        let priceMore = UIAlertAction(title: "Price > 50$", style: .default) { _ in
            completion([.totalPriceMore(than: 50)])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",style: .cancel)
        
        alertController.addAction(accepted)
        alertController.addAction(done)
        alertController.addAction(processing)
        alertController.addAction(unknown)
        alertController.addAction(itemsLess)
        alertController.addAction(itemsMore)
        alertController.addAction(priceMore)
        alertController.addAction(cancelAction)
        navigationController.present(alertController, animated: true)
    }
}
