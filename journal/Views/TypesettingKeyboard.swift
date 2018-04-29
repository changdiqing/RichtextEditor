//
//  TypesettingKeyboard.swift
//  journal
//
//  Created by Diqing Chang on 13.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import Foundation
//
//  KeyBoard.swift
//  Custom Keyboard
//
//  Created by Diqing Chang on 08.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method

class TypesettingKeyboard: UIView,UICollectionViewDataSource{
    
    
    let keyList = KeyboardKeys.list
    
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    weak var delegate: KeyboardDelegate?
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "TypesettingKeyboard" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
        self.myCollectionView.register(UINib(nibName: "TypeSettingKeyboardCell", bundle: nil), forCellWithReuseIdentifier: "TypeSettingKeyboardCell")
    }
}

extension TypesettingKeyboard: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK:- UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.delegate?.typesettingKeyTapped(keyIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeSettingKeyboardCell", for: indexPath) as! TypeSettingKeyboardCell
        cell.image?.image = keyList[indexPath.row].image
        
        return cell
    }
    
    //MARK:- UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50);
    }
}


