//
//  AlbumPhotoCollectionViewCell.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 14/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit

class AlbumPhotoCollectionViewCell: UICollectionViewCell, DequeueInitializable {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    
    var viewModel: AlbumPhotoCollectionViewCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedView.layer.cornerRadius = 3
        selectedView.layer.masksToBounds = true
    }
    
    func config () {
        let width = UIScreen.main.bounds.width/CGFloat(CollectionConstraints.numberOfItems) - CollectionConstraints.itemSpacing
        let size = CGSize.init(width: width, height: width)
        PhotoManager.loadImage(for: viewModel.associatedAsset(), targetSize: size, contentMode: .aspectFill, in: imgView)
        selectedView.isHidden = !viewModel.isImageSelected()
    }
}
