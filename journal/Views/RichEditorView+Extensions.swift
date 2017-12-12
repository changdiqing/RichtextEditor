import Foundation
import UIKit
import RichEditorView

extension RichEditorView{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let buttonHeight = defaultParameters.UIToobarItemHeight
        let toolbarHeight = defaultParameters.UIToobarHeight
        let toolbarScroll = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolbarHeight))
        toolbarScroll.showsHorizontalScrollIndicator = false
        toolbarScroll.showsVerticalScrollIndicator = false
        toolbarScroll.backgroundColor = .clear
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width*1.5, height: toolbarHeight))
        //let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.barStyle = .default
        toolbarScroll.addSubview(doneToolbar)
        toolbarScroll.contentSize.width = UIScreen.main.bounds.width
        
        //let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let icontoolbarInsertImage = UIImage(named: "toolbarInsertImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconenlarge = UIImage(named: "enlarge")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconlessen = UIImage(named: "lessen")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconleftImage = UIImage(named: "leftImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconrightImage = UIImage(named: "rightImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconcenterImage = UIImage(named: "centerImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconclear = UIImage(named: "clear")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconalignRight = UIImage(named: "alignRight")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconalignLeft = UIImage(named: "alignLeft")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconalignMiddle = UIImage(named: "alignMiddle")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconUnderline = UIImage(named: "underline")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconstrikethrough = UIImage(named: "strikethrough")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconitalic = UIImage(named: "italic")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconpallete = UIImage(named: "pallete")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        
        
        let insertImage: UIBarButtonItem = UIBarButtonItem(image: icontoolbarInsertImage, style: .done, target: self, action: #selector(self.insertImageAction))
        let enlargeImage: UIBarButtonItem = UIBarButtonItem(image: iconenlarge, style: .done, target: self, action: #selector(self.enlargeImageAction))
        let lessenImage: UIBarButtonItem = UIBarButtonItem(image: iconlessen, style: .done, target: self, action: #selector(self.lessenImageAction))
        let floatLeftImage: UIBarButtonItem = UIBarButtonItem(image: iconleftImage, style: .done, target: self, action: #selector(self.floatLeftImage))
        let floatRightImage: UIBarButtonItem = UIBarButtonItem(image: iconrightImage, style: .done, target: self, action: #selector(self.floatRightImage))
        let centerImage: UIBarButtonItem = UIBarButtonItem(image: iconcenterImage, style: .done, target: self, action: #selector(self.centerImageAction))
        let clear: UIBarButtonItem = UIBarButtonItem(image: iconclear, style: .done, target: self, action: #selector(self.clear))
        let alignRight: UIBarButtonItem = UIBarButtonItem(image: iconalignRight, style: .done, target: self, action: #selector(self.alignRight))
        let alignLeft: UIBarButtonItem = UIBarButtonItem(image: iconalignLeft, style: .done, target: self, action: #selector(self.alignLeft))
        let alignCenter: UIBarButtonItem = UIBarButtonItem(image: iconalignMiddle, style: .done, target: self, action: #selector(self.alignCenter))
        let underline: UIBarButtonItem = UIBarButtonItem(image: iconUnderline, style: .done, target: self, action: #selector(self.underline))
        let strikethrough: UIBarButtonItem = UIBarButtonItem(image: iconstrikethrough, style: .done, target: self, action: #selector(self.strikethrough))
        let italic: UIBarButtonItem = UIBarButtonItem(image: iconitalic, style: .done, target: self, action: #selector(self.italic))
        let color: UIBarButtonItem = UIBarButtonItem(image: iconpallete?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(self.colorAction))
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [clear,
                     underline,
                     strikethrough,
                     italic,
                     alignRight,
                     alignCenter,
                     alignLeft,
                     color,
                     insertImage,
                     floatLeftImage,
                     floatRightImage,
                     centerImage,
                     enlargeImage,
                     lessenImage,
                     done]
        for item in items {
            item.tintColor = UIColor.ruby()
        }
        
        doneToolbar.items = items
        //doneToolbar.sizeToFit()
        toolbarScroll.contentSize.width = doneToolbar.frame.width
        
        self.inputAccessoryView = toolbarScroll
    }
    
    //MARK: ToolbarItemActions
    
    func doneButtonAction()
    {
        self.resignFirstResponder()
        self.endEditing(true)
        self.delegate?.richEditorSaveHTML!()
        print(self.html)
    }
    
    func insertImageAction() {
        self.delegate?.richEditorInsertImage!()
    }
    
    func enlargeImageAction() {
        self.enlargeImage()
        print(self.html)
    }
    
    func lessenImageAction() {
        self.lessenImage()
        print(self.html)
    }
    
    func floatLeftImageAction() {
        self.floatLeftImage()
        print(self.html)
    }
    
    func floatRightImageAction() {
        self.floatRightImage()
        print(self.html)
    }
    
    func centerImageAction() {
        self.centerImage()
        print(self.html)
    }
    
    func clear() {
        self.removeFormat()
    }

    func colorAction() {
        delegate?.richEditorChangeColor!()
    }
}
