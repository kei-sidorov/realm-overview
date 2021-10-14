//
//  DetailProductViewProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 05.10.2021.
//

protocol DetailProductViewProtocol: AnyObject {
    func updateTagsCollectionView()
    func updateTag(at index: Int)
    func setupLabels(title: String, description: String, price: String)
    func setupTitle(_ name: String)
}
