//
//  Order+Persistable.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 14.09.2021.
//

import RealmSwift

extension Order: Persistable {
    init(managedObject: OrderObject) {
        id = managedObject._id
        code = managedObject.code
        createdAt = managedObject.createdAt
        status = managedObject.status
        items = Array(managedObject.items.map { OrderItem(managedObject: $0) })
        totalItems = items.reduce(0) { $0 + $1.count }
        totalPrice = items.reduce(0) { $0 + Decimal($1.count) * $1.price.usd }
    }
    
    func managedObject() -> OrderObject {
        let orderObject = OrderObject()
        orderObject._id = id
        orderObject.code = code
        orderObject.createdAt = createdAt
        orderObject.status = status
        orderObject.items.append(objectsIn: items.map { $0.managedObject() })
        return orderObject
    }
}

extension Order {
    enum Query: QueryType {
        case id(String)
        case code(String)
        case status(OrderStatus)
        case totalItemsMore(than: Int)
        case totalItemsLess(than: Int)
        case totalPriceMore(than: Int)
        
        var predicate: NSPredicate? {
            switch self {
            case .id(let id):
                return NSPredicate(format: "_id == %@", id)
            case .code(let code):
                return NSPredicate(format: "code CONTAINS[c] %@", code)
            case .status(let status):
                return NSPredicate(format: "status == [c] %@", status.rawValue)
            case .totalItemsMore(let int):
                return NSPredicate(format: "items.@sum._count > %d", int)
            case .totalItemsLess(let int):
                return NSPredicate(format: "items.@sum._count < %d", int)
            case .totalPriceMore(let int):
                return NSPredicate(format: "items.@sum._total > %d", int)
            }
        }
        
        var sortDescriptor: SortDescriptor? {
            .none
        }
    }
}
