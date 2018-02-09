//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Mohamed Sobhi Fouda on 2/6/18.
//  Copyright © 2018 Mohamed Sobhi Fouda. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    var items = [DataItem]()
    var otherItems = [DataItem]()
    //back for playing around adding extra DataItem
    var anOtherItems = [DataItem]()
    var allItems = [[DataItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        for i in 1...12 {
            if i > 9 {
                items.append(DataItem(title: "View #\(i)", subtitle: "This is  #\(i)", imageName: "img\(i).jpg"))
            } else {
                items.append(DataItem(title: "View #0\(i)", subtitle: "This is  #0\(i)", imageName: "img0\(i).jpg"))
            }
        }
        
        for i in 1...12 {
            if i > 9 {
                otherItems.append(DataItem(title: "Other View #\(i)", subtitle: "This is  #\(i)", imageName: "anim\(i).jpg"))
            } else {
                otherItems.append(DataItem(title: "Other View #0\(i)", subtitle: "This is #0\(i)", imageName: "anim0\(i).jpg"))
            }
        }
        
        for i in 1...6 {

                otherItems.append(DataItem(title: "Another View #0\(i)", subtitle: "This is #0\(i)", imageName: "eg\(i).jpg"))
            
        }
        
        allItems.append(items)
        allItems.append(otherItems)
        allItems.append(anOtherItems)
        // Do any additional setup after loading the view, typically from a nib.
    
        tableView.allowsSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tableView: UITableView!

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let addedRow = isEditing ? 1 : 0
        
        return allItems[section].count + addedRow
    }
    
    
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row >= allItems[indexPath.section].count && isEditing {
            cell.textLabel?.text = "Add New Item"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
            let item = allItems[indexPath.section][indexPath.row]
            
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            
            if let imageView = cell.imageView, let itemImage = item.image {
                imageView.image = itemImage
            } else {
                cell.imageView?.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section #\(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allItems[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            let newData = DataItem(title: "New Data", subtitle: "", imageName: nil)
            allItems[indexPath.section].append(newData)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = allItems[sourceIndexPath.section][sourceIndexPath.row]
        
        allItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        
        if sourceIndexPath.section == destinationIndexPath.section {
            allItems[sourceIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        } else {
            allItems[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        }
    }
    
}


extension TableViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sectionItems = allItems[indexPath.section]
        if isEditing && indexPath.row < sectionItems.count {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sectionItems = allItems[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= sectionItems.count {
            return IndexPath(row: sectionItems.count - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
}
