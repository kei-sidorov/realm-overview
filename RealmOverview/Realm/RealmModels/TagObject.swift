//
//  TagObject.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 27.08.2021.
//

import RealmSwift

final class TagObject: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var title: String
    @Persisted(originProperty: "tags") var products: LinkingObjects<ProductObject>
}
