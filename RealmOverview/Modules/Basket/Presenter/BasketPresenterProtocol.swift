//
//  BasketPresenterProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 04.10.2021.
//

struct OrderItemModel {
    let name: String
    let price: Price
    let total: Price
    let count: Int
}

protocol BasketPresenterProtocol {
    var orderItems: [OrderItemModel] { get }
    
    func viewDidLoad(_ view: BasketViewProtocol)
    func didTapProcessButton()
    func didDeleteItem(at index: Int)
}
