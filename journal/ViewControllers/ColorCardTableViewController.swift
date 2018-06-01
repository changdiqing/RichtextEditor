//
//  ColorCardTableViewController.swift
//  journal
//
//  Created by Diqing Chang on 25.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import RichEditorView

class ColorCardTableViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var colorCardTable: UITableView!
    @IBOutlet weak var filterWidth: NSLayoutConstraint!
    @IBOutlet weak var borderCollectionWidth: NSLayoutConstraint!
    @IBOutlet weak var touchBlockDashTabbar: UITabBar!
    @IBOutlet public weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var borderCollectionView: UICollectionView!
    
    fileprivate let filterList = DivMokupSets.divFilterList
    fileprivate let borderList = DivMokupSets.divBorderList
    fileprivate let fillingEffectList = FillingEffects.FillingEffectList
    
    let defaultButtonHeight: CGFloat = 100
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    var filterCellWidth: CGFloat?
    var buttonHeight: CGFloat = 0.00
    var selectedFillingEffect:FillingEffect?
    var selectedFilter:mokupItem?
    var selectedBorder: mokupItem?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCardTable.delegate = self
        colorCardTable.dataSource = self as UITableViewDataSource
        touchBlockDashTabbar.delegate = self as UITabBarDelegate
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self as UICollectionViewDelegate
        borderCollectionView.dataSource = self
        borderCollectionView.delegate = self as UICollectionViewDelegate
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
            selectedFillingEffect = fillingEffectList[selectedIndexPath.row]
        } else {
            selectedFillingEffect = nil
        }
        if segue.identifier == "setFilter" {
            let cell = sender as! CustomCollectionViewCell
            if let indexPath = self.filterCollectionView!.indexPath(for: cell){
                selectedFilter = filterList[indexPath.row]
            }
        } else if segue.identifier == "setBorder" {
            let cell = sender as! CustomCollectionViewCell
            if let indexPath = self.borderCollectionView!.indexPath(for: cell){
                selectedBorder = borderList[indexPath.row]
            }
        }
        
    }
    
    // MARK: - Actions
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
        return fillingEffectList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorCardTableCell", for: indexPath) as? colorCardTableViewCell else {
            fatalError("The dequeued cell is not an instance of colorCardCollectionViewCell.")
        }
        // Configure the cell...
        let thisFillingEffect = fillingEffectList[indexPath.row]
        cell.displayContent(type: thisFillingEffect.type, selectedColor: thisFillingEffect.color)
        return cell
    }
}

extension ColorCardTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: filterCellWidth!, height: filterCellWidth!);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return filterList.count
        } else {
            return borderList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView tag is \(collectionView.tag)")
        print("indexpath is \(indexPath.row)")
        
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionCell", for: indexPath) as! CustomCollectionViewCell
            
            let filter = filterList[indexPath.row]
            cell.displayContent(image: filter.coverImage, title: filter.name)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "borderCollectionCell", for: indexPath) as! CustomCollectionViewCell
            
            let border = borderList[indexPath.row]
            cell.displayContent(image: border.coverImage, title: border.name)
            return cell
        }
        
    }
}

extension ColorCardTableViewController:  UITabBarDelegate {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            filterWidth.constant = screenWidth
            borderCollectionWidth.constant = 0
            //filterCollectionView.layoutIfNeeded()
        } else if(item.tag == 1) {
            filterWidth.constant = 0
            borderCollectionWidth.constant = screenWidth
        } else {
            filterWidth.constant = 0
            borderCollectionWidth.constant = 0
        }
    }
}
