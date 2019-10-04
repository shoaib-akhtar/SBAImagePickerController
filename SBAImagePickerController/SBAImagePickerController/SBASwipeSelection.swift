//
//  SBASwipeSelection.swift
//  Pods
//
//  Created by Jawad Ali on 11/08/2019.
//

import UIKit
class SBASwipeSelection: NSObject {
    
    private unowned let viewController: AlbumPhotosViewController
    private let collectionView: UICollectionView
    private var lastAccessed : IndexPath?
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(gestureRecognizer:)))
        return pan
        
    }()
    
    init(viewController: AlbumPhotosViewController, collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
    }
    public func enable() {
        self.viewController.view.addGestureRecognizer(self.panGesture)
    }
    
    @objc private func panGestureHandler(gestureRecognizer: UIPanGestureRecognizer) {
        
        let pointerX = gestureRecognizer.location(in: self.collectionView).x //gestureRecognizer.locationInView:self.collectionView].x;
        let pointerY = gestureRecognizer.location(in: self.collectionView).y
        
        for  cell in self.collectionView.visibleCells {
            let cellSX = cell.frame.origin.x
            let cellEX = cell.frame.origin.x + cell.frame.size.width
            let cellSY = cell.frame.origin.y
            let cellEY = cell.frame.origin.y + cell.frame.size.height
            
            if pointerX >= cellSX && pointerX <= cellEX && pointerY >= cellSY && pointerY <= cellEY {
                let touchOver = self.collectionView.indexPath(for: cell)
                
                if (lastAccessed != touchOver ) {
 
                    if let lastIndexPath = lastAccessed {
                        if  let lastcell = self.collectionView.cellForItem(at: lastIndexPath) {
                            
                            if lastcell.isSelected && cell.isSelected {
                                
                                self.viewController .cellDeselect(at: lastIndexPath)
                                lastAccessed = touchOver
                                return
                                
                            }
                        }
                    }
                    
                    if cell.isSelected {
                        self.viewController .cellDeselect(at: touchOver!)
                    }
                    else {
                        self.viewController.cellSelect(at: touchOver!)
                    }
                }
                
                lastAccessed = touchOver
            }
        }
        
        if gestureRecognizer.state == .ended {
            lastAccessed = nil;
            self.collectionView.isScrollEnabled = true;
        }
    }
        
    
}
