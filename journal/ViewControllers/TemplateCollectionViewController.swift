//
//  TemplateLayoutCollectionViewController.swift
//  journal
//
//  Created by 齐永乐 on 2018/4/6.
//  Copyright © 2018年 Diqing Chang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TemplateCollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    fileprivate let reuseIdentifier = "templateLayoutCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let templateList = Templates.templateList
    fileprivate let itemsPerRow: CGFloat = 3
    
    // Values to be passed to other classes
    var selectedLayout: TemplateItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "createJournal":
            let destinationNavigationController = segue.destination as! UINavigationController
            guard let targetController = destinationNavigationController.topViewController as? JournalViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let cellIndex = self.collectionView?.indexPathsForSelectedItems?.first! else {
                fatalError("No cell selected")
            }
            let selectedtemplate = templateList[cellIndex.item]
            targetController.indexFile = selectedtemplate.htmlFileName
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    //MARK: UICollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(templateLayoutList.count)
        return templateList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TemplateLayoutCollectionViewCell
        cell.templateImage?.image = templateList[indexPath.row].templateImage
        return cell
    }
    

    
   
    
}

extension TemplateCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 100, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
