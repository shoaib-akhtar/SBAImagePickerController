//
//  PhotosPickerCoordinator.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 11/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
import Photos

public typealias cameraClosure = (_ images: [UIImage]?,_ skiped: Bool) -> Void
public typealias translationsClosure = (_ key: String) -> String

public class SBAImagePickerController {
    fileprivate let rootViewController: UIViewController
    fileprivate var photoAlbumsController: PhotoAlbumsViewController?
    fileprivate var albumPhotosCollectionViewController: AlbumPhotosViewController?
    fileprivate var completionBlock: cameraClosure
    fileprivate let maximumImages: Int
    public init(rootViewCOntroler: UIViewController,maximumImages: Int = 10, completionBlock: @escaping cameraClosure) {
        self.rootViewController = rootViewCOntroler
        self.completionBlock = completionBlock
        self.maximumImages = maximumImages
    }
    public func push() {
        rootViewController.show(start(), sender: nil)
    }
    public func translate (closure: @escaping translationsClosure){
        Transaltions.shared.closure = closure
    }
    
    public func present() {
        let nav = UINavigationController.init(rootViewController: start())
        rootViewController.present(nav, animated: true, completion: nil)
    }
    
    func loadAlbumPictures(for collection: PHAssetCollection) {
        load(with: AlbumPhotosViewModelImp(coordinator: self, collection: collection, completion: completionBlock))
    }
}

extension SBAImagePickerController {
    
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

extension SBAImagePickerController {
    
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

public class SBAMultipleImagePickerController: SBAImagePickerController {
    override func loadAlbumPictures(for collection: PHAssetCollection) {
        load(with: MultipleAlbumPhotosViewModel(coordinator: self, collection: collection,maximumImages: maximumImages, completion: completionBlock))
    }
}

class Transaltions{
    static let shared = Transaltions()
    var closure : translationsClosure?
    private init() {
        
    }
    
    func translation(for key: String) -> String {
        if let closure = closure{
           return closure(key)
        }
        return key
    }
}
