//
//  DetailProductCoordinator.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 07.10.2021.
//

import UIKit

final class DetailProductCoordinator: CoordinatorProtocol {
    private(set) var navigationController: UINavigationController
    
    private var currentProduct: Product?
    private let productStorage: ProductStorageProtocol
    
    init(
        navigationController: UINavigationController,
        currentProduct: Product?, 
        productStorage: ProductStorageProtocol
    ) {
        self.navigationController = navigationController
        self.currentProduct = currentProduct
        self.productStorage = productStorage
    }
    
    func start() {
        let viewController = StoryboardScene.DetailProduct.detailProductViewController.instantiate()
        let presenter = DetailProductPresenter(productStorage: productStorage, currentProduct: currentProduct)
        presenter.coordinator = asRouter()
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Router configuration

extension DetailProductCoordinator: RouterType {
    func route(event: DetailProductPresenter.DetailProductEvent) {
        switch event {
        case .error:
            showErrorAlert()
        case .back:
            navigationController.popToRootViewController(animated: true)
        }
    }
}

// MARK: - Alerts configuration

private extension DetailProductCoordinator {
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
