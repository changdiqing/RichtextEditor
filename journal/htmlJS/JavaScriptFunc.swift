//
//  JavaScriptFunc.swift
//  journal
//
//  Created by Diqing Chang on 08.12.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import JavaScriptCore

class JavaScriptFunc : NSObject, JavaScriptFuncProtocol {
    func test() {
    }
    
    func test2(_ value: String, _ num: Int) {
        print("value: \(value), num: \(num)")
    }
}
