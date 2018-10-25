//
//  ViewController.swift
//  toDoApp
//
//  Created by vbox on 2018-10-01.
//  Copyright © 2018 vbox. All rights reserved.
//

import UIKit




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //List of Items
    public var list = ["Buy groceries", "Pay bills", "Wash dishes", "Finish project", "Create my own to do list"]
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addItem: UIButton!
    
    
    //Add items to the list with options to save and cancel
    @IBAction func addItem(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Add Item", message: "Add item", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = ""
            textField.placeholder = "Enter something"
        })
        //SAVE
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let textField = alertController.textFields![0]
            if (textField.text != "")
            {
                self.list.insert(textField.text!, at: 0)
                self.myTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        })
        //CANCEL
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Alert for edit and delete actions
    let alert = UIAlertController(title: "Update", message: "Update", preferredStyle: .alert)
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (list.count)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return(cell)
    }
    
    //Left swipe for editing and deleting rows
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        //EDIT
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (ACTION, indexPath) in
           let alert = UIAlertController(title: "", message: "Edit Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.list[indexPath.row]
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {(updateAction) in
                self.list[indexPath.row] = alert.textFields!.first!.text!
                self.myTableView.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        }
        
        //DELETE
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (ACTION, indexPath) in
            self.list.remove(at: indexPath.row)
            self.myTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .blue
        
        return [deleteAction, editAction]
    }
    
    //Mark item as complited
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexPathOfTheLastRow = NSIndexPath(row: self.list.count - 1, section: 0)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            self.myTableView.beginUpdates()
            self.myTableView.moveRow(at: indexPath, to: NSIndexPath(row: 0, section: 0) as IndexPath)
            self.myTableView.endUpdates()
            
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            self.myTableView.beginUpdates()
            self.list.swapAt(indexPath.row, indexPathOfTheLastRow.row)
            self.myTableView.moveRow(at: indexPath, to: indexPathOfTheLastRow as IndexPath)
            self.myTableView.endUpdates()
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItem.layer.cornerRadius = addItem.frame.size.width / 2
        let clearView = UIView()
        UITableViewCell.appearance().selectedBackgroundView = clearView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

