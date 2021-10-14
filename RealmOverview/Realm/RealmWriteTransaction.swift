//
//  RealmWriteTransaction.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 15.09.2021.
//

import RealmSwift

final class RealmWriteTransaction {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func add<T: Persistable>(_ value: T, update: Realm.UpdatePolicy = .modified) {
        realm.add(value.managedObject(), update: update)
    }
    
    func add<T: Sequence>(_ values: T, update: Realm.UpdatePolicy = .modified) where T.Iterator.Element: Persistable {
        values.forEach { add($0, update: update) }
    }
    
    func update<T: Persistable>(_ type: T.Type, values: [T.PropertyValue]) {
        let dictionary = Dictionary(uniqueKeysWithValues: values.map { $0.propertyValuePair })
        realm.create(T.ManagedObject.self, value: dictionary, update: .modified)
    }
    
    func delete<T: Sequence>(_ values: T) where T.Iterator.Element: Object {
        realm.delete(values)
    }
    
    func delete<T: Object>(_ value: T) {
        realm.delete(value)
    }
}
