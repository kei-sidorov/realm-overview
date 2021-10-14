//
//  OrdersListPresenterProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 04.10.2021.
//

protocol OrdersListPresenterProtocol {
    var ordersList: [Order] { get }
    
    func viewDidLoad(_ view: OrdersListViewProtocol)
    func viewDidDisappear()
    func didTapDeleteOrder(at index: Int)
    func didChangeFilter(queries: [Order.Query])
    func didTapFilter()
}
