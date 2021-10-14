//
//  RealmContainer.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 15.09.2021.
//

import RealmSwift

final class RealmContainer {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    convenience init() throws {
        try self.init(realm: Realm(configuration: RealmConfigurator.baseConfiguration))
    }
    
    func observe(_ block: @escaping NotificationBlock) -> NotificationToken {
        realm.observe(block)
    }
    
    func write(_ block: (RealmWriteTransaction) throws -> Void) throws {
        let writeTransaction = RealmWriteTransaction(realm: realm)
        try realm.write { try block(writeTransaction) }
    }
    
    func value<T: Persistable>(_ type: T.Type, key: String) -> RealmFetchedResult<T> {
        RealmFetchedResult(result: realm.object(ofType: T.ManagedObject.self, forPrimaryKey: key))
    }
    
    func values<T: Persistable>(_ type: T.Type, queries: [T.Query]? = .none) -> RealmFetchedResults<T> {
        var results = realm.objects(T.ManagedObject.self)
        
        guard let queries = queries, !queries.isEmpty else { return RealmFetchedResults(results: results) }
        
        let predicates = queries.compactMap { $0.predicate }
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        results = results.filter(predicate)
        
        let descriptors = queries.compactMap { $0.sortDescriptor }
        results = results.sorted(by: descriptors)
        
        return RealmFetchedResults(results: results)
    }
}
