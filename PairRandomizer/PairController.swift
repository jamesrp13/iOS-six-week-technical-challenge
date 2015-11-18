//
//  PairController.swift
//  PairRandomizer
//
//  Created by James Pacheco on 11/18/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import Foundation

class PairController {
    
    static let sharedInstance = PairController()
    
    var pairs: [Pair] = []
    
    func generateRandomPairs(people: [Person]) {
        var newPeople = people
        let numberOfPairs = (newPeople.count % 2 == 0) ? (newPeople.count / 2):((newPeople.count + 1) / 2)
        for (var i = 0; i < numberOfPairs; i++) {
            guard newPeople.count > 1 else {pairs.append(Pair(person1: newPeople[0], person2: nil)); break}
            var randomIndex1 = 0
            var randomIndex2 = 0
            while randomIndex1 == randomIndex2 {
                randomIndex1 = Int(arc4random_uniform(UInt32(newPeople.count)))
                randomIndex2 = Int(arc4random_uniform(UInt32(newPeople.count)))
            }
            
            let newPair = Pair(person1: newPeople[randomIndex1], person2: newPeople[randomIndex2])
            pairs.append(newPair)
            newPeople.removeAtIndex(randomIndex1 > randomIndex2 ? randomIndex1:randomIndex2)
            newPeople.removeAtIndex(randomIndex1 < randomIndex2 ? randomIndex1:randomIndex2)
        }
    }
    
    func unPair() {
        pairs = []
    }
    
}