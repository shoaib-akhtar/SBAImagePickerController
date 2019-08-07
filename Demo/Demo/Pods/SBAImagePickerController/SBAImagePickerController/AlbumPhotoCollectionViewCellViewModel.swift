//
//  AlbumPhotoCollectionViewCellViewModel.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 14/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import Foundation
import Photos

protocol AlbumPhotoCollectionViewCellViewModel {
    func associatedAsset() -> PHAsset
    func isImageSelected() -> Bool
}

struct AlbumPhotoCollectionViewCellViewModelImp: AlbumPhotoCollectionViewCellViewModel {
    var asset: PHAsset
    var selected: Bool
    
    init(asset: PHAsset, selected: Bool) {
        self.asset = asset
        self.selected = selected
    }
    
    func associatedAsset() -> PHAsset {
        return asset
    }
    
    func isImageSelected() -> Bool {
        return selected
    }
}
