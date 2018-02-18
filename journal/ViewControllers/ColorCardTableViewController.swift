//
//  ColorCardTableViewController.swift
//  journal
//
//  Created by Diqing Chang on 25.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import RichEditorView

class ColorCardTableViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
    
    @IBOutlet weak var colorCardTable: UITableView!
    @IBOutlet weak var addImageButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var filterWidth: NSLayoutConstraint!
    @IBOutlet weak var touchBlockDashTabbar: UITabBar!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    fileprivate let filterList = DivFilters.divFilterList
    
    let defaultButtonHeight: CGFloat = 100
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    var filterCellWidth: CGFloat?
    var buttonHeight: CGFloat = 0.00
    var colorCard:[UIColor] = []
    var selectedColor:UIColor?
    var selectedFilter:divFilter?
    

    
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
        colorCardTable.dataSource = self as UITableViewDataSource
        touchBlockDashTabbar.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self as UICollectionViewDelegate
        
        addImageButtonHeight.constant = buttonHeight
        filterWidth.constant = 0
        filterCellWidth = screenWidth/4
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
        if segue.identifier == "setFilter" {
            let cell = sender as! CustomCollectionViewCell
            if let indexPath = self.filterCollectionView!.indexPath(for: cell){
                selectedFilter = filterList[indexPath.row]
            }
            
        }
        
    }
    
    //MARK: - TabbarView Methods
    
    
    
}

// MARK: - Table view delegate
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

extension ColorCardTableViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: filterCellWidth!, height: filterCellWidth!);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionCell", for: indexPath) as! CustomCollectionViewCell
        
        let filter = filterList[indexPath.row]
        
        cell.displayContent(image: filter.coverImage, title: filter.name)
        
        return cell
    }
    
}

extension ColorCardTableViewController:  UITabBarDelegate {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            filterWidth.constant = screenWidth
            //filterCollectionView.layoutIfNeeded()
        } else if(item.tag == 1) {
            filterWidth.constant = 0
        }
    }
}
