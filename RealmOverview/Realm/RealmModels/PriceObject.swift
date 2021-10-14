//
//  PriceObject.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 27.08.2021.
//

import RealmSwift

final class PriceObject: EmbeddedObject {
    @Persisted var usd: Decimal128
}
