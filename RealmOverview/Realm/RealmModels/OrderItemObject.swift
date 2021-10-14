//
//  OrderItemObject.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 19.08.2021.
//

import RealmSwift

final class OrderItemObject: EmbeddedObject {
    @Persisted var productId: String
    
    var price: Decimal128 {
        get {
            self._price
        }
        set {
            _price = newValue
            _total = newValue * Decimal128(value: _count)
        }
    }

    var count: Int {
        get {
            return _count
        }
        set {
            self._count = newValue
            _total = Decimal128(value: newValue) * self._price
        }
    }

    var total: Decimal128 {
        get {
            self._total
        }
    }
    
    @Persisted private var _price: Decimal128
    @Persisted private var _count: Int
    @Persisted private var _total: Decimal128
}
