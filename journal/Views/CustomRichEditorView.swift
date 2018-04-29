//
//  CustomRichEditorView.swift
//  journal
//
//  Created by Diqing Chang on 14.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//
import RichEditorView
class CustomRichEditorView: RichEditorView {
    
    //var colorKeyboard: ColorKeyboard?
    //let theHeight = self.frame.size.height
    
    //MARK: Public Properties added by Diqing Chang, 02.02.2018
    public var toolbarScroll: UIScrollView?
    public var customToolbar: UIToolbar?
    public var attachTextView: UITextView!
    public var mainMenu = [UIBarButtonItem]()
    public var textEditingMenu = [UIBarButtonItem]()
    public var colorMenu = [UIBarButtonItem]()
    public var touchblockMenu = [UIBarButtonItem]()
    public var keyboardFrame = CGRect(x: 0, y: 0, width: 300, height: 271)
    
    let touchblockList = Touchblocks.list
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        // Used to initialize color keyboard, Problem: original keyboard of  uiwebview can neither be replaced nor hidden. So this subview as custom keyboard can not be displayed. Current solution: inputAccessaryView
        /*        colorKeyboard = ColorKeyboard(frame: keyboardFrame)
        self.addSubview(colorKeyboard!) // you can omit 'self' here
        colorKeyboard?.delegate = self as KeyboardDelegate
        colorKeyboard?.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: colorKeyboard!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:271)
        colorKeyboard?.addConstraint(height)
        let bottom:NSLayoutConstraint = NSLayoutConstraint(item: colorKeyboard!, attribute: .bottom, relatedBy:.equal, toItem: self, attribute:NSLayoutAttribute.bottom, multiplier:1.0, constant: 0)
        let right:NSLayoutConstraint = NSLayoutConstraint(item: colorKeyboard!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier:1.0, constant: 0)
        let left:NSLayoutConstraint = NSLayoutConstraint(item: colorKeyboard!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier:1.0, constant: 0)
        
        self.addConstraint(left)
        self.addConstraint(right)
        self.addConstraint(bottom)*/
        
        // puppetTextView added by Diqing Chang, 09.04.2018
        attachTextView = UITextView(frame: CGRect.zero)
        attachTextView.alpha = 0.0
        self.addSubview(attachTextView)
        
        // Oberserver added by Diqing Chang at 10.04.2018
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    // observer function added by Diqing at 10.04.2018
    func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let currentKeyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //= currentKeyboardFrame.height - 50
        keyboardFrame.size.height = currentKeyboardFrame.height - 50
    }
}
