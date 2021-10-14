//
//  Product+Persistable.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 14.09.2021.
//

import RealmSwift

extension Product: Persistable {
    init(managedObject: ProductObject) {
        guard let price = managedObject.price else { fatalError("Price can't be nil") }
        id = managedObject._id
        title = managedObject.title
        descriptionText = managedObject.descriptionText
        self.price = Price(usd: price.usd.decimalValue)
        tags = Array(managedObject.tags).map { Tag(managedObject: $0) }
    }
    
    func managedObject() -> ProductObject {
        let productObject = ProductObject()
        productObject._id = id
        productObject.title = title
        productObject.descriptionText = descriptionText
        productObject.price = price.managedObject()
        productObject.tags.append(objectsIn: tags.map { $0.managedObject() })
        return productObject
    }
}

extension Product {
    enum Query: QueryType {
        case id(String)
        case title(String)
        case hasTagId(String)
        case sortPrice(ascending: Bool)
        case sortTitle(ascending: Bool)
        
        var predicate: NSPredicate? {
            switch self {
            case .id(let id):
                return NSPredicate(format: "_id == %@", id)
            case .title(let title):
                return NSPredicate(format: "title CONTAINS[c] %@", title)
            case .hasTagId(let tagId):
                return NSPredicate(format: "Any tags._id == %@", tagId)
            default:
                return .none
            }
        }
        
        var sortDescriptor: SortDescriptor? {
            switch self {
            case .sortPrice(let ascending):
                return SortDescriptor(keyPath: "price.usd", ascending: ascending)
            case .sortTitle(let ascending):
                return SortDescriptor(keyPath: "title", ascending: ascending)
            default:
                return .none
            }
        }
    }
}

extension Product {
    enum PropertyValue: PropertyValueType {
        case id(String)
        case title(String)
        case descriptionText(String?)
        case price(Price)
        case tags([Tag])
        
        var propertyValuePair: (name: String, value: Any) {
            switch self {
            case .id(let id):
                return ("_id", id)
            case .title(let title):
                return ("title", title)
            case .descriptionText(let text):
                return ("descriptionText", text as Any)
            case .price(let price):
                return ("price", price.managedObject())
            case .tags(let tags):
                let tagsObject = tags.map { $0.managedObject() }
                let tagList = List<TagObject>()
                tagList.append(objectsIn: tagsObject)
                return ("tags", tagList)
            }
        }
    }
}
