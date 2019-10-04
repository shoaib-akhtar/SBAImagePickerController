//
//  PhotosPickerViewModel.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 11/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
import Photos

protocol PhotosPickerViewModel {
    func loadAlbums()
    func numberOfRows() -> Int
    func rowSelected(at indexPath: IndexPath)
    func viewModel(for indexPath: IndexPath) -> Any
    func cancel()
}

class PhotosPickerViewModelImp: PhotosPickerViewModel {    
    private var coordinator: SBAImagePickerController
    private var pickerController: PhotosPickerController?
    private var viewModels: [Any] = []
    
    private var userLibrary: PHFetchResult<PHAssetCollection>!
    private var userAlbums: PHFetchResult<PHCollection>!
    
    init(coordinator: SBAImagePickerController) {
        self.coordinator = coordinator
        pickerController = PhotosPickerController()
    }
    
    func loadAlbums() {
        pickerController?.loadAlbums(with: { [weak self] (library, albums, error) in
            guard let strongSelf = self else {return}
            if error == nil {
                strongSelf.userLibrary = library
                strongSelf.userAlbums = albums
                strongSelf.generateViewModels()
            } else {
                strongSelf.coordinator.errorOccured(with: error)
            }
        })
    }
    
    fileprivate func generateViewModels() {
        viewModels.removeAll()
        
        for row in 0..<userLibrary.count {
            let vm = AlbumCollectionViewCellViewModelImp(collection: userLibrary[row])
            viewModels.append(vm)
        }
        
        for row in 0..<userAlbums.count {
            if let collection = userAlbums[row] as? PHAssetCollection {
                let vm = AlbumCollectionViewCellViewModelImp(collection: collection)
                viewModels.append(vm)
            }
        }
        
        coordinator.reload()
    }
    
    func numberOfRows() -> Int {
        return viewModels.count
    }
    
    func viewModel(for indexPath: IndexPath) -> Any {
        return viewModels[indexPath.row]
    }
    
    func rowSelected(at indexPath: IndexPath) {
        let collection = (indexPath.row == 0) ? userLibrary[0] : userAlbums[indexPath.row - 1]
        if let col = collection as? PHAssetCollection{
            coordinator.loadAlbumPictures(for: col)
        }
    }
    
    func cancel() {
        coordinator.dismiss()
    }
}
