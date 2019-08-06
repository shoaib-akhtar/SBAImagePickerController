//
//  PhotosPickerCoordinator.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 11/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
import Photos

public typealias cameraClosure = (_ image: [UIImage]?,_ skiped: Bool) -> Void

public class PhotosPickerCoordinator {
    fileprivate let rootViewController: UIViewController
    fileprivate var photoAlbumsController: PhotoAlbumsViewController?
    fileprivate var albumPhotosCollectionViewController: AlbumPhotosViewController?
    fileprivate var completionBlock: cameraClosure
    fileprivate let maximumImages: Int
    init(rootViewCOntroler: UIViewController,maximumImages: Int = 10, completionBlock: @escaping cameraClosure) {
        self.rootViewController = rootViewCOntroler
        self.completionBlock = completionBlock
        self.maximumImages = maximumImages
    }
    func push() {
        rootViewController.show(start(), sender: nil)
    }
    
    func present() {
        let nav = UINavigationController.init(rootViewController: start())
        rootViewController.present(nav, animated: true, completion: nil)
    }
    
    func loadAlbumPictures(for collection: PHAssetCollection) {
        load(with: AlbumPhotosViewModelImp(coordinator: self, collection: collection, completion: completionBlock))
    }
}

extension PhotosPickerCoordinator {
    
    func errorOccured(with error: PhotosPickerErrorCode.error?) {
        
        photoAlbumsController?.showError(title: PhotoPermissionAlert.title, message: PhotoPermissionAlert.message, actionTitle: PhotoPermissionAlert.actionButtonTitle, completion: { (type) in
            if type == .action {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
        })
        
    }
    
    private func start() -> UIViewController{
        let controller = PhotoAlbumsViewController.initFromStoryboard()
        controller.viewModel = PhotosPickerViewModelImp(coordinator: self)
        photoAlbumsController = controller
        return controller
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
    

    
    fileprivate func load(with viewModel: AlbumPhotosViewModel) {
        let controller = AlbumPhotosViewController.initFromStoryboard()
        controller.viewModel = viewModel
        albumPhotosCollectionViewController = controller
        photoAlbumsController?.show(controller, sender: nil)
    }
}

extension PhotosPickerCoordinator {
    
    func dismiss() {
        DispatchQueue.main.async {
            if self.photoAlbumsController?.isModal ?? true{
                self.rootViewController.dismiss(animated: true, completion: nil)
            }else{
                self.rootViewController.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

public class MultiplePhotosPickerCoordinator: PhotosPickerCoordinator {
    override func loadAlbumPictures(for collection: PHAssetCollection) {
        load(with: MultipleAlbumPhotosViewModel(coordinator: self, collection: collection,maximumImages: maximumImages, completion: completionBlock))
    }
}
