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
    init(htmlFileName fileName: String, layoutImage image: UIImage!) {
        htmlFileName = fileName
        layoutImage = image!
    }
}

class JournalLayout {
    static let journalLayoutList:[JournalLayoutItem] = [
                                                JournalLayoutItem(htmlFileName: "htmlLayout1", layoutImage: UIImage(named: "centerImage")),
                                                JournalLayoutItem(htmlFileName: "test name", layoutImage: UIImage(named: "centerImage")),
                                                JournalLayoutItem(htmlFileName: "test name", layoutImage: UIImage(named: "centerImage")),
                                                JournalLayoutItem(htmlFileName: "test name", layoutImage: UIImage(named: "centerImage"))
                                                ]
}
