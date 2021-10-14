//
//  ProductsCountChooserPresenterProtocol.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 04.10.2021.
//

protocol ProductsCountChooserPresenterProtocol {
    func didTapPlus()
    func didTapMinus()
    func didTapDone()
    func viewDidLoad(_ view: ProductsCountChooserViewProtocol)
}
