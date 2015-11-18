//
//  PersonController.swift
//  PairRandomizer
//
//  Created by James Pacheco on 11/18/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation
import CoreData

class PersonController {
    
    static let sharedInstance = PersonController()
    
    var people: [Person] {
        let moc = Stack.sharedStack.managedObjectContext
        let request = NSFetchRequest(entityName: "Person")
        do {
            let people = try moc.executeFetchRequest(request) as! [Person]
            return people.sort { $0.lastName < $1.lastName }
        } catch {
            print("Error loading: \(error)")
            return []
        }
    }
    
    func deletePerson(person: Person) {
        let moc = Stack.sharedStack.managedObjectContext
        
        moc.deleteObject(person)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = Stack.sharedStack.managedObjectContext
        
        do {
            try moc.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func clear() {
        for person in people {
            deletePerson(person)
        }
    }
    
}
