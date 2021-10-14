//
//  Persistable.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 01.09.2021.
//

import RealmSwift

protocol Persistable {
    associatedtype ManagedObject: Object
    associatedtype PropertyValue: PropertyValueType = DefaultPropertyValue
    associatedtype Query: QueryType = DefaultQuery
    
    init(managedObject: ManagedObject)
    
    func managedObject() -> ManagedObject
}

protocol PropertyValueType {
    var propertyValuePair: (name: String, value: Any) { get }
}

enum DefaultPropertyValue: PropertyValueType {
    var propertyValuePair: (name: String, value: Any) {
        ("", 0)
    }
}

protocol QueryType {
    var predicate: NSPredicate? { get }
    var sortDescriptor: SortDescriptor? { get }
}

enum DefaultQuery: QueryType {
    var predicate: NSPredicate? { .none }
    var sortDescriptor: SortDescriptor? { .none }
}
