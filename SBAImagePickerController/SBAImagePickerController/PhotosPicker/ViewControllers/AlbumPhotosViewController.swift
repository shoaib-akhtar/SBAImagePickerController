//
//  AlbumPhotosViewController.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 14/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
//import EmptyDataSet_Swift

struct CollectionConstraints {
    static let numberOfItems: Int = 3
    static let itemSpacing: CGFloat = 1.0
}

class AlbumPhotosViewController: BaseViewController, StoryboardInitializable {
    static func storyboardName() -> String {
        return "SBAImagePickerController"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: AlbumPhotosViewModel!
    var scrolledToBottom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configure()
        viewModel.loadImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !scrolledToBottom {
            scrolledToBottom = !scrolledToBottom
            self.collectionView.scrollToLastItem(position: .bottom, animated: false)
        }
    }
    
//    private func addEmptyDataSet() {
//        collectionView.emptyDataSetView { view in
//            view.titleLabelString(NSAttributedString.init(string: "txt_empty_album".localized()))
//            .detailLabelString(NSAttributedString.init(string: "txt_empty_album_message".localized()))
//        }
//
//        collectionView.reloadEmptyDataSet()
//    }
    
    func reload(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    private func render() {
        title = viewModel.title()
    }
    
    private func configure() {
        if viewModel.showDone() {
            addRightBarButton(title: "Done")
        }
//        addEmptyDataSet()
    }
    
    override func rightBarButtonAction() {
        viewModel.done()
    }
}

extension AlbumPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = AlbumPhotoCollectionViewCell.dequeue(collectionView: collectionView, indexPath: indexPath)
        cell.viewModel = viewModel.viewModel(for: indexPath) as? AlbumPhotoCollectionViewCellViewModel
        cell.config()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width/CGFloat(CollectionConstraints.numberOfItems) - CollectionConstraints.itemSpacing
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionConstraints.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionConstraints.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.rowSelected(at: indexPath)
        render()
    }
}
