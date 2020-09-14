//
//  WorkoutDAO.swift
//  dayrec
//
//  Created by SOON WON KA on 2020/09/14.
//  Copyright © 2020 Shawn. All rights reserved.
//

import UIKit
import CoreData

class WorkoutDAO {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch() -> [WorkoutData] {
        var workoutList = [WorkoutData]()
        
        // construct the fetch request instance
        let fetchRequest: NSFetchRequest<WorkoutMO> = WorkoutMO.fetchRequest()
        
        // date in descending order
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        
        do {
            let resultSet = try self.context.fetch(fetchRequest)
            
            // typecast from NSManagedObject to WorkoutData
            for record in resultSet {
                workoutList.append(self.toWorkoutData(record: record))
            }
        } catch let e as NSError {
            NSLog("An error has occurred: %s", e.localizedDescription)
        }
        
        return workoutList
    }
    
    func insert(_ data: WorkoutData) -> Bool {
        let object = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: self.context) as! WorkoutMO
        
        // copy the values
        object.workoutIdx = data.workoutIdx ?? -1
        object.workoutName = data.workoutName
        object.workoutTags = data.workoutTags?.description
        object.contents = data.contents
        object.regdate = data.regdate
        
        // apply the changes into the persistent storage
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            self.context.rollback()
            NSLog("An error has occurred: %s", e.localizedDescription)
            return false
        }
    }
    
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        // find and delete the target object
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        
        // apply the changes into the persistent storage
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog("An error has occurred: %s", e.localizedDescription)
            return false
        }
    }

    func toWorkoutData(record: WorkoutMO) -> WorkoutData {
        let data = WorkoutData()

        // copy the values
        data.workoutIdx = record.workoutIdx
        data.workoutName = record.workoutName
        let stringAsData = record.workoutTags!.data(using: String.Encoding.utf16)
        data.workoutTags = try! JSONDecoder().decode([String].self, from: stringAsData!)
        data.contents = record.contents
        data.regdate = record.regdate
        
        data.objectID = record.objectID
        
        return data
    }
}
