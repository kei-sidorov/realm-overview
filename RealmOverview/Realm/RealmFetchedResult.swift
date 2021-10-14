//
//  RealmFetchedResult.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 16.09.2021.
//

import RealmSwift

final class RealmFetchedResult<T: Persistable> {
    let result: Results<T.ManagedObject>.Element?
    
    init(result: Results<T.ManagedObject>.Element?) {
        self.result = result
    }
}
