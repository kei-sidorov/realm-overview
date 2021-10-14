//
//  OrderItem+EmbeddedObject.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 14.09.2021.
//

import RealmSwift

extension OrderItem {
    init(managedObject: OrderItemObject) {
        productId = managedObject.productId
        count = managedObject.count
        price = Price(usd: managedObject.price.decimalValue)
    }
    
    func managedObject() -> OrderItemObject {
        let orderItemObject = OrderItemObject()
        orderItemObject.productId = productId
        orderItemObject.count = count
        orderItemObject.price = Decimal128(value: price.usd)
        return orderItemObject
    }
}
