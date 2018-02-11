//
//  ColorCardTableViewController.swift
//  journal
//
//  Created by Diqing Chang on 25.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import RichEditorView

class ColorCardTableViewController:   UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var colorCardTable: UITableView!
    @IBOutlet weak var addImageButtonHeight: NSLayoutConstraint!
    
    let defaultButtonHeight: CGFloat = 100
    var buttonHeight: CGFloat = 0.00
    var colorCard:[UIColor] = []
    var selectedColor:UIColor?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCard = [UIColor.black,
                    UIColor.darkestIndigo(),
                    UIColor.lighterIndigo(),
                    UIColor.lighterAlice(),
                    UIColor.darkestKelly(),
                    UIColor.darkestDaisy(),
                    UIColor.darkerCoral(),
                    UIColor.darkerRuby(),
                    UIColor.white]
        
        colorCardTable.delegate = self
        colorCardTable.dataSource = self
        
        addImageButtonHeight.constant = buttonHeight
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  selectedIndexPath = colorCardTable.indexPathForSelectedRow {
            selectedColor = colorCard[selectedIndexPath.row]
        } else {
            selectedColor = nil
        }
        
    }

}

// MARK: - Table view data source
extension ColorCardTableViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0;//Choose your custom row height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colorCard.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCardTableCell", for: indexPath)
        
        // Configure the cell...
        cell.contentView.backgroundColor = colorCard[indexPath.row]
        return cell
    }
}
