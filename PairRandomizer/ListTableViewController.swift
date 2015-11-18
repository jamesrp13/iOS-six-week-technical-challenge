//
//  ListTableViewController.swift
//  PairRandomizer
//
//  Created by James Pacheco on 11/18/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    var paired = false
    
    @IBOutlet weak var pairButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paired {
            return PairController.sharedInstance.pairs.count
        } else {
            return PersonController.sharedInstance.people.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if paired {
            let pair = PairController.sharedInstance.pairs[indexPath.row]
            if let personArray = pair.people?.allObjects as? [Person] {
                let person1 = personArray[0]
                if person1 == personArray.last {
                    cell.textLabel?.text = "\(person1.firstName) \(person1.lastName)"
                } else {
                    let person2 = personArray[1]
                    cell.textLabel?.text = "\(person1.firstName) \(person1.lastName) and \(person2.firstName) \(person2.lastName)"
                }
                
            }
        } else {
            let person = PersonController.sharedInstance.people[indexPath.row]
            cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            tableView.beginUpdates()
            PersonController.sharedInstance.deletePerson(PersonController.sharedInstance.people[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
            
        }
    }

}

extension ListTableViewController {
    
    @IBAction func pairButtonTapped(sender: AnyObject) {
        if paired {
            PairController.sharedInstance.unPair()
            paired = false
            tableView.reloadData()
            pairButton.setTitle("Pair", forState: .Normal)
        } else {
            paired = true
            PairController.sharedInstance.generateRandomPairs(PersonController.sharedInstance.people)
            tableView.reloadData()
            pairButton.setTitle("Unpair", forState: .Normal)
        }
    }
    
    @IBAction func clearButtonTapped(sender: AnyObject) {
        if paired {
            pairButtonTapped(self)
        } else {
            PersonController.sharedInstance.clear()
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Add Person", message: "Please input a first and last name", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField1) -> Void in
            textField1.placeholder = "First name..."
        }
        alert.addTextFieldWithConfigurationHandler { (textField2) -> Void in
            textField2.placeholder = "Last name..."
        }
        alert.addAction(UIAlertAction(title: "Add Person", style: .Default, handler: { (add) -> Void in
            guard let firstName = alert.textFields?.first?.text,
                let lastName = alert.textFields?.last?.text where
                firstName.characters.count > 0 && lastName.characters.count > 0 else {self.alertForNoName(); return}
            
            let _ = Person(firstName: firstName, lastName: lastName)
            PersonController.sharedInstance.saveToPersistentStore()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertForNoName() {
        let alert = UIAlertController(title: "Invalid Entry", message: "You must input both a first and last name", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
