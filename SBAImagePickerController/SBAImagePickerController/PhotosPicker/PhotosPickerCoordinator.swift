//
//  PhotosPickerCoordinator.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 11/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
import Photos

class PhotosPickerCoordinator {
    let rootViewController: UIViewController
    var photoAlbumsController: PhotoAlbumsViewController?
    var albumPhotosCollectionViewController: AlbumPhotosViewController?
    var completionBlock: cameraClosure
    
    init(rootViewCOntroler: UIViewController, completionBlock: @escaping cameraClosure) {
        self.rootViewController = rootViewCOntroler
        self.completionBlock = completionBlock
    }
    
    func start() {
        let controller = PhotoAlbumsViewController.initFromStoryboard()
        let nav = UINavigationController.init(rootViewController: controller)
        controller.viewModel = PhotosPickerViewModelImp(coordinator: self)
        photoAlbumsController = controller
        rootViewController.present(nav, animated: true, completion: nil)
    }
    
    func reload() {
        photoAlbumsController!.refresh()
    }
    
    func reloadCollection() {
        albumPhotosCollectionViewController?.reload()
    }
    
    func reloadCollection(at indexPath: IndexPath) {
        albumPhotosCollectionViewController?.reload(at: indexPath)
    }
    
    func loadAlbumPictures(for collection: PHAssetCollection) {
        load(with: AlbumPhotosViewModelImp(coordinator: self, collection: collection, completion: completionBlock))
    }
    
    fileprivate func load(with viewModel: AlbumPhotosViewModel) {
        let controller = AlbumPhotosViewController.initFromStoryboard()
        controller.viewModel = viewModel
        albumPhotosCollectionViewController = controller
        photoAlbumsController?.show(controller, sender: nil)
    }
}

extension PhotosPickerCoordinator {
    
    func errorOccured(with error: PhotosPickerErrorCode.error?) {
        
//        photoAlbumsController?.showAlert(title: "No Photo Permissions", message: "Please grant photo permissions in Settings", cancelTitle: "Cancel", actions: ["Settings"], actionBlock: { (index) in
//            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//        })
    }
}

extension PhotosPickerCoordinator {
    
    func dismiss() {
        DispatchQueue.main.async {
            self.rootViewController.dismiss(animated: true, completion: nil)
        }
    }
}

class MultiplePhotosPickerCoordinator: PhotosPickerCoordinator {
    override func loadAlbumPictures(for collection: PHAssetCollection) {
        load(with: MultipleAlbumPhotosViewModel(coordinator: self, collection: collection, completion: completionBlock))
    }
}
