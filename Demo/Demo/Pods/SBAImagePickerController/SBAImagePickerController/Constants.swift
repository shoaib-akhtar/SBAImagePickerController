//
//  Constants.swift
//  SBAImagePickerController
//
//  Created by Jawad Ali on 06/08/2019.
//  Copyright © 2019 ShoaibAkhtar. All rights reserved.
//

import Foundation
struct PhotoPermissionAlert {
    static let title = Transaltions.shared.translation(for: "No Photo Permissions")
    static let message = Transaltions.shared.translation(for: "Please grant photo permissions in Settings")
    static let actionButtonTitle = Transaltions.shared.translation(for: "Settings")
}
struct NoPhotosInAlbum {
    static let title = Transaltions.shared.translation(for: "Whoops !!")
    static let message = Transaltions.shared.translation(for: "Sorry this album does not contain any photo. Please select other albums to select photos ") 
    static let image = "hg-error.png"
}
