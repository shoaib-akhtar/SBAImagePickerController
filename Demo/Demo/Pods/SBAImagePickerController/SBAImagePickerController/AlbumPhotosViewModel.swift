//
//  AlbumPhotosViewModel.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 14/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import Foundation
import Photos


protocol AlbumPhotosViewModel {
    func loadImages()
    func numberOfRows() -> Int
    func rowSelected(at indexPath: IndexPath)
    func viewModel(for indexPath: IndexPath) -> Any
    func title() -> String
    func showDone() -> Bool
    func done()
    func maximumAllowed() -> Int
    func cancelFetching(at indexPath: IndexPath)
    func registerFetching(requestId: PHImageRequestID, at indexPath: IndexPath)
    func removeFetching(indexPath: IndexPath)
    func isFetching(indexPath: IndexPath) -> Bool
}

class AlbumPhotosViewModelImp: AlbumPhotosViewModel {
    fileprivate var coordinator: PhotosPickerCoordinator
    private var collection: PHAssetCollection
    private var completion: cameraClosure
    fileprivate var assets: PHFetchResult<AnyObject>?
    private lazy var progressHud = ProgressHUD(text: progressText)
    private let progressText : String = "loading"
    private var pickerController: PhotosPickerController? = PhotosPickerController()
    private var requestIdMap = [IndexPath: PHImageRequestID]()
    fileprivate var viewModels: [Any] = []
    
    fileprivate var selectedAssets: SelectedAssets = SelectedAssets()
    
    fileprivate let maximumImages : Int
    
    init(coordinator: PhotosPickerCoordinator, collection: PHAssetCollection,maximumImages: Int = 10, completion: @escaping cameraClosure) {
        self.coordinator = coordinator
        self.collection = collection
        self.completion = completion
        self.maximumImages = maximumImages
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
    func maximumAllowed() -> Int {
        return maximumImages
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
        progressHud.show()
        PhotoManager.loadImages(for: selectedAssets.assets) { [weak self](images) in
            guard let strongSelf = self else {return}
            strongSelf.progressHud.hide()
            strongSelf.coordinator.dismiss()
            strongSelf.completion(images, false)
        }
    }
    func cancelFetching(at indexPath: IndexPath) {
        if let requestId = requestIdMap[indexPath] {
            requestIdMap.removeValue(forKey: indexPath)
            PhotoManager.sharedManager.cancelImageRequest(requestId)
        }
    }
    
    func registerFetching(requestId: PHImageRequestID, at indexPath: IndexPath) {
        requestIdMap[indexPath] = requestId
    }
    func removeFetching(indexPath: IndexPath) {
        if let _ = requestIdMap[indexPath] {
            requestIdMap.removeValue(forKey: indexPath)
        }
    }
    func isFetching(indexPath: IndexPath) -> Bool {
        if let _ = requestIdMap[indexPath] {
            return true
        } else {
            return false
        }
    }
}

class MultipleAlbumPhotosViewModel: AlbumPhotosViewModelImp {
    override func rowSelected(at indexPath: IndexPath) {
        
        let asset = assets![indexPath.row] as! PHAsset
        let contains = selectedAssets.assets.contains(where: {$0.localIdentifier == asset.localIdentifier})
        
        if selectedAssets.assets.count < maximumImages {
            if !contains {
                selectedAssets.assets.append(asset)
            } else {
                selectedAssets.assets.removeAll(where: {$0.localIdentifier == asset.localIdentifier})
            }
            
        } else {
            if contains {
                selectedAssets.assets.removeAll(where: {$0.localIdentifier == asset.localIdentifier})
            }
        }
    }
   override func maximumAllowed()  -> Int {
    return maximumImages
    }
    private func reloadWith(asset: PHAsset, at indexPath: IndexPath, showSelected: Bool) {
        let vm = AlbumPhotoCollectionViewCellViewModelImp(asset: asset, selected: !showSelected)
        viewModels[indexPath.row] = vm
        coordinator.reloadCollection(at: indexPath)
    }
    
    override func title() -> String {
        let count = selectedAssets.assets.count
        return (count == 0) ? "Select Pictures" : "\("Selected Pictures:") \(count)" + "/" + "\(maximumImages)"
    }
    
    override func showDone() -> Bool {
        return selectedAssets.assets.count > 0
    }
}
