//
//  AlbumCollectionViewCell.swift
//  Hidebox
//
//  Created by Shoaib Akhtar on 02/08/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
import Photos

class AlbumCollectionViewCell: UICollectionViewCell,DequeueInitializable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    var viewModel: AlbumCollectionViewCellViewModel!
    
    
    func config() {
        titleLabel.text = viewModel.title()
        countLabel.text = viewModel.photoCount()
        let size = thumnailImageView.frame.size
        viewModel.fetchFirstImageThumbnail {[weak self] (asset) in
            guard let strongself = self else {return}
            
            if let assets = asset, let viewAsset = assets.firstObject as? PHAsset {
                PhotoManager.loadImage(for: viewAsset, targetSize: size, contentMode: .aspectFill, in: strongself.thumnailImageView)
            } else {
                strongself.thumnailImageView.image = UIImage.init(named: "Placeholder")
            }
        }
    }
}
