//
//  UIColorExtensions.swift
//  journal
//
//  Created by Diqing Chang on 25.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0, 0, 0, 0)
    }
    
    // hue, saturation, brightness and alpha components from UIColor**
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (hue, saturation, brightness, alpha)
        }
        return (0,0,0,0)
    }
    
    var htmlRGB: String {
        return String(format: "#%02x%02x%02x", Int(rgba.red * 255), Int(rgba.green * 255), Int(rgba.blue * 255))
    }
    
    var htmlRGBA: String {
        return String(format: "#%02x%02x%02x%02x", Int(rgba.red * 255), Int(rgba.green * 255), Int(rgba.blue * 255), Int(rgba.alpha * 255) )
    }
    
    class func defaultUIColor() -> UIColor
    {
        return UIColor(red: 33/255.0, green: 93/255.0, blue: 255/255.0, alpha:1.0)
    }
    
    class func darkestIndigo() -> UIColor
    {
        return UIColor(red: 9/255.0, green: 49/255.0, blue: 69/255.0, alpha:1.0)
    }
    
    class func darkerIndigo() -> UIColor
    {
        return UIColor(red: 12/255.0, green: 55/255.0, blue: 77/255.0, alpha:1.0)
    }
    
    class func Indigo() -> UIColor
    {
        return UIColor(red: 13/255.0, green: 62/255.0, blue: 86/255.0, alpha:1.0)
    }
    
    class func lighterIndigo() -> UIColor
    {
        return UIColor(red: 60/255.0, green: 100/255.0, blue: 120/255.0, alpha:1.0)
    }
    
    class func darkestAlice() -> UIColor
    {
        return UIColor(red: 16/255.0, green: 120/255.0, blue: 150/255.0, alpha:1.0)
    }
    
    class func darkerAlice() -> UIColor
    {
        return UIColor(red: 18/255.0, green: 135/255.0, blue: 168/255.0, alpha:1.0)
    }
    
    class func alice() -> UIColor
    {
        return UIColor(red: 20/255.0, green: 150/255.0, blue: 187/255.0, alpha:1.0)
    }
    
    class func lighterAlice() -> UIColor
    {
        return UIColor(red: 67/255.0, green: 171/255.0, blue: 201/255.0, alpha:1.0)
    }
    
    class func darkestKelly() -> UIColor
    {
        return UIColor(red: 130/255.0, green: 147/255.0, blue: 86/255.0, alpha:1.0)
    }
    
    class func darkerKelly() -> UIColor
    {
        return UIColor(red: 147/255.0, green: 166/255.0, blue: 97/255.0, alpha:1.0)
    }
    
    class func kelly() -> UIColor
    {
        return UIColor(red: 163/255.0, green: 184/255.0, blue: 108/255.0, alpha:1.0)
    }
    
    class func lighterKelly() -> UIColor
    {
        return UIColor(red: 181/255.0, green: 198/255.0, blue: 137/255.0, alpha:1.0)
    }
    
    class func darkestDaisy() -> UIColor
    {
        return UIColor(red: 188/255.0, green: 161/255.0, blue: 54/255.0, alpha:1.0)
    }
    
    class func darkerDaisy() -> UIColor
    {
        return UIColor(red: 211/255.0, green: 181/255.0, blue: 61/255.0, alpha:1.0)
    }
    
    class func daisy() -> UIColor
    {
        return UIColor(red: 235/255.0, green: 201/255.0, blue: 68/255.0, alpha:1.0)
    }
    
    class func lighterDaisy() -> UIColor
    {
        return UIColor(red: 239/255.0, green: 212/255.0, blue: 105/255.0, alpha:1.0)
    }
    
    class func darkestCoral() -> UIColor
    {
        return UIColor(red: 194/255.0, green: 87/255.0, blue: 26/255.0, alpha:1.0)
    }
    
    class func darkerCoral() -> UIColor
    {
        return UIColor(red: 218/255.0, green: 98/255.0, blue: 30/255.0, alpha:1.0)
    }
    
    class func coral() -> UIColor
    {
        return UIColor(red: 242/255.0, green: 109/255.0, blue: 33/255.0, alpha:1.0)
    }
    
    class func lighterCoral() -> UIColor
    {
        return UIColor(red: 245/255.0, green: 139/255.0, blue: 76/255.0, alpha:1.0)
    }
    
    class func darkestRuby() -> UIColor
    {
        return UIColor(red: 154/255.0, green: 38/255.0, blue: 23/255.0, alpha:1.0)
    }
    
    class func darkerRuby() -> UIColor
    {
        return UIColor(red: 173/255.0, green: 42/255.0, blue: 26/255.0, alpha:1.0)
    }
    
    class func ruby() -> UIColor
    {
        return UIColor(red: 192/255.0, green: 47/255.0, blue: 29/255.0, alpha:1.0)
    }
    
    class func lighterRuby() -> UIColor
    {
        return UIColor(red: 205/255.0, green: 89/255.0, blue: 74/255.0, alpha:1.0)
    }
    
    class func themeColor() -> UIColor {
      return UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
    }
}
