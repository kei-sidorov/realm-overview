//
//  OrderObject.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 19.08.2021.
//

import RealmSwift

enum OrderStatus: String, PersistableEnum, CaseIterable {
    case accepted = "Accepted"
    case processing = "Processing"
    case fillingUp = "Filling up"
    case done = "Done"
    case unknown
    
    static func random() -> OrderStatus {
        allCases.randomElement() ?? .unknown
    }
}

final class OrderObject: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var code: String
    @Persisted var createdAt: Date
    @Persisted var items: List<OrderItemObject>
    @Persisted var status = OrderStatus.unknown
}
