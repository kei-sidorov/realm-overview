//
//  ProductObject.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 19.08.2021.
//

import RealmSwift

final class ProductObject: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var title: String
    @Persisted var descriptionText: String
    @Persisted var price: PriceObject?
    @Persisted var tags: List<TagObject>
}
