//
//  CustomCollectionViewCell.swift
//  journal
//
//  Created by Diqing Chang on 17.02.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

class colorCardTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    
    func displayContent(type: String, selectedColor: UIColor?){
        if let color = selectedColor {
            self.backgroundColor = color
        } else {
            self.typeLabel.text = type
        }
    }
    
}

