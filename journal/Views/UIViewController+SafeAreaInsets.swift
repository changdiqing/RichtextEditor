//
//  UIViewController+SafeAreaInsets.swift
//  journal
//
//  Created by 齐永乐 on 2018/6/1.
//  Copyright © 2018年 Diqing Chang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var sa_safeAreaInsets: UIEdgeInsets {
        // New safe area properties only available in iOS 11
        if #available(iOS 11, *) {
            return view.safeAreaInsets
        }
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0.0, bottom: bottomLayoutGuide.length, right: 0.0)
    }
    
    var sa_safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return view.safeAreaLayoutGuide.layoutFrame
        }
        return UIEdgeInsetsInsetRect(view.bounds, sa_safeAreaInsets)
    }
}
