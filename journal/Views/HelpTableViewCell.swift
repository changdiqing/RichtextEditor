//
//  HelpTableViewCell.swift
//  journal
//
//  Created by Diqing Chang on 17.09.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {


    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
