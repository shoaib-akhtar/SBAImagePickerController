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
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var viewModel: AlbumPhotoCollectionViewCellViewModel!
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            selectedImageView.isHidden = !newValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedImageView.layer.cornerRadius = 3
        selectedImageView.layer.masksToBounds = true
    }
    
    func config () {

    }
}
