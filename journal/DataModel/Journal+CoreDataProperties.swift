//
//  Journal+CoreDataProperties.swift
//  
//
//  Created by Diqing Chang on 03.12.17.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var html: String?
    @NSManaged public var timeStamp: NSDate?

}
