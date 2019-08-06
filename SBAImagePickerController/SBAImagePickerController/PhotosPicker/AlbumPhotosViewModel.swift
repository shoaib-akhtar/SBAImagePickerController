//
//  AlbumPhotosViewModel.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 14/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import Foundation
import Photos

typealias cameraClosure = (_ image: [UIImage]?,_ skiped: Bool) -> Void

protocol AlbumPhotosViewModel {
    func loadImages()
    func numberOfRows() -> Int
    func rowSelected(at indexPath: IndexPath)
    func viewModel(for indexPath: IndexPath) -> Any
    func title() -> String
    func showDone() -> Bool
    func done()
}

class AlbumPhotosViewModelImp: AlbumPhotosViewModel {
    fileprivate var coordinator: PhotosPickerCoordinator
    private var collection: PHAssetCollection
    private var completion: cameraClosure
    fileprivate var assets: PHFetchResult<AnyObject>?
    
    private var pickerController: PhotosPickerController? = PhotosPickerController()
    fileprivate var viewModels: [Any] = []
    
    fileprivate var selectedAssets: SelectedAssets = SelectedAssets()
    
    init(coordinator: PhotosPickerCoordinator, collection: PHAssetCollection, completion: @escaping cameraClosure) {
        self.coordinator = coordinator
        self.collection = collection
        self.completion = completion
    }
    
    func generateViewModels() {
        viewModels.removeAll()
        
        if let assets = assets {
            for index in 0..<assets.count {
                let asset = assets[index] as! PHAsset
                let contains = selectedAssets.assets.contains(where: {$0.localIdentifier == asset.localIdentifier})
                let vm = AlbumPhotoCollectionViewCellViewModelImp(asset: asset, selected: contains)
                viewModels.append(vm)
            }
            coordinator.reloadCollection()
        }
    }
    
    func loadImages() {
        pickerController?.fetchPhotos(in: collection, completionBlock: {[weak self] (assets) in
            guard let strongSelf = self else {return}
            strongSelf.assets = assets
            strongSelf.generateViewModels()
        })
    }
    
    func numberOfRows() -> Int {
        return viewModels.count
    }
    
    func viewModel(for indexPath: IndexPath) -> Any {
        return viewModels[indexPath.row]
    }
    
    func rowSelected(at indexPath: IndexPath) {
        let asset = assets![indexPath.row] as! PHAsset
        selectedAssets.assets.append(asset)
        done()
    }
    
    func title() -> String {
        return "Photos"
    }
    
    func showDone() -> Bool {
        return false
    }
    
    func done() {
//        coordinator.showProgressHud()
        PhotoManager.loadImages(for: selectedAssets.assets) { [weak self](images) in
            guard let strongSelf = self else {return}
//            strongSelf.coordinator.hideProgressHud()
            strongSelf.coordinator.dismiss()
            strongSelf.completion(images, false)
        }
    }
}

class MultipleAlbumPhotosViewModel: AlbumPhotosViewModelImp {
    override func rowSelected(at indexPath: IndexPath) {
        
        let asset = assets![indexPath.row] as! PHAsset
        let contains = selectedAssets.assets.contains(where: {$0.localIdentifier == asset.localIdentifier})
        
        if selectedAssets.assets.count < 3 {
            if !contains {
                selectedAssets.assets.append(asset)
            } else {
                selectedAssets.assets.removeAll(where: {$0.localIdentifier == asset.localIdentifier})
            }
            reloadWith(asset: asset, at: indexPath, showSelected: contains)
            
        } else {
            if contains {
                selectedAssets.assets.removeAll(where: {$0.localIdentifier == asset.localIdentifier})
                reloadWith(asset: asset, at: indexPath, showSelected: contains)
            }
        }
    }
    
    private func reloadWith(asset: PHAsset, at indexPath: IndexPath, showSelected: Bool) {
        let vm = AlbumPhotoCollectionViewCellViewModelImp(asset: asset, selected: !showSelected)
        viewModels[indexPath.row] = vm
        coordinator.reloadCollection(at: indexPath)
    }
    
    override func title() -> String {
        let count = selectedAssets.assets.count
        return (count == 0) ? "Select Pictures" : "\("Selected Pictures:") \(count)" + "/" + "\(50)"
    }
    
    override func showDone() -> Bool {
        return true
    }
}
