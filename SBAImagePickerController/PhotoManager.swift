//
//  PhotoManager.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 14/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import UIKit
import Photos

class PhotoManager: PHImageManager {
    static let sharedManager = PhotoManager()
    let cacheManager = PHCachingImageManager()
    
    static func loadImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, completion: @escaping ((UIImage?) -> Void)) -> PHImageRequestID {
        
 //       PhotoManager.sharedManager.cacheManager .startCachingImages(for: [asset], targetSize: targetSize, contentMode: contentMode, options: nil)
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
      return  PhotoManager.sharedManager.requestImage(for: asset,
                                                targetSize: targetSize,
                                                contentMode: contentMode,
                                                options: options) { (image, _) in
                                                    DispatchQueue.main.async {
                                                        completion(image)
                                                    }
        }
    }
    
    static func loadImages(for assets: [PHAsset], completion: @escaping (_ images: [UIImage]) -> Void) {
        let queue = DispatchQueue(label: "com.hidebox.loadImages", attributes: .concurrent)
        let group = DispatchGroup()
        var images: [UIImage] = []
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        for asset in assets {
            autoreleasepool {
                group.enter()
                queue.async(group: group) {
                    PhotoManager.sharedManager.requestImageData(for: asset, options: options) { (data, _, orientation, _) in
                        if let data = data {
                            if let img = UIImage.init(data: data) {
                                images.append(img)
                            }
                        }
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                completion(images)
                images.removeAll()
            }
        }
    }
}
