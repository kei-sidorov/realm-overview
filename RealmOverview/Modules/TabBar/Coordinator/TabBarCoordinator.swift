//
//  TabBarCoordinator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 14.10.2021.
//

import UIKit

final class TabBarCoordinator {
    var rootController: UIViewController {
        tabBarController
    }
    
    private let tabBarController = UITabBarController()
    
    private let productStorage: ProductStorageProtocol
    private let orderStorage: OrderStorageProtocol
    private let tagStorage: TagStorageProtocol
    
    private var productListCoordinator: ProductListCoordinator!
    private var orderListCoordinator: OrderListCoordinator!
    
    init(
        productStorage: ProductStorageProtocol,
        orderStorage: OrderStorageProtocol,
        tagStorage: TagStorageProtocol
    ) {
        self.productStorage = productStorage
        self.orderStorage = orderStorage
        self.tagStorage = tagStorage
    }
    
    func start() {
        productListCoordinator = setProductListCoordinator()
        orderListCoordinator = setOrderListCoordinator()
        
        tabBarController.viewControllers = [
            productListCoordinator.navigationController,
            orderListCoordinator.navigationController
        ]
    }
}

private extension TabBarCoordinator {
    func setProductListCoordinator() -> ProductListCoordinator {
        let coordinator = ProductListCoordinator(
            navigationController: UINavigationController(),
            parentCoordinator: self,
            productStorage: productStorage,
            orderStorage: orderStorage,
            tagStorage: tagStorage
        )
        coordinator.start()
        coordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Products",
            image: UIImage(systemName: "shippingbox.fill"),
            selectedImage: .none
        )
        return coordinator
    }
    
    func setOrderListCoordinator() -> OrderListCoordinator {
        let coordinator = OrderListCoordinator(
            navigationController: UINavigationController(),
            productStorage: productStorage,
            orderStorage: orderStorage
        )
        coordinator.start()
        coordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Orders",
            image: UIImage(systemName: "cart.fill"),
            selectedImage: .none
        )
        return coordinator
    }
}

// MARK: - ProductListParentCoordinatorProtocol implementation

extension TabBarCoordinator: ProductListParentCoordinatorProtocol {
    func openOrdersScreen() {
        tabBarController.selectedIndex = 1
    }
}
