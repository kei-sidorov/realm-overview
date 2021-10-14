//
//  ProductStorage.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 15.09.2021.
//

import Foundation

final class ProductStorage {
    private let backgroundQueue = DispatchQueue(label: "background")
}

extension ProductStorage: ProductStorageProtocol {
    
    func save(_ product: Product, completion: @escaping Completion) {
        syncWithDatabase(product.tags) { tagsSyncedWithDatabase in
            let newProduct = Product(
                id: product.id,
                title: product.title,
                descriptionText: product.descriptionText,
                price: product.price,
                tags: tagsSyncedWithDatabase
            )
            completion(Result(catching: {
                let container = try RealmContainer()
                try container.write { $0.add(newProduct) }
            }))
        }
    }
    
    func remove(_ product: Product, completion: @escaping Completion) {
        backgroundQueue.async {
            completion(Result(catching: {
                let container = try RealmContainer()
                guard let fetchedProduct = container.value(Product.self, key: product.id).result else {
                    completion(.failure(StorageError.noElement))
                    return
                }
                try container.write { $0.delete(fetchedProduct) }
            }))
        }
    }
    
    func update(_ product: Product, completion: @escaping Completion) {
        syncWithDatabase(product.tags) { tags in
            completion(Result(catching: {
                let container = try RealmContainer()
                try container.write { $0.add(product.changing(tags), update: .modified) }
            }))
        }
    }
    
    func update(_ values: [Product.PropertyValue], completion: @escaping Completion) {
        backgroundQueue.async {
            completion(Result(catching: {
                let container = try RealmContainer()
                try container.write { $0.update(Product.self, values: values) }
            }))
        }
    }
    
    func getProducts(byQueries queries: [Product.Query]?, completion: @escaping CompletionValue) {
        backgroundQueue.async {
            do {
                let container = try RealmContainer()
                let result = container.values(Product.self, queries: queries ?? []).map { $0 }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getProduct(byId id: String, completion: @escaping CompletionSingleValue) {
        backgroundQueue.async {
            do {
                let container = try RealmContainer()
                let fetchedProduct = container.value(Product.self, key: id).result
                completion(.success(fetchedProduct.map { Product(managedObject: $0) }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getProduct(byId id: String) -> Result<Product?, Error> {
        do {
            let container = try RealmContainer()
            let fetchedProduct = container.value(Product.self, key: id).result
            return .success(fetchedProduct.map { Product(managedObject: $0) })
        } catch {
            return .failure(error)
        }
    }
    
    func observeProducts(_ queries: [Product.Query]?, completion: @escaping CompletionValue) -> ObservationToken? {
        do {
            let container = try RealmContainer()
            let products = container.values(Product.self, queries: queries ?? []).results
            return products.observe(on: backgroundQueue) { changes in
                switch changes {
                case .initial(let products), .update(let products, _, _, _):
                    completion(.success(products.map { Product(managedObject: $0) }))
                case .error(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
        return .none
    }
    
    /// Check if tags are already in Realm database and replace it with given tags
    /// - Parameters:
    ///   - tags: Tags to sync with databse
    ///   - completion: Recieves tags. Works on background queue
    private func syncWithDatabase(_ tags: [Tag], completion: @escaping ([Tag]) -> Void) {
        backgroundQueue.async {
            var tagsToAppend = [Tag]()
            do {
                let container = try RealmContainer()
                tags.forEach {
                    let fetchedTags = container.values(Tag.self, queries: [Tag.Query.title($0.title)]).map { $0 }
                    if fetchedTags.isEmpty {
                        tagsToAppend.append($0)
                    } else {
                        tagsToAppend.append(contentsOf: fetchedTags)
                    }
                }
                completion(tagsToAppend)
            } catch {
                completion([])
            }
        }
    }
}
