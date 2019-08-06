//
//  General.swift
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
    
    func scrollToTopItem(position: UICollectionView.ScrollPosition = .top,animated: Bool = false) {
        if self.numberOfSections >= 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            self.scrollToItem(at: indexPath, at: position, animated: animated)
        }
    }
    
    
}
protocol EmptyMessageViewType {
    mutating func setEmptyMessage(_ message: String)
    mutating func restore()
}

protocol ListViewType: EmptyMessageViewType where Self: UIView {
    var backgroundView: UIView? { get set }
}

extension UITableView: ListViewType {}
extension UICollectionView: ListViewType {}

extension ListViewType {
    func setEmptyMessage(_ message: String) {
        
        
        
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: self.bounds.size.width,
                                                 height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.sizeToFit()
        
        backgroundView = messageLabel
    }
    
    func restore() {
        backgroundView = nil
    }
}
