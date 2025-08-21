//
//  MultipartFile.swift
//  GIS-Agent
//
//  Created by Akshaykumar Maldhure on 9/20/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import Foundation
import UIKit


class MultipartFile: NSObject {
    var data : Data!
    var name : String = "image"
    var fileName : String = "image.png"
    var mimeType : String = "image/png"

    init(data : Data, name : String = "image", fileName : String = "image.png", mimeType : String = "image/png") {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

class MultipartFileJPEG: NSObject {
    var data : Data!
    var name : String = "image"
    var fileName : String = "image.jpeg"
    var mimeType : String = "image/jpeg"

    init(data : Data, name : String = "image", fileName : String = "image.jpeg", mimeType : String = "image/jpeg") {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
