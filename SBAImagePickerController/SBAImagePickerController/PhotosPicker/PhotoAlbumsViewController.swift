//
//  PhotoAlbumsViewController.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 11/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit

class PhotoAlbumsViewController: BaseViewController, StoryboardInitializable {
    static func storyboardName() -> String {
        return "SBAImagePickerController"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: PhotosPickerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        render()
        configure()
        viewModel.loadAlbums()
    }
    
    private func configure() {
        addRightBarButton(title: "Cancel")
    }
    
    private func render() {
        title = "Albums"
    }
    
    override func rightBarButtonAction() {
        viewModel.cancel()
    }
}

extension PhotoAlbumsViewController {
    func refresh() {
        collectionView.reloadData()
    }
}

extension PhotoAlbumsViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = AlbumCollectionViewCell.dequeue(collectionView: collectionView, indexPath: indexPath)
        cell.viewModel = viewModel.viewModel(for: indexPath) as? AlbumCollectionViewCellViewModel
        cell.config()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.rowSelected(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width/2 - 24, height: (collectionView.frame.size.width/2) * 1.25)
        
    }
}
