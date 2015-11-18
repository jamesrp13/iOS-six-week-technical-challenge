//
//  Person.swift
//  PairRandomizer
//
//  Created by James Pacheco on 11/18/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation
import CoreData


class Person: NSManagedObject {

    convenience init(firstName: String, lastName: String, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.firstName = firstName
        self.lastName = lastName
    }
}
