//
//  JournalLayout.swift
//  journal
//
//  Created by Diqing Chang on 14.12.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct JournalLayoutItem{
    var htmlFileName: String = "wrong name"
    var layoutImage: UIImage = UIImage(named: "centerImage")!
    init(htmlFileName fileName: String, layoutImage image: UIImage?) {
        htmlFileName = fileName
        if image != nil {
            layoutImage = image!
        }
        
    }
}

class JournalLayout {
    static let journalLayoutList:[JournalLayoutItem] = [
                                                JournalLayoutItem(htmlFileName: "touchBlock2x2", layoutImage: UIImage(named: "layout2x2")),
                                                JournalLayoutItem(htmlFileName: "touchBlock3x3", layoutImage: UIImage(named: "layout3x3")),
                                                JournalLayoutItem(htmlFileName: "touchBlock4x4", layoutImage: UIImage(named: "layout4x4")),
                                                ]
}
