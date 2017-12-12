//
//  ImageHandler.swift
//  journal
//
//  Created by Diqing Chang on 10.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import Foundation

class ImageHandler {
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

