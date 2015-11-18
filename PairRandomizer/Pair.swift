//
//  Pair.swift
//  PairRandomizer
//
//  Created by James Pacheco on 11/18/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation
import CoreData


class Pair: NSManagedObject {

    convenience init(person1: Person, person2: Person?, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Pair", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if let person2 = person2 {
        
            self.people = NSSet(array: [person1, person2])
        } else{
            self.people = NSSet(array: [person1])
        }
    }

}
