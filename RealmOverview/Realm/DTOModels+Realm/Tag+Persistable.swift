//
//  Tag+Persistable.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 14.09.2021.
//

import RealmSwift

extension Tag: Persistable {
    init(managedObject: TagObject) {
        id = managedObject._id
        title = managedObject.title
        count = managedObject.products.count
    }
    
    func managedObject() -> TagObject {
        let tagObject = TagObject()
        tagObject._id = id
        tagObject.title = title
        return tagObject
    }
}

extension Tag {
    enum Query: QueryType {
        case title(String)
        
        var predicate: NSPredicate? {
            switch self {
            case .title(let title):
                return NSPredicate(format: "title == [c] %@", title)
            }
        }
        
        var sortDescriptor: SortDescriptor? {
            .none
        }
    }
}
