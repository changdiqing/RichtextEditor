//
//  JournalCollectionViewCell.swift
//  journal
//
//  Created by Diqing Chang on 03.03.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

class JournalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    private let checkedIcon = UIImage(named: "checked")
    private let uncheckedIcon = UIImage(named: "unchecked")
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected == true {
                self.checkboxImageView.image = checkedIcon
            }
            else {
                self.checkboxImageView.image = uncheckedIcon
            }
        }
    }
    
    
 
   
}
