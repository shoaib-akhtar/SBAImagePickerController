//
//  SBABundle.swift
//  Pods-Demo
//
//  Created by Shoaib Akhtar on 07/08/2019.
//

import Foundation
class SBABundle : NSObject {
    static func appBundle() -> Bundle{
        return Bundle.init(for: SBABundle.self)
    }
}

