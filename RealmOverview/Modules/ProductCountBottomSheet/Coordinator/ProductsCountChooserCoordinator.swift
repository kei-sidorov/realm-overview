//
//  ProductsCountChooserCoordinator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 07.10.2021.
//

import UIKit

final class ProductsCountChooserCoordinator: NSObject, CoordinatorProtocol, UINavigationControllerDelegate {
    private(set) var navigationController: UINavigationController
    
    private let orderStorage: OrderStorageProtocol
    private let currentOrderId: String
    private let currentProduct: Product
    
    init(
        navigationController: UINavigationController,
        orderStorage: OrderStorageProtocol,
        currentOrderId: String,
        currentProduct: Product
    ) {
        self.navigationController = navigationController
        self.orderStorage = orderStorage
        self.currentOrderId = currentOrderId
        self.currentProduct = currentProduct
    }
    
    func start() {
        navigationController.delegate = self
        let viewController = ProductsCountChooserViewController(
            nibName: "ProductDetailViewController",
            bundle: .none
        )
        let presenter = ProductsCountChooserPresenter(
            orderStorage: orderStorage,
            currentOrderId: currentOrderId,
            currentProduct: currentProduct
        )
        presenter.coordinator = asRouter()
        viewController.presenter = presenter
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        navigationController.present(viewController, animated: true)
    }
}

// MARK: - Router configuration

extension ProductsCountChooserCoordinator: RouterType {
    func route(event: ProductsCountChooserPresenter.ProductCountChooserEvent) {
        switch event {
        case .error:
            showErrorAlert()
        case .dismiss:
            navigationController.dismiss(animated: true)
        }
    }
}

// MARK: - Alerts configuration

private extension ProductsCountChooserCoordinator {
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
}

// MARK: - Transitioning delegate

extension ProductsCountChooserCoordinator: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        ProductDetailPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
