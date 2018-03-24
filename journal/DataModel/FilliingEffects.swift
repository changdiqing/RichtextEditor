//
//  JournalLayout.swift
//  journal
//
//  Created by Diqing Chang on 23.03.118.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct FillingEffect{
    var type: String!
    var color: UIColor?
    
    init(_ myType: String, _ myColor: UIColor?) {
        type = myType
        if myType == "color" {
            color = myColor!
        }
    }
}

class FillingEffects {
    static let FillingEffectList:[FillingEffect] = [
        FillingEffect("Photo", nil),
        FillingEffect("No Filling", nil),
        FillingEffect("color", UIColor.black),
        FillingEffect("color", UIColor.darkestIndigo()),
        FillingEffect("color", UIColor.lighterIndigo()),
        FillingEffect("color", UIColor.lighterAlice()),
        FillingEffect("color", UIColor.darkestKelly()),
        FillingEffect("color", UIColor.darkestDaisy()),
        FillingEffect("color", UIColor.darkerCoral()),
        FillingEffect("color", UIColor.darkerRuby()),
        FillingEffect("color", UIColor.darkerRuby()),
        FillingEffect("color", UIColor.white)]
}

