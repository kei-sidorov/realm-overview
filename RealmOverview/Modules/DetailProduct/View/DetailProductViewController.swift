//
//  DetailProductViewController.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 05.10.2021.
//

import UIKit

final class DetailProductViewController: UIViewController {
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var tagNameTextField: UITextField!
    @IBOutlet private weak var tagsCollectionView: UICollectionView!
    
    @IBAction private func didTapAddTagButton(_ sender: UIButton) {
        presenter.didTapAddTag(title: tagNameTextField.text ?? "")
        tagNameTextField.text = ""
        tagNameTextField.resignFirstResponder()
    }
    
    @IBAction private func didTapSaveButton(_ sender: UIButton) {
        presenter.didTapSave(
            title: titleTextField.text,
            description: descriptionTextField.text,
            price: priceTextField.text
        )
    }
    
    var presenter: DetailProductPresenterProtocol!
}

// MARK: - View events

extension DetailProductViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(self)
        configureCollectionView()
    }
}

// MARK: - View protocol

extension DetailProductViewController: DetailProductViewProtocol {
    func updateTagsCollectionView() {
        tagsCollectionView.reloadData()
    }
    
    func updateTag(at index: Int) {
        tagsCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func setupLabels(title: String, description: String, price: String) {
        titleTextField.text = title
        descriptionTextField.text = description
        priceTextField.text = price
    }
    
    func setupTitle(_ title: String) {
        self.title = title
    }
}

// MARK: - Collection view configuration

extension DetailProductViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.tagsList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagsCell.reuseId,
            for: indexPath
        ) as? TagsCell else {
            return UICollectionViewCell()
        }
        cell.configure(presenter.tagsList[indexPath.item])
        cell.tapHandler = { [weak self] in
            guard let self = self else { return }
            self.presenter.didTapDeleteTag(at: indexPath.item)
        }
        return cell
    }
}

// MARK: - View configuration

private extension DetailProductViewController {
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 50, height: 35)
        tagsCollectionView.collectionViewLayout = layout
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.showsHorizontalScrollIndicator = false
        tagsCollectionView.register(
            UINib(nibName: "TagsCell", bundle: .none),
            forCellWithReuseIdentifier: TagsCell.reuseId
        )
    }
}
