//
//  KeyBoard.swift
//  Custom Keyboard
//
//  Created by Diqing Chang on 08.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

class ColorKeyboard: UIView,UICollectionViewDataSource{
    
    fileprivate let colorList = defaultColors.defaultColorList
    
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    weak var delegate: KeyboardDelegate?
    
    @IBOutlet weak var colorKeyboardCollectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "Keyboard" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        self.colorKeyboardCollectionView.dataSource = self
        self.colorKeyboardCollectionView.delegate = self
        self.colorKeyboardCollectionView.register(UINib(nibName: "ColorKeyboardCell", bundle: nil), forCellWithReuseIdentifier: "colorKeyboardCell")
    }
}

extension ColorKeyboard: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK:- UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor: UIColor = colorList[indexPath.item]
        //delegate?.keyWasTapped(color: selectedColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorKeyboardCell", for: indexPath) as! ColorKeyboardCell
        
        let color = colorList[indexPath.row]
        
        cell.backgroundColor = color
        
        return cell
    }
    
    
    //MARK:- UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50);
    }
}
