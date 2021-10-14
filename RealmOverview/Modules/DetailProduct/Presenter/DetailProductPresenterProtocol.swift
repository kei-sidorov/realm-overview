//
//  DetailProductPresenterProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 05.10.2021.
//

protocol DetailProductPresenterProtocol {
    var tagsList: [Tag] { get }
    var currentProduct: Product? { get }
    
    func viewDidLoad(_ view: DetailProductViewProtocol)
    func didTapDeleteTag(at index: Int)
    func didTapAddTag(title: String)
    func didTapSave(title: String?, description: String?, price: String?)
}
