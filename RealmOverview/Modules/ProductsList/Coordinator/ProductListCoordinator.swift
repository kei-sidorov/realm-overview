//
//  ProductListCoordinator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 07.10.2021.
//

import UIKit

protocol ProductListParentCoordinatorProtocol {
    func openOrdersScreen()
}

final class ProductListCoordinator: CoordinatorProtocol {
    private(set) var navigationController: UINavigationController
    
    private let productStorage: ProductStorageProtocol
    private let orderStorage: OrderStorageProtocol
    private let tagStorage: TagStorageProtocol
    
    private let parentCoordinator: ProductListParentCoordinatorProtocol
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: ProductListParentCoordinatorProtocol,
        productStorage: ProductStorageProtocol,
        orderStorage: OrderStorageProtocol,
        tagStorage: TagStorageProtocol
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.productStorage = productStorage
        self.orderStorage = orderStorage
        self.tagStorage = tagStorage
    }
    
    func start() {
        let viewController = StoryboardScene.ProductsList.productsListViewController.instantiate()
        let presenter = ProductsListPresenter(
            productStorage: productStorage,
            orderStorage: orderStorage,
            tagStorage: tagStorage
        )
        presenter.coordinator = asRouter()
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Router configuration

extension ProductListCoordinator: RouterType {
    func route(event: ProductsListPresenter.ProductListEvent) {
        switch event {
        case .error:
            showErrorAlert()
        case .sort(let completion):
            showSortAlertController(completion: completion)
        case .detailScreen(let currentProduct):
            setupDetailProduct(currentProduct: currentProduct)
        case .productCountChooserScreen(let currentOrderId, let currentProduct):
            setupProductCountChooser(currentOrderId: currentOrderId, currentProduct: currentProduct)
        case.basket(let currentOrder):
            setupBasket(currentOrder: currentOrder)
        }
    }
}

// MARK: - Alerts configuration

private extension ProductListCoordinator {
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
    
    func showSortAlertController(completion: @escaping (([Product.Query])) -> Void) {
        let alertController = UIAlertController(title: .none, message: "Sort by", preferredStyle: .actionSheet)
        let aToZaction = UIAlertAction(title: "Name A - Z", style: .default) { _ in
            completion([.sortTitle(ascending: true)])
        }
        
        let zToAaction = UIAlertAction(title: "Name Z - A", style: .default) { _ in
            completion([.sortTitle(ascending: false)])
        }
        
        let cheapFirstAction = UIAlertAction(title: "Cheap first", style: .default) { _ in
            completion([.sortPrice(ascending: true)])
        }
        
        let expensiveFirstAction = UIAlertAction(title: "Expensive first", style: .default) {  _ in
            completion([.sortPrice(ascending: false)])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(aToZaction)
        alertController.addAction(zToAaction)
        alertController.addAction(cheapFirstAction)
        alertController.addAction(expensiveFirstAction)
        alertController.addAction(cancelAction)
        navigationController.present(alertController, animated: true)
    }
}

// MARK: - Screens configuration

private extension ProductListCoordinator {
    func setupDetailProduct(currentProduct: Product?) {
        let child = DetailProductCoordinator(
            navigationController: navigationController,
            currentProduct: currentProduct,
            productStorage: productStorage
        )
        child.start()
    }

    func setupProductCountChooser(currentOrderId: String, currentProduct: Product) {
        let child = ProductsCountChooserCoordinator(
            navigationController: navigationController,
            orderStorage: orderStorage,
            currentOrderId: currentOrderId,
            currentProduct: currentProduct
        )
        child.start()
    }
    
    func setupBasket(currentOrder: Order) {
        let child = BasketCoordinator(
            navigationController: navigationController,
            parentCoordinator: self,
            orderStorage: orderStorage,
            productStorage: productStorage,
            order: currentOrder
        )
        child.start()
    }
}

// MARK: - BasketParentCoordinatorProtocol implementation

extension ProductListCoordinator: BasketParentCoordinatorProtocol {
    func openOrdersScreen() {
        parentCoordinator.openOrdersScreen()
    }
}
