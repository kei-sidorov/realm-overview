//
//  Price+EmbeddedObject.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 14.09.2021.
//

import RealmSwift

extension Price {
    init(managedObject: PriceObject) {
        usd = managedObject.usd.decimalValue
    }
    
    func managedObject() -> PriceObject {
        let priceObject = PriceObject()
        priceObject.usd = Decimal128(value: usd)
        return priceObject
    }
}
