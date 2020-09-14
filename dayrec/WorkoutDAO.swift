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
}
