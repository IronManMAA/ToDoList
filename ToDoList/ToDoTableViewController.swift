//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Marco Almeida on 12/29/16.
//  Copyright © 2016 THE IRON YARD. All rights reserved.
//


import UIKit
import CoreData
    
class ToDoTableViewController: UITableViewController, UITextFieldDelegate
    {
        // Retrieve the managed object context from the AppDelegate
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var todoItems = [ToDoItem]()
    
        override func viewDidLoad()
        {
            super.viewDidLoad()
            title = "To Do List"
            
            navigationItem.leftBarButtonItem = editButtonItem
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItem")
            
            // Execute the fetch request, and cast the results to an array of LogItem objects
            do {
                let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [ToDoItem]
                todoItems = fetchResults!
            }
            catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        
        override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int
        {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return todoItems.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as!ItemCell
            
            // Configure the cell...
            let aItem = todoItems[indexPath.row]
            
            if aItem.todoText == nil
            {
                cell.counterTitle.becomeFirstResponder()
            }
            else
            {
                cell.counterTitle.text = aItem.todoText
                if (aItem.todoCheckBox.description == "true") {
                    cell.doneLabel.text = "Done:"
                    cell.toDoCheckBox.isOn = true
                } else {
                    cell.doneLabel.text = "ToDo:"
                    cell.toDoCheckBox.isOn = false
                }
            }
            return cell
        }
        
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
        {
            return true
        }
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
        {
            if editingStyle == .delete
            {
                let aCounter = todoItems[indexPath.row]
                todoItems.remove(at: indexPath.row)
                managedObjectContext.delete(aCounter)
                saveContext()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        // MARK: - UITextField Delegate
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            var rc = false
            
            if textField.text != ""
            {
                rc = true
                let contentView = textField.superview
                let cell = contentView?.superview as! ItemCell
                let indexPath = tableView.indexPath(for: cell)
                let aItem = todoItems[indexPath!.row]
                aItem.todoText = textField.text
                textField.resignFirstResponder()
                saveContext()
            }
            
            return rc
        }
        
        // MARK: - Action Handlers
        
        @IBAction func toDoCheckBoxValueChanged(_ sender: UISwitch)
        {
            let contentView = sender.superview
            let cell = contentView?.superview as! ItemCell
            let indexPath = tableView.indexPath(for: cell)
            let aStatus = todoItems[indexPath!.row]
            if (cell.toDoCheckBox.isOn == true) {
               cell.doneLabel.text = "Done:"
                aStatus.todoCheckBox = true
            } else {
               cell.doneLabel.text = "ToDo:"
                aStatus.todoCheckBox = false
            }
            saveContext()
        }
        
        @IBAction func addCounter(_ sender: UIBarButtonItem)
        {
            let newCounter = NSEntityDescription.insertNewObject(forEntityName: "ToDoItem", into: managedObjectContext) as! ToDoItem

            todoItems.append(newCounter)
            
            tableView.insertRows(at: [IndexPath(row: todoItems.count-1, section: 0)], with: .automatic)

        }
        
        // MARK: - Private
        
        func saveContext()
        {
            if managedObjectContext.hasChanges
            {
                do
                {
                    try managedObjectContext.save()
                } catch
                {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    //               abort()
                }
            }
        }
}
