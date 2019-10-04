//
//  UIScrollView+EmptyDataControl.swift
//  SBAImagePickerController
//
//  Created by Jawad Ali on 07/08/2019.
//  Copyright © 2019 ShoaibAkhtar. All rights reserved.
//

import UIKit
class WeakObjectContainer: NSObject {
    weak var weakObject: AnyObject?
    
    init(with weakObject: Any?) {
        super.init()
        self.weakObject = weakObject as AnyObject?
    }
}

 private var kEmptyDataSetSource = "emptyDataSetSourcePhoto"

extension UIScrollView {
    public var emptyDataSetSource:  EmptySetDataSetSource? {
        get {
            let container = objc_getAssociatedObject(self, &kEmptyDataSetSource) as? WeakObjectContainer
            return container?.weakObject as? EmptySetDataSetSource
        }
        set {
            
            objc_setAssociatedObject(self, &kEmptyDataSetSource, WeakObjectContainer(with: newValue), .OBJC_ASSOCIATION_ASSIGN)
             
            UIScrollView.swizzleReloadScrollData
            if self is UITableView {
                UIScrollView.swizzleEndAllUpdates
            }
        }
    }
     func removeAssociation(){
        UIScrollView.swizzleBack
       
    }
    
    //MARK: - Method Swizzling
    @objc private func tableViewSwizzleReloadData() {
        tableViewSwizzleReloadData()
        reloadEmptyDataSet()
    }
    
    @objc private func tableViewSwizzledEndAllUpdates() {
        tableViewSwizzledEndAllUpdates()
        reloadEmptyDataSet()
    }
    
    @objc private func collectionViewSwizzledAllReloadData() {
        collectionViewSwizzledAllReloadData()
        reloadEmptyDataSet()
       
    }
    
    private class func swizzleMethod(for aClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(aClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)
        
        let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    private static let swizzleReloadScrollData: () = {
        let tableViewOriginalSelector = #selector(UITableView.reloadData)
        let tableViewSwizzledSelector = #selector(UIScrollView.tableViewSwizzleReloadData)
        
        swizzleMethod(for: UITableView.self, originalSelector: tableViewOriginalSelector, swizzledSelector: tableViewSwizzledSelector)
        
        let collectionViewOriginalSelector = #selector(UICollectionView.reloadData)
        let collectionViewSwizzledSelector = #selector(UIScrollView.collectionViewSwizzledAllReloadData)
        
        swizzleMethod(for: UICollectionView.self, originalSelector: collectionViewOriginalSelector, swizzledSelector: collectionViewSwizzledSelector)
    }()
    
    private static let swizzleBack: () = {
        let tableViewSwizzledSelector  = #selector(UITableView.reloadData)
        let tableViewOriginalSelector = #selector(UIScrollView.tableViewSwizzleReloadData)
        
        swizzleMethod(for: UITableView.self, originalSelector: tableViewOriginalSelector, swizzledSelector: tableViewSwizzledSelector)
        
        let collectionViewOriginalSelector = #selector(UICollectionView.reloadData)
        let collectionViewSwizzledSelector = #selector(UIScrollView.collectionViewSwizzledAllReloadData)
        
        swizzleMethod(for: UICollectionView.self, originalSelector: collectionViewOriginalSelector, swizzledSelector: collectionViewSwizzledSelector)
    }()
    
    private static let swizzleEndAllUpdates: () = {
        let originalSelector = #selector(UITableView.endUpdates)
        let swizzledSelector = #selector(UIScrollView.tableViewSwizzledEndAllUpdates)
        
        swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    public func reloadEmptyDataSet() {
        if let collectionView = self as? UICollectionView {
            if (itemsCount != 0) {
                collectionView.restore()
            }
        }
    }
    internal var itemsCount: Int {
        var items = 0
        
        // UITableView support
        if let tableView = self as? UITableView {
            var sections = 1
            
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: tableView)
                }
                if dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.tableView(tableView, numberOfRowsInSection: i)
                    }
                }
            } // UICollectionView support
        } else if let collectionView = self as? UICollectionView {
            var sections = 1
            
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: collectionView)
                }
                if dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.collectionView(collectionView, numberOfItemsInSection: i)
                    }
                }
            }
        }
        
        return items
    }
    
}
