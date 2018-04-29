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

class ShareKeyboard: UIView,UICollectionViewDataSource{
    
    let keyList = KeyboardKeys.shareOptions
    
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    weak var delegate: KeyboardDelegate?
    
    
    @IBOutlet weak var touchblockCollectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "TouchblockKeyboard" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        self.touchblockCollectionView.dataSource = self
        self.touchblockCollectionView.delegate = self
        self.touchblockCollectionView.register(UINib(nibName: "CustomKeyboardCell", bundle: nil), forCellWithReuseIdentifier: "CustomKeyboardCell")
    }
}

extension ShareKeyboard: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK:- UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyID = keyList[indexPath.item].name
        self.delegate?.cutomKeyTapped(keyId: keyID)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomKeyboardCell", for: indexPath) as! CustomKeyboardCell
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
