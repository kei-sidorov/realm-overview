//
//  TagStorage.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 16.09.2021.
//

import Foundation

final class TagStorage {
    private let backgroundQueue = DispatchQueue(label: "background")
}

extension TagStorage: TagStorageProtocol {
    func save(_ tag: Tag, completion: @escaping Completion) {
        backgroundQueue.async {
            completion(Result(catching: {
                let container = try RealmContainer()
                try container.write { $0.add(tag) }
            }))
        }
    }
    
    func remove(_ tag: Tag, completion: @escaping Completion) {
        backgroundQueue.async {
            completion(Result(catching: {
                let container = try RealmContainer()
                guard let fetchedTag = container.value(Tag.self, key: tag.id).result else {
                    completion(.failure(StorageError.noElement))
                    return
                }
                try container.write { $0.delete(fetchedTag) }
            }))
        }
    }
    
    func getTags(byQueries queries: [Tag.Query]?, completion: @escaping CompletionValue) {
        backgroundQueue.async {
            do {
                let container = try RealmContainer()
                let result = container.values(Tag.self, queries: queries ?? []).map { $0 }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func observeTags(_ queries: [Tag.Query]?, completion: @escaping CompletionValue) -> ObservationToken? {
        do {
            let container = try RealmContainer()
            let tags = container.values(Tag.self, queries: queries ?? []).results
            return tags.observe(on: backgroundQueue) { changes in
                switch changes {
                case .initial(let tags), .update(let tags, _, _, _):
                    completion(.success(tags.map { Tag(managedObject: $0) }))
                case .error(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
        return .none
    }
}
