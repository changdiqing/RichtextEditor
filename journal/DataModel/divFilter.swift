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
        mokupItem(name: "No Border", coverImage: UIImage(named: "border")!, jsCommand: "3px none black"),
        mokupItem(name: "Black Solid", coverImage: UIImage(named: "border")!, jsCommand: "3px solid black"),
        mokupItem(name: "Black Dotted", coverImage: UIImage(named: "border")!, jsCommand: "3px dotted black"),
        mokupItem(name: "Black Dashed", coverImage: UIImage(named: "border")!, jsCommand: "3px dashed black"),
        mokupItem(name: "Black Double", coverImage: UIImage(named: "border")!, jsCommand: "5px double black"),
        mokupItem(name: "DarkKhaki Groove", coverImage: UIImage(named: "border")!, jsCommand: "5px groove DarkKhaki"),
        mokupItem(name: "DarkSlateGray Ridge", coverImage: UIImage(named: "border")!, jsCommand: "5px ridge DarkSlateGray"),
        mokupItem(name: "Tan Inset", coverImage: UIImage(named: "border")!, jsCommand: "5px inset Tan"),
        mokupItem(name: "DarkRed Outset", coverImage: UIImage(named: "border")!, jsCommand: "5px outset DarkRed")

    ]
}
