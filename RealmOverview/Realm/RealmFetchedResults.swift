//
//  RealmFetchedResults.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 15.09.2021.
//

import RealmSwift

final class RealmFetchedResults<T: Persistable> {
    let results: Results<T.ManagedObject>
    
    var count: Int {
        results.count
    }
    
    init(results: Results<T.ManagedObject>) {
        self.results = results
    }
    
    func value(at index: Int) -> T {
        T(managedObject: results[index])
    }
}

extension RealmFetchedResults: Collection {
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return count
    }
    
    func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    subscript(position: Int) -> T {
        return value(at: position)
    }
}
