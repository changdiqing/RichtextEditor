//
//  NSJournal.swift
//  journal
//
//  Created by Diqing Chang on 04.03.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Journal: NSObject, NSCoding {
    
    // NSCoding protocol
    
    //MARK: Properties
    
    var html: String
    var photo: UIImage?
    
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL: URL = DocumentsDirectory.appendingPathComponent("journals")
    
    struct PropertyKey {
        static let html = "html"
        static let photo = "photo"
    }
    
    //MARK: Initialization
    
    init(html: String, photo: UIImage?) {
        self.html = html
        self.photo = photo
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(html, forKey: PropertyKey.html)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init ?(coder aDecoder: NSCoder) {
        guard  let html = aDecoder.decodeObject(forKey: PropertyKey.html) as? String else {
            os_log("Unable to decode the html for a Journal object", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Journal, just use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(html: html, photo: photo)
    }
    
}
