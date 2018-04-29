//
//  KeyboardKeys
//  journal
//
//  Created by Diqing Chang on 17.02.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import Foundation
import UIKit

struct Key {
    let name: String
    let image: UIImage
    
    init(name _filterName: String, coverImage _coverImage: UIImage) {
        name = _filterName
        image = _coverImage
    }
}

class KeyboardKeys {
    static let list:[Key] = [
        Key(name: "alignRight", coverImage: UIImage(named: "alignRight")!),
        Key(name: "alignLeft", coverImage: UIImage(named: "alignLeft")!),
        Key(name: "alignMiddle", coverImage: UIImage(named: "alignMiddle")!),
        Key(name: "underline", coverImage: UIImage(named: "underline")!),
        Key(name: "strikethrough", coverImage: UIImage(named: "strikethrough")!),
        Key(name: "italic", coverImage: UIImage(named: "italic")!),
        Key(name: "textBigger", coverImage: UIImage(named: "textBigger")!),
        Key(name: "textSmaller", coverImage: UIImage(named: "textSmaller")!)
        ]
    
    static let shareOptions:[Key] = [
        Key(name: "iosphoto", coverImage: UIImage(named: "iosPhoto")!),
        Key(name: "wechat", coverImage: UIImage(named: "wechat")!),
    ]
}
