//
//  TagStorageProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 17.09.2021.
//

protocol TagStorageProtocol {
    typealias Completion = ((Result<Void, Error>) -> Void)
    typealias CompletionValue = ((Result<[Tag], Error>) -> Void)
    
    func save(_ tag: Tag, completion: @escaping Completion)
    func remove(_ tag: Tag, completion: @escaping Completion)
    func getTags(byQueries: [Tag.Query]?, completion: @escaping CompletionValue)
    func observeTags(_ queries: [Tag.Query]?, completion: @escaping CompletionValue) -> ObservationToken?
}
