//
//  OrderStorage.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 16.09.2021.
//

import Foundation

final class OrderStorage {
    private let backgroundQueue = DispatchQueue(label: "background")
}

extension OrderStorage: OrderStorageProtocol {
    func save(_ order: Order, completion: @escaping Completion) {
        backgroundQueue.async {
            completion(Result(catching: {
                let container = try RealmContainer()
                try container.write { $0.add(order) }
            }))
        }
    }
    
    func remove(_ order: Order, completion: @escaping Completion) {
        backgroundQueue.async {
            completion(Result(catching: {
                let container = try RealmContainer()
                guard let fetchedOrder = container.value(Order.self, key: order.id).result else {
                    completion(.failure(StorageError.noElement))
                    return
                }
                try container.write { $0.delete(fetchedOrder) }
            }))
        }
    }
    
    func update(_ order: Order, completion: @escaping Completion) {
        backgroundQueue.async {
            completion(Result(catching: {
                let container = try RealmContainer()
                try container.write { $0.add(order) }
            }))
        }
    }
    
    func getOrders(byQueries queries: [Order.Query]?, completion: @escaping CompletionValue) {
        backgroundQueue.async {
            do {
                let container = try RealmContainer()
                let result = container.values(Order.self, queries: queries ?? []).map { $0 }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getOrder(byId id: String, completion: @escaping CompletionSingleValue) {
        backgroundQueue.async {
            do {
                let container = try RealmContainer()
                let fetchedOrder = container.value(Order.self, key: id).result
                completion(.success(fetchedOrder.map { Order(managedObject: $0) }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func observeOrders(_ queries: [Order.Query]?, completion: @escaping CompletionValue) -> ObservationToken? {
        do {
            let container = try RealmContainer()
            let orders = container.values(Order.self, queries: queries ?? []).results
            return orders.observe(on: backgroundQueue) { changes in
                switch changes {
                case .initial(let orders), .update(let orders, _, _, _):
                    completion(.success(orders.map { Order(managedObject: $0) }))
                case .error(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
        return .none
    }
}
