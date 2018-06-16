//
//  divFilter.swift
//  journal
//
//  Created by Diqing Chang on 17.02.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct mokupItem {
    let name: String
    let coverImage: UIImage
    let jsCommand: String
    
    init(name _filterName: String, coverImage _coverImage: UIImage, jsCommand _jsCommand: String) {
        name = _filterName
        jsCommand = _jsCommand
        coverImage = _coverImage
    }
}

class DivMokupSets {
    static let divFilterList:[mokupItem] = [
        mokupItem(name: "Blur", coverImage: UIImage(named: "layouts")!, jsCommand: "blur(3px)"),
        mokupItem(name: "Black and white", coverImage: UIImage(named: "layouts")!, jsCommand: "grayscale(100%)"),
        mokupItem(name: "Overexposed", coverImage: UIImage(named: "layouts")!, jsCommand: "contrast(200%) brightness(150%)"),
        mokupItem(name: "Sepia", coverImage: UIImage(named: "layouts")!, jsCommand: "sepia(100%)"),
        mokupItem(name: "Saturate", coverImage: UIImage(named: "layouts")!, jsCommand: "saturate(5)"),
        mokupItem(name: "Transluzent", coverImage: UIImage(named: "layouts")!, jsCommand: "opacity(30%)"),
        mokupItem(name: "Hue Rotate", coverImage: UIImage(named: "layouts")!, jsCommand: "hue-rotate(90deg)"),
        mokupItem(name: "Invert", coverImage: UIImage(named: "layouts")!, jsCommand: "invert(100%)")
    ]
    
    static let divBorderList:[mokupItem] = [
        mokupItem(name: "No Border", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Black Solid", coverImage: UIImage(named: "border")!, jsCommand: "4px solid"),
        mokupItem(name: "Black Dotted", coverImage: UIImage(named: "border")!, jsCommand: "4px dotted"),
        mokupItem(name: "Black Dashed", coverImage: UIImage(named: "border")!, jsCommand: "4px dashed"),
        mokupItem(name: "Black Double", coverImage: UIImage(named: "border")!, jsCommand: "6px double"),
        mokupItem(name: "DarkKhaki Groove", coverImage: UIImage(named: "border")!, jsCommand: "6px groove"),
        mokupItem(name: "DarkSlateGray Ridge", coverImage: UIImage(named: "border")!, jsCommand: "6px ridge"),
        mokupItem(name: "Tan Inset", coverImage: UIImage(named: "border")!, jsCommand: "6px inset"),
        mokupItem(name: "DarkRed Outset", coverImage: UIImage(named: "border")!, jsCommand: "6px outset")

    ]
    
    static let divFontsList:[mokupItem] = [
        
        // following fonts do not support chinese characters!!
        /*
        mokupItem(name: "serif", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "American Typewriter", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Academy Engraved LET", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "serif", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Hiragino Mincho ProN", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Palatino", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        */
        
        // following support chinese characters
        mokupItem(name: "Times New Roman", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Academy Engraved LET", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Baskerville", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Heiti SC, Heiti TC", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "微软正黑体", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Chalkboard SE", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Chalkduster", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Courier New", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Arial", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Cochin", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Impact,Charcoal,sans-serif", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "Hiragino Kaku Gothic ProN", coverImage: UIImage(named: "border")!, jsCommand: "4px none"),
        mokupItem(name: "sans-serif", coverImage: UIImage(named: "border")!, jsCommand: "4px none")
        
        
        
        //mokupItem(name: "default fonts", coverImage: UIImage(named: "border")!, jsCommand: "4px none")
    ]
    
    static let list:[mokupItem] = [
        mokupItem(name: "alignRight", coverImage: UIImage(named: "alignRight")!, jsCommand: ""),
        mokupItem(name: "alignLeft", coverImage: UIImage(named: "alignLeft")!, jsCommand: ""),
        mokupItem(name: "alignMiddle", coverImage: UIImage(named: "alignMiddle")!, jsCommand: ""),
        mokupItem(name: "underline", coverImage: UIImage(named: "underline")!,jsCommand: ""),
        mokupItem(name: "strikethrough", coverImage: UIImage(named: "strikethrough")!,jsCommand: ""),
        mokupItem(name: "italic", coverImage: UIImage(named: "italic")!,jsCommand: ""),
        mokupItem(name: "textBigger", coverImage: UIImage(named: "textBigger")!,jsCommand: ""),
        mokupItem(name: "textSmaller", coverImage: UIImage(named: "textSmaller")!,jsCommand: "")
    ]
    
    static let shareOptions:[mokupItem] = [
        mokupItem(name: "iosphoto", coverImage: UIImage(named: "iosPhoto")!, jsCommand: ""),
        mokupItem(name: "wechat", coverImage: UIImage(named: "wechat")!, jsCommand: ""),
        ]
}
