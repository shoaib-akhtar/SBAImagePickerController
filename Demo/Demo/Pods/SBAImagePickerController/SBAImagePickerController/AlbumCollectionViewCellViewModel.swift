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
        var assetCount = collection.estimatedAssetCount
        if assetCount == NSNotFound {
            let fetchOptions = PHFetchOptions()
            let videoPredicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
            let imagePredicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            fetchOptions.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [videoPredicate,imagePredicate])
            assetCount = PHAsset.fetchAssets(in: collection, options: fetchOptions).count
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal        
        return  numberFormatter.string(from: NSNumber(value:assetCount)) ?? ""
    }
    
    func fetchFirstImageThumbnail(completionBlock: @escaping PhotosPickerControllerPicturesBlock) {
        photoController.fetchPhotos(in: collection) { (asset) in
            completionBlock(asset)
        }
    }
}
