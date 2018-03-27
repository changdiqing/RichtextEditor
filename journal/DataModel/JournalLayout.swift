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
    var append: Bool = false
    
    init(htmlFileName fileName: String, layoutImage image: UIImage?, isAppended: Bool) {
        htmlFileName = fileName
        append = isAppended
        if image != nil {
            layoutImage = image!
        }
        
    }
}

class JournalLayout {
    static let journalLayoutList:[JournalLayoutItem] = [
        JournalLayoutItem(htmlFileName: "touchBlock2x2", layoutImage: UIImage(named: "layout2x2"), isAppended: false),
        JournalLayoutItem(htmlFileName: "touchBlockFloating", layoutImage: UIImage(named: "layout2x2"), isAppended: true),
        JournalLayoutItem(htmlFileName: "touchBlockFloating", layoutImage: UIImage(named: "layout2x2"), isAppended: false),
    ]
}
