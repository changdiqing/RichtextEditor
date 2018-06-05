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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Values to be passed to other classes
    var selectedLayout: htmlFile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Flowlayout insets
        self.flowLayout.minimumLineSpacing = 10
        self.flowLayout.minimumInteritemSpacing = 5
        //self.flowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        self.flowLayout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
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
        cell.templateImage?.image = templateList[indexPath.row].image
        return cell
    }
    

    
   
    
}

extension TemplateCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = collectionView.sa_safeAreaFrame.width
        if itemSize > collectionView.sa_safeAreaFrame.height {
            itemSize = collectionView.sa_safeAreaFrame.height
        }
        let itemWidth = itemSize / 2.3
        let itemHeight = itemSize / 2.3
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

