//
//  JournalLayout.swift
//  journal
//
//  Created by Diqing Chang on 14.12.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct htmlFile{
    var htmlFileName: String = "wrong name"
    var image: UIImage = UIImage(named: "centerImage")!
    var append: Bool = false
    
    init(htmlFileName fileName: String, image uiImage: UIImage?, isAppended: Bool) {
        htmlFileName = fileName
        append = isAppended
        if uiImage != nil {
            image = uiImage!
        }
    }
}

class Touchblocks {
    static let list:[htmlFile] = [
        htmlFile(htmlFileName: "touchBlock2x2", image: UIImage(named: "layout2x2"), isAppended: false),
        htmlFile(htmlFileName: "touchBlockFloating", image: UIImage(named: "layout2x2"), isAppended: true),
    ]
}

class Templates {
    static let templateList:[htmlFile] = [
        htmlFile(htmlFileName: "index1", image: UIImage(named: "Aqua"),isAppended: false),
        htmlFile(htmlFileName: "index2", image: UIImage(named: "Darkgreen"),isAppended: false),
        htmlFile(htmlFileName: "index3", image: UIImage(named: "Mediumpurple"), isAppended: false),
        htmlFile(htmlFileName: "template1", image: UIImage(named: "Mediumpurple"), isAppended: false)
    ]
}
