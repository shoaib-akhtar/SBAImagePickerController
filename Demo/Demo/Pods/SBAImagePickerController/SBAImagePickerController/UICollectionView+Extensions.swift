//
//  UICollectionView+Extensions.swift
//  SBAImagePickerController
//
//  Created by Shoaib Akhtar on 05/08/2019.
//  Copyright © 2019 ShoaibAkhtar. All rights reserved.
//

import UIKit


extension UICollectionView{
    func scrollToLastItem(position: UICollectionView.ScrollPosition = .centeredHorizontally,animated: Bool = false) {
        let lastSection =  self.numberOfSections-1
        let lastItem = self.numberOfItems(inSection: lastSection) - 1
        
        if !(lastSection < 0 || lastItem <= 0) {
            let indexPath = IndexPath(item: lastItem, section: lastSection)
            self.scrollToItem(at: indexPath, at: position, animated: animated)
            
        }
    }
}
protocol EmptyMessageViewType {
    mutating func setEmptyMessage( message: String , title : String , imageName : String , animate : Bool)
    mutating func restore()
}

protocol ListViewType: EmptyMessageViewType where Self: UIView {
    var backgroundView: UIView? { get set }
}
extension UICollectionView : EmptySetDataSetSource {}
extension UITableView: ListViewType {}
extension UICollectionView: ListViewType {}
public protocol EmptySetDataSetSource {
}
extension ListViewType {
    func setEmptyMessage( message: String , title : String , imageName : String , animate : Bool) {
        
        if let collectionView = self as? UICollectionView {
            collectionView.emptyDataSetSource = self as? EmptySetDataSetSource
            
        }
        
        backgroundView = UIView(frame: UIScreen.main.bounds)
        
        
        let imageView = UIImageView()
        backgroundView?.addSubview(imageView)
        
        imageView.image = UIImage.bundleImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 2
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.7).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0/1.0).isActive = true
        imageView.centerYAnchor.constraint(equalTo: backgroundView!.centerYAnchor, constant: -100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: backgroundView!.centerXAnchor).isActive = true
        
        
        let titleLabel = UILabel(frame: .zero)
        backgroundView?.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width ).isActive = true
        let verticalSpace = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 30)
        
        
        let messageLabel = UILabel(frame: .zero)
        backgroundView?.addSubview(messageLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
       
        messageLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width ).isActive = true
        let messageVerticalSpace = NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([messageVerticalSpace,verticalSpace])
        
        if animate {
            self.animate()
        }
    }
    
    func restore() {
        backgroundView?.isHidden = true
        backgroundView = nil
    }
     func animate() {
        // animate the imageView
        
        guard let imageView = backgroundView?.viewWithTag(2) else { return }
        let rotate = CGAffineTransform(rotationAngle: -0.2)
        let stretchAndRotate = rotate.scaledBy(x: 0.5, y: 0.5)
        imageView.transform = stretchAndRotate
        imageView.alpha = 0.5
        UIView.animate(withDuration: 1.5, delay: 0.18, usingSpringWithDamping:  0.45, initialSpringVelocity: 10.0, options:[.curveEaseOut], animations: {
            imageView.alpha = 1.0
            let rotate = CGAffineTransform(rotationAngle: 0.0)
            let stretchAndRotate = rotate.scaledBy(x: 1.0, y: 1.0)
            imageView.transform = stretchAndRotate
            
        }, completion: nil)
    }
}
