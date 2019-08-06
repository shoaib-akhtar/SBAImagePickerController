//
//  SelectedAssets.swift
//  Hidebox
//
//  Created by Zeeshan Anjum on 14/01/2019.
//  Copyright © 2019 QuantumCPH. All rights reserved.
//

import Foundation
import Photos

class SelectedAssets: NSObject {
    var assets: [PHAsset]
    
    override init() {
        assets = []
    }
    
    init(assets:[PHAsset]) {
        self.assets = assets
    }
}

