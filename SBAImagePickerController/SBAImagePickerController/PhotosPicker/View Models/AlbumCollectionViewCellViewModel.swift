//
//  AlbumsTableViewCellViewModel.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 11/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import Foundation
import Photos

protocol AlbumCollectionViewCellViewModel {
    func title() -> String
    func photoCount() -> String
    func fetchFirstImageThumbnail(completionBlock: @escaping PhotosPickerControllerPicturesBlock)
}

class AlbumCollectionViewCellViewModelImp: AlbumCollectionViewCellViewModel {
    var collection: PHAssetCollection
    var photoController: PhotosPickerController = PhotosPickerController()
    
    init(collection: PHAssetCollection) {
        self.collection = collection
    }
    
    func title() -> String {
        return collection.localizedTitle ?? ""
    }
    
    func photoCount() -> String {
        return collection.estimatedAssetCount != NSNotFound ? String(collection.estimatedAssetCount) : ""
    }
    
    func fetchFirstImageThumbnail(completionBlock: @escaping PhotosPickerControllerPicturesBlock) {
        photoController.fetchPhotos(in: collection, fetchLimit: 1) { (asset) in
            completionBlock(asset)
        }
    }
}
