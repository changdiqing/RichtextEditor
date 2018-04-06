//
//  TemplateLayoutCollectionViewController.swift
//  journal
//
//  Created by 齐永乐 on 2018/4/6.
//  Copyright © 2018年 Diqing Chang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TemplateLayoutCollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    fileprivate let reuseIdentifier = "templateLayoutCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let templateLayoutList = TemplateLayout.templateLayoutList
    fileprivate let itemsPerRow: CGFloat = 3
    
    // Values to be passed to other classes
    var selectedLayout: TemplateLayoutItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Hallo, selected Layout")
        if self.isEditing == false {
            guard let selectedIndexPath = self.collectionView?.indexPathsForSelectedItems?.first else {
                fatalError("Cell must be selected!")
            }
            //print(selectedIndexPath.row)
            selectedLayout = templateLayoutList[selectedIndexPath.row]
        }
    }
    
    //MARK: UICollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(templateLayoutList.count)
        return templateLayoutList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TemplateLayoutCollectionViewCell
        cell.templateImage?.image = templateLayoutList[indexPath.row].templateImage
        return cell
    }
    

    
   
    
}

extension TemplateLayoutCollectionViewController : UICollectionViewDelegateFlowLayout {
    
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
