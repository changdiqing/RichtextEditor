//
//  UIView+SafeAreaInsets.swift
//  journal
//
//  Created by 齐永乐 on 2018/6/1.
//  Copyright © 2018年 Diqing Chang. All rights reserved.
//

import UIKit

extension UIView {
    
    var sa_safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    
    var sa_safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        return bounds
    }
}
