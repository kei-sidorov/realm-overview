//
//  OrderStorageProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 17.09.2021.
//

protocol OrderStorageProtocol {
    typealias Completion = ((Result<Void, Error>) -> Void)
    typealias CompletionValue = ((Result<[Order], Error>) -> Void)
    typealias CompletionSingleValue = ((Result<Order?, Error>) -> Void)
    
    func save(_ order: Order, completion: @escaping Completion)
    func remove(_ order: Order, completion: @escaping Completion)
    func update(_ order: Order, completion: @escaping Completion)
    func getOrders(byQueries: [Order.Query]?, completion: @escaping CompletionValue)
    func getOrder(byId: String, completion: @escaping CompletionSingleValue)
    func observeOrders(_ queries: [Order.Query]?, completion: @escaping CompletionValue) -> ObservationToken?
}
