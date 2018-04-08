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
    //fileprivate let sectionHeaderView = "sectionHeaderView"
    fileprivate var journals = [Journal]()
    fileprivate let journalLayoutList = JournalLayout.journalLayoutList
    fileprivate var editingMode: Bool = false
    @IBOutlet weak var journalAddButton: UIBarButtonItem!
    
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
        
        // Load any saved journals
        if let savedJournals = loadJournals() {
            journals += savedJournals
        }

        self.navigationItem.leftBarButtonItem = self.editButtonItem
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
        print("Segeue activated")
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
                let selectedJournal = journals[cellIndex.item]
                journalViewController.journal = selectedJournal
            default:
                fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? JournalCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of JournalCollectionViewCell.")
        }
        
        // Configure the cell
        cell.photo.image = journals[indexPath.item].photo
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
        //let cell: JournalCollectionViewCell? = self.collectionView(collectionView, cellForItemAt: indexPath as IndexPath) as? JournalCollectionViewCell
        //cell?.checkboxImageView.image = UIImage(named: "checked")
    }
    
    // Section Header View
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeaderView", for: indexPath) as! sectionHeaderView
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now as Date)
        sectionHeaderView.monthTitle = nameOfMonth
        
        return sectionHeaderView
        
    }
    
    //MARK: Actions
    
    @IBAction func unwindToJournalList(sender: UIStoryboardSegue){
        
            if let sourceViewController = sender.source as? JournalViewController, let journal = sourceViewController.journal {
                
                if let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first{
                    // Update an existing journal
                    journals[selectedIndexPath.item] = journal
                    collectionView?.reloadItems(at: [selectedIndexPath])
                } else {
                    // Add a new journal
                    let newIndexPath = IndexPath(item: journals.count, section: 0)
                    journals.append(journal)
                    collectionView?.insertItems(at: [newIndexPath])
                }
                saveJournals()
            }
        
    }
    
    //MARK: Private Methods
    
    private func saveJournals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(journals, toFile: Journal.ArchiveURL.path)
    
        if isSuccessfulSave {
            os_log("Journals succesfully saved.", log: OSLog.default, type: .debug)
        } else {
        os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadJournals() -> [Journal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Journal.ArchiveURL.path) as? [Journal]
    }
    
    @objc private func deleteSelectedItemsAction(sender: UIBarButtonItem) {
        print("Delete")
        let selectedIndexPaths: [NSIndexPath] = self.collectionView!.indexPathsForSelectedItems! as [NSIndexPath]
        
        var newJournalList: [Journal] = []
        
        for i in (0 ..< self.journals.count) {
            var found: Bool = false
            for indexPath in selectedIndexPaths {
                if indexPath.item == i {
                    found = true
                    break
                }
            }
            if found == false {
                newJournalList.append(self.journals[i])
            }
        }
        
        self.journals = newJournalList
        self.collectionView!.deleteItems(at: selectedIndexPaths as [IndexPath])
        self.saveJournals()
        //self.collectionView?.reloadData()
    }
}

extension JournalCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let journalWidth = 0.23 * screenSize.width
        let journalHeight = 0.23 * screenSize.height
        return CGSize(width: journalWidth, height: journalHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
