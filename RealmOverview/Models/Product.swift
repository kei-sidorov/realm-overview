//
//  Product.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 30.08.2021.
//

struct Product {
    let id: String
    let title: String
    let descriptionText: String
    let price: Price
    let tags: [Tag]
}

extension Product {
    func changing(_ tags: [Tag]) -> Product {
        Product(
            id: id,
            title: title,
            descriptionText: descriptionText,
            price: price,
            tags: tags
        )
    }
}
