//
//  UIImageView+Extensions.swift
//  image cropper
//
//  Created by Diqing Chang on 16.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//
import UIKit
extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        
        guard let imageSize = self.image?.size else {return CGRect.zero}
        
        let imageRatio = imageSize.width / imageSize.height
        
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            
            let scaleFactor = imageViewSize.height / imageSize.height
            
            let width = imageSize.width * scaleFactor
            
            let topLeftX = (imageViewSize.width - width) * 0.5
            
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
            
        } else {
            
            let scaleFactor = imageViewSize.width / imageSize.width
            
            let height = imageSize.height * scaleFactor
            
            let topLeftY = (imageViewSize.height - height) * 0.5
            
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
            
        }
    }
        
}
