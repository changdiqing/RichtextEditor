//
//  TemplateLayout.swift
//  journal
//
//  Created by 齐永乐 on 2018/4/4.
//  Copyright © 2018年 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct TemplateItem{
    var htmlFileName: String = "wrong name"
    var templateImage: UIImage = UIImage(named: "Aqua")!
    var append: Bool = false
    
    init(htmlFileName fileName: String, templateImage image: UIImage? ,isAppended: Bool) {
        htmlFileName = fileName
        append = isAppended
        if image != nil {
            templateImage = image!
        }
    }
}

class Templates {
    static let templateList:[TemplateItem] = [
        TemplateItem(htmlFileName: "index1", templateImage: UIImage(named: "Aqua"),isAppended: false),
        TemplateItem(htmlFileName: "index2", templateImage: UIImage(named: "Darkgreen"),isAppended: false),
        TemplateItem(htmlFileName: "index3", templateImage: UIImage(named: "Mediumpurple"), isAppended: false)
    ]
}
