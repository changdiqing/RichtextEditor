//
//  TemplateLayout.swift
//  journal
//
//  Created by 齐永乐 on 2018/4/4.
//  Copyright © 2018年 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct TemplateLayoutItem{
    var htmlFileName: String = "wrong name"
    var append: Bool = false
    
    init(htmlFileName fileName: String, isAppended: Bool) {
        htmlFileName = fileName
        append = isAppended
    }
}

class TemplateLayout {
    static let templateLayoutList:[TemplateLayoutItem] = [
        TemplateLayoutItem(htmlFileName: "index1", isAppended: false),
        TemplateLayoutItem(htmlFileName: "index2", isAppended: false)
    ]
}
