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
    //MARK: new Methods added to RichEditorView
    public func setTouchBlockBackgroundColor(_ colorInHex: String) {
        runJS("method_changeStartBackgroundColor('\(colorInHex)');")
    }
    
    public func setTouchBlockBackgroundImage(_ url: String, alt: String) {
        runJS("method_changeStartBackgroundImage('\(url)', '\(alt)');")
    }
    
    public func increaseTextSize() {
        runJS("RE.prepareInsert();")
        runJS("RE.increaseTextSize();")
    }
    
    public func decreaseTextSize() {
        
        runJS("RE.prepareInsert();")
        runJS("RE.decreaseTextSize();")
    }
    
    public func enterLayoutMode() {
        runJS("method_enterLayoutMode();")
    }
    
    public func enterContentMode() {
        runJS("method_enterContentMode();")
    }
    
    public func setTouchblockTextOrientationVertical() {
        runJS("mehtod_setStartTextOrientationVertical();")
    }
    
    public func setTouchblockTextOrientationHorizon() {
        runJS("mehtod_setStartTextOrientationHorizon();")
    }
    
    public func removeClickedTouchblock() {
        runJS("mehtod_removeStart();")
    }
    
    
    //MARK: create a toolbar and add to RichEditorView
    
    func addDoneButtonOnKeyboard()
    {
        let buttonHeight = defaultParameters.UIToobarItemHeight
        let toolbarHeight = defaultParameters.UIToobarHeight
        
        self.toolbarScroll = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolbarHeight))
        self.toolbarScroll!.showsHorizontalScrollIndicator = false
        self.toolbarScroll!.showsVerticalScrollIndicator = false
        self.toolbarScroll!.backgroundColor = .clear
        self.doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width*1.6, height: toolbarHeight))
        //let doneToolbar: UIToolbar = UIToolbar()
        self.doneToolbar!.barStyle = .default
        self.toolbarScroll!.addSubview(self.doneToolbar!)
        self.toolbarScroll!.contentSize.width = UIScreen.main.bounds.width
        
        //let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let iconLayoutMode = UIImage(named: "layoutMode")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconEditMode = UIImage(named: "editMode")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let icontoolbarInsertImage = UIImage(named: "toolbarInsertImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        /*let iconenlarge = UIImage(named: "enlarge")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconlessen = UIImage(named: "lessen")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))*/
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
        let iconTextBigger = UIImage(named: "textBigger")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconTextSmaller = UIImage(named: "textSmaller")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconpallete = UIImage(named: "pallete")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconLayout = UIImage(named: "layouts")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        
        let enterLayoutMode: UIBarButtonItem = UIBarButtonItem(image: iconLayoutMode, style: .done, target: self, action: #selector(self.enterLayoutModeAction))
        let enterEditMode: UIBarButtonItem = UIBarButtonItem(image: iconEditMode, style: .done, target: self, action: #selector(self.enterEditModeAction))
        let insertImage: UIBarButtonItem = UIBarButtonItem(image: icontoolbarInsertImage, style: .done, target: self, action: #selector(self.insertImageAction))
        /*let enlargeImage: UIBarButtonItem = UIBarButtonItem(image: iconenlarge, style: .done, target: self, action: #selector(self.enlargeImageAction))
        let lessenImage: UIBarButtonItem = UIBarButtonItem(image: iconlessen, style: .done, target: self, action: #selector(self.lessenImageAction))*/
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
        let textBigger: UIBarButtonItem = UIBarButtonItem(image: iconTextBigger, style: .done, target: self, action: #selector(self.increaseTextSize))
        let textSmaller: UIBarButtonItem = UIBarButtonItem(image: iconTextSmaller, style: .done, target: self, action: #selector(self.decreaseTextSize))
        let color: UIBarButtonItem = UIBarButtonItem(image: iconpallete?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(self.colorAction))
        let layouts: UIBarButtonItem = UIBarButtonItem(image: iconLayout?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(self.insertLayoutAction))
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        self.itemsForEditMode = [
            enterLayoutMode,
            clear,
            underline,
            strikethrough,
            italic,
            alignRight,
            alignCenter,
            alignLeft,
            textBigger,
            textSmaller,
            layouts,
            color,
            insertImage,
            floatLeftImage,
            floatRightImage,
            centerImage,
            //enlargeImage, // new method use drag to resize image, no need for button
            //lessenImage,  // new method use drag to resize image, no need for button
            done]
        self.itemsForLayoutMode = [
            enterEditMode]
        
        for item in itemsForEditMode {
            item.tintColor = UIColor.ruby()
        }
        
        for item in itemsForLayoutMode {
            item.tintColor = UIColor.ruby()
        }
        
        self.doneToolbar!.items = itemsForEditMode
        //doneToolbar.sizeToFit()
        self.toolbarScroll!.contentSize.width = self.doneToolbar!.frame.width
        
        self.inputAccessoryView = self.toolbarScroll
    }
    
    //MARK: ToolbarItemActions
    
    func enterLayoutModeAction() {
        self.enterLayoutMode()
        self.doneToolbar!.items=self.itemsForLayoutMode
        
    }
    
    func enterEditModeAction() {
        self.enterContentMode()
        self.doneToolbar!.items=self.itemsForEditMode
    }
    
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
    
    func insertLayoutAction() {
        self.delegate?.richEditorInsertlayout!()
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
