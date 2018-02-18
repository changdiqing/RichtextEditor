//
//  CustomCollectionViewCell.swift
//  journal
//
//  Created by Diqing Chang on 17.02.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterIcon: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    
    func displayContent(image: UIImage, title: String){
        filterIcon.image = image
        filterLabel.text = title
    }
    
}
