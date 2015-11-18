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

}

extension ListTableViewController {
    
    @IBAction func pairButtonTapped(sender: AnyObject) {
        paired = true
        PairController.sharedInstance.generateRandomPairs(PersonController.sharedInstance.people)
        tableView.reloadData()
    }
    
    @IBAction func unpairButtonTapped(sender: AnyObject) {
        PairController.sharedInstance.unPair()
        paired = false
        tableView.reloadData()
    }
    
    @IBAction func clearButtonTapped(sender: AnyObject) {
        if paired {
            unpairButtonTapped(self)
        } else {
            PersonController.sharedInstance.clear()
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Please input a first and last name", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField1) -> Void in
            textField1.placeholder = "First name..."
        }
        alert.addTextFieldWithConfigurationHandler { (textField2) -> Void in
            textField2.placeholder = "Last name..."
        }
        alert.addAction(UIAlertAction(title: "Add Person", style: .Default, handler: { (add) -> Void in
            Person(firstName: (alert.textFields?.first?.text)!, lastName: (alert.textFields?.last?.text)!)
            PersonController.sharedInstance.saveToPersistentStore()
            self.tableView.reloadData()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
