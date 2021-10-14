//
//  Order.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 01.09.2021.
//

import Foundation

struct Order {
    let id: String
    let code: String
    let createdAt: Date
    let status: OrderStatus
    let items: [OrderItem]
    let totalItems: Int
    let totalPrice: Decimal
}
