//
//  KeyboardDelegate.swift
//  journal
//
//  Created by Diqing Chang on 11.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//
import UIKit

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method
protocol KeyboardDelegate: class {
    func keyWasTapped(color: UIColor)
    
    //func touchblockKeyTapped(fileName: String, isAppended: Bool)
    
    func cutomKeyTapped(keyId: String)
}
