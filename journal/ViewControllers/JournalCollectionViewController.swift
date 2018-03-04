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
    fileprivate var journals = [Journal]()
    
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
        self.collectionView!.register(JournalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Load any saved journals
        if let savedJournals = loadJournals() {
            journals += savedJournals
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "addJournal":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "editJournal":
            guard let journalViewController = segue.destination as? JournalViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedJournalCell = sender as? JournalCollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = collectionView?.indexPath(for: selectedJournalCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedJournal = journals[indexPath.item]
            journalViewController.journal = selectedJournal
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? JournalCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of JournalCollectionViewCell.")
        }
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Fetches the appropriate journal for the data source layout
        let journal = journals[indexPath.item]
        cell.photo.image = journal.photo
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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
}
