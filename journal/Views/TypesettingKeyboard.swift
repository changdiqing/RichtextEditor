//
//  TypesettingKeyboard.swift
//  journal
//
//  Created by Diqing Chang on 13.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import Foundation
//
//  KeyBoard.swift
//  Custom Keyboard
//
//  Created by Diqing Chang on 08.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method

class TypesettingKeyboard: UIView{

    let keyList = DivMokupSets.divFontsList
    
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    weak var delegate: KeyboardDelegate?
    
    @IBOutlet weak var fontsTableView: UITableView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "TypesettingKeyboard" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        self.fontsTableView.dataSource = self
        self.fontsTableView.delegate = self
        self.fontsTableView.register(UINib(nibName: "TypeSettingKeyboardCell", bundle: nil), forCellReuseIdentifier: "TypeSettingKeyboardCell")
    }
}

extension TypesettingKeyboard: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeSettingKeyboardCell", for: indexPath) as! TypeSettingKeyboardCell
        let fontName = keyList[indexPath.row].name
        cell.textLabel?.text = fontName
        cell.textLabel?.font = UIFont(name: fontName, size: 20.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyID = keyList[indexPath.row].name
        self.delegate?.cutomKeyTapped(keyId: keyID)
    }
    
}


