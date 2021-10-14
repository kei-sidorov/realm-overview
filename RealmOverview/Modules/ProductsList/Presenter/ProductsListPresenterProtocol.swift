//
//  ProductsListPresenterProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 04.10.2021.
//

protocol ProductsListPresenterProtocol {
    var productsList: [Product] { get }
    var tagsList: [Tag] { get }
    
    func viewDidLoad(_ view: ProductsListViewProtocol)
    func viewDidAppear()
    func didTapPlusBarButton()
    func didTapCartBarButton()
    func didChangeFilter(queries: [Product.Query])
    func didTapAddProduct(_ product: Product)
    func didTapDeleteProduct(at index: Int)
    func didSelectProduct(_ product: Product)
    func didTapDeleteTag(at index: Int)
    func didTapSort()
}
