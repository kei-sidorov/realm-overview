//
//  ProductStorageProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 17.09.2021.
//

protocol ProductStorageProtocol {
    typealias Completion = ((Result<Void, Error>) -> Void)
    typealias CompletionValue = ((Result<[Product], Error>) -> Void)
    typealias CompletionSingleValue = ((Result<Product?, Error>) -> Void)
    
    func save(_ product: Product, completion: @escaping Completion)
    func remove(_ product: Product, completion: @escaping Completion)
    func update(_ product: Product, completion: @escaping Completion)
    func update(_ values: [Product.PropertyValue], completion: @escaping Completion)
    func getProducts(byQueries: [Product.Query]?, completion: @escaping CompletionValue)
    func getProduct(byId: String, completion: @escaping CompletionSingleValue)
    func getProduct(byId: String) -> Result<Product?, Error>
    func observeProducts(_ queries: [Product.Query]?, completion: @escaping CompletionValue) -> ObservationToken?
}
