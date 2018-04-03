//
//  sectionHeaderView.swift
//  journal
//
//  Created by 齐永乐 on 2018/4/3.
//  Copyright © 2018年 Diqing Chang. All rights reserved.
//

import UIKit

class sectionHeaderView : UICollectionReusableView
{

    @IBOutlet weak var monthLabel: UILabel!
    
    var monthTitle: String! {
        didSet{
            monthLabel.text = monthTitle
        }
    }
    
}
