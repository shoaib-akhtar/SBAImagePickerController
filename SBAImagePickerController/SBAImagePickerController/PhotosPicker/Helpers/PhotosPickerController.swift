//
//  PhotosPickerController.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 11/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
import Photos

struct PhotosPickerErrorCode {
    enum error : Error {
        case accessDeniedByUser
        case failed
    }
}

typealias PhotosPickerControllerAlbumsBlock = (_ library: PHFetchResult<PHAssetCollection>?, _ userAlbums: PHFetchResult<PHCollection>?, _ error: PhotosPickerErrorCode.error?) -> Void
typealias PhotosPickerControllerPicturesBlock = (_ assets: PHFetchResult<AnyObject>?) -> Void

class PhotosPickerController: NSObject {
    
    var completionBlock: PhotosPickerControllerAlbumsBlock?
    
    override init() {
        super.init()
    }
    
    func loadAlbums(with completionBlock: @escaping PhotosPickerControllerAlbumsBlock) {
        self.completionBlock = completionBlock
        requestAuthorization()
    }
}

extension PhotosPickerController {
    private func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.fetchAlbums()
                case .denied:
                    self.completionBlock?(nil, nil, PhotosPickerErrorCode.error.accessDeniedByUser)
                default:
                    self.completionBlock?(nil, nil, PhotosPickerErrorCode.error.failed)
                }
            }
        }
    }
    
    private func fetchAlbums() {
        let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        let library = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: nil)
        completionBlock?(library, userAlbums, nil)
    }
    
    func fetchPhotos(in collection: PHAssetCollection, fetchLimit:Int = 0, completionBlock: @escaping PhotosPickerControllerPicturesBlock) {
        let options = PHFetchOptions()
        options.fetchLimit = fetchLimit
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: fetchLimit == 0)]
        let assets = PHAsset.fetchAssets(in: collection, options: options) as? PHFetchResult<AnyObject>
        completionBlock(assets)
    }
}
