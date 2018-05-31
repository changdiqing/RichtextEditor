//
//  JournalCollectionViewController.swift
//  journal
//
//  Created by Diqing Chang on 03.03.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "Cell"

class JournalCollectionViewController: UICollectionViewController {
    //MARK: Properties
    fileprivate let reuseIdentifier = "journalCell"
    //fileprivate var journals = [Journal]()
    fileprivate var myJournals = [[Journal]]()
    fileprivate var editingMode: Bool = false
    @IBOutlet weak var journalAddButton: UIBarButtonItem!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //fileprivate var editing: Bool = false
    var testDate:Date {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            return formatter.date(from: "2016/10/08 22:31")!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(JournalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
         //Load any saved journals
        if let savedJournals = loadJournals() {
            myJournals += savedJournals

        }

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.flowLayout.minimumLineSpacing = 10
        self.flowLayout.minimumInteritemSpacing = 5
        self.flowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        self.flowLayout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        //self.flowLayout.autoContentAccessingProxy
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.collectionView!.allowsMultipleSelection = editing
        let indexPaths: [NSIndexPath] = self.collectionView!.indexPathsForVisibleItems as [NSIndexPath]
        self.editingMode = editing
        for indexPath in indexPaths {
            self.collectionView!.deselectItem(at: indexPath as IndexPath, animated: false)
        }
        self.collectionView?.reloadData()
        
        if editing {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedItemsAction))
        } else {
            self.navigationItem.rightBarButtonItem = self.journalAddButton
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !editingMode {
            super.prepare(for: segue, sender: sender)
            // Get the new view controller using [segue destinationViewController].
            // Pass the selected object to the new view controller.
            switch(segue.identifier ?? "") {
            case "addJournal":
                os_log("Adding a new meal.", log: OSLog.default, type: .debug)
                //guard let templateLayoutCollectionVC = segue.destination as? TemplateLayoutCollectionViewController else {fatalError("Unexpected destination: \(segue.destination)")}
            case "editJournal":
                guard let journalViewController = segue.destination as? JournalViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let cellIndex = self.collectionView?.indexPathsForSelectedItems?.first! else {
                    fatalError("No cell selected")
                }
                let selectedJournal = myJournals[cellIndex.section][cellIndex.item]
                journalViewController.journal = selectedJournal
            default:
                fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return myJournals.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myJournals[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? JournalCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of JournalCollectionViewCell.")
        }
    
        // Configure the cell
        cell.photo.image = myJournals[indexPath.section][indexPath.item].photo
        cell.checkboxImageView.isHidden = !self.editingMode
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        return cell
     
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView?.collectionViewLayout.invalidateLayout()
//    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.editingMode {
            performSegue(withIdentifier: "editJournal", sender: nil)
        } else {
            return
        }
        
    }
    
    
    // reloadData to fix the bug by safe area of iPhone X
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //collectionView?.reloadData()
    }
    
    // Section Header View
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeaderView", for: indexPath) as! sectionHeaderView
        //print(myJournals.capacity)
        if myJournals[indexPath.section].count > 0 {
            let myMonth = myJournals[indexPath.section][0].month!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            //sectionHeaderView.monthLabel.isHidden = false
            sectionHeaderView.monthTitle = dateFormatter.string(from: myMonth)
        } else {
            sectionHeaderView.monthTitle = "Empty section"
            //sectionHeaderView.monthLabel.isHidden = true
        }
       
        return sectionHeaderView
        
    }
    
   
    
    //MARK: Actions
    
    @IBAction func unwindToJournalList(sender: UIStoryboardSegue){
        
            if let sourceViewController = sender.source as? JournalViewController, let journal = sourceViewController.journal {
                if let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first{
                    // Update an existing journal
                    myJournals[selectedIndexPath.section][selectedIndexPath.item] = journal
                    collectionView?.reloadItems(at: [selectedIndexPath])
                } else {
                    // Add a new journal
                    //let cellItem = self.collectionView?.numberOfItems(inSection: 0)
                    let newIndexPath = IndexPath(item: 0, section: 0)
                    if myJournals.count < 1 {
                        myJournals.insert([], at: 0)
                        collectionView?.insertSections([0])
                    } else {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM yyyy"
                        var isEqual: Bool = true
                        if myJournals[0].count > 0 {
                            let month1 = dateFormatter.string(from: myJournals[0][0].month!)
                            let month2 = dateFormatter.string(from: journal.month!)
                            isEqual = (month1 == month2)
                        }
                        if isEqual == false {
                            myJournals.insert([], at: 0)
                            collectionView?.insertSections([0])
                        }
                    }
                    myJournals[0].insert(journal, at: 0)
                    collectionView?.insertItems(at: [newIndexPath])
                }
                self.saveJournals()
            }
        
        let sectionToReload = 0
        let indexSet: IndexSet = [sectionToReload]
        self.collectionView?.reloadSections(indexSet)
    }
    
    //MARK: Private Methods
    
    private func saveJournals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myJournals, toFile: Journal.ArchiveURL.path)
    
        if isSuccessfulSave {
            os_log("Journals succesfully saved.", log: OSLog.default, type: .debug)
        } else {
        os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadJournals() -> [[Journal]]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Journal.ArchiveURL.path) as? [[Journal]]
    }
    
    private func getJournalIndex(indexPath: IndexPath) -> Int {
        var sumSections: Int = 0
        for i in (0 ..< indexPath.section) {
            let itemsInSection = self.collectionView?.numberOfItems(inSection: i)
            sumSections = sumSections + itemsInSection!
        }
        let journalIndex: Int  = sumSections + indexPath.item
        return journalIndex
    }
    
    private func getSectionAmount() -> Int{
        return myJournals.count
    }
    
    @objc private func deleteSelectedItemsAction(sender: UIBarButtonItem) {
        let selectedIndexPaths: [NSIndexPath] = self.collectionView!.indexPathsForSelectedItems! as [NSIndexPath]

        print("this is selectedIndexPaths: \(selectedIndexPaths)")
        
        let reversedIndexes = selectedIndexPaths.sorted(by: { $0.row > $1.row })
        for index in reversedIndexes {self.myJournals[index.section].remove(at: index.row)}
        self.collectionView!.deleteItems(at: selectedIndexPaths as [IndexPath])
        
        let indexSet = NSMutableIndexSet()
        for month in self.myJournals.reversed() {
            if month.isEmpty {
                let myIndex = self.myJournals.index(of: month)!
                self.myJournals.remove(at: myIndex)
                indexSet.add(myIndex)
            }
        }
        self.collectionView?.deleteSections(indexSet as IndexSet)
        self.saveJournals()
    }
    
    private func indexPathIsValid(indexPath1: NSIndexPath, indexPath2: NSIndexPath) -> Bool {
        return indexPath1.section < indexPath2.section && indexPath1.row < indexPath2.row
    }
}

extension JournalCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myItem = self.myJournals[indexPath.section][indexPath.item]
        //let screenSize = UIScreen.main.bounds
        let itemWidth = (myItem.photo?.size.width)! / 4.4;
        let itemHeight = (myItem.photo?.size.height)! / 4.4;
        return CGSize(width: itemWidth, height: itemHeight)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}
