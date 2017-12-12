//
//  CoreDataHandler.swift
//  journal(Richtext Editor)
//
//  Created by Diqing Chang on 12.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CoreDataHandler {
    
    static func fetchDiaryByDate(_ selectedDate: Date) -> [Journal]? {
        
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        fetchRequest.fetchLimit = 5  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Journal"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate(format: "timeStamp == %@",selectedDate as CVarArg)
        fetchRequest.predicate = predicate
        
        print(fetchRequest)
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest)
            return fetchedObjects
        }catch {
            let nserror = error as NSError
            fatalError("fetch error： \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func createNewDiary(_ selectedDate: Date) -> Journal{
        //init, add time stemp and empty content
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let newDiary = Journal(context: context)
        newDiary.timeStamp = selectedDate as NSDate
        newDiary.html = ""
        //app.saveContext()
        print(newDiary)
        return newDiary
    }
    
    static func saveDiary() {
        let app = UIApplication.shared.delegate as! AppDelegate
        print("saved!!!!!")
        //let context = app.persistentContainer.viewContext
        app.saveContext()
    }
    
    static func deleteDiary(_ myJournal: Journal?) {
        if myJournal != nil {
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            //let context = myDiary.managedObjectContext // questionable, will this work?
            context.delete(myJournal!)
            app.saveContext()
        }
    }
}
