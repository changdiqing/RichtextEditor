//
//  JavaScriptFuncProtocol.swift
//  journal
//
//  Created by Diqing Chang on 08.12.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JavaScriptFuncProtocol: JSExport {
    func showTouchblockMenu()
    func showImgMenu()
}
