//
//  BasketListCoordinator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 07.10.2021.
//

import UIKit

protocol BasketParentCoordinatorProtocol {
    func openOrdersScreen()
}

final class BasketCoordinator: CoordinatorProtocol {
    private(set) var navigationController: UINavigationController
    
    private let orderStorage: OrderStorageProtocol
    private let productStorage: ProductStorageProtocol
    private let order: Order
    
    private let parentCoordinator: BasketParentCoordinatorProtocol
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: BasketParentCoordinatorProtocol,
        orderStorage: OrderStorageProtocol,
        productStorage: ProductStorageProtocol,
        order: Order
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.orderStorage = orderStorage
        self.productStorage = productStorage
        self.order = order
    }
    
    func start() {
        let viewController = StoryboardScene.Basket.basketViewController.instantiate()
        let presenter = BasketPresenter(
            order: order,
            orderStorage: orderStorage,
            productsStorage: productStorage
        )
        presenter.coordinator = asRouter()
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Router configuration

extension BasketCoordinator: RouterType {
    func route(event: BasketPresenter.BasketListEvent) {
        switch event {
        case .ordersScreen:
            navigationController.popViewController(animated: false)
            parentCoordinator.openOrdersScreen()
        }
    }
}
