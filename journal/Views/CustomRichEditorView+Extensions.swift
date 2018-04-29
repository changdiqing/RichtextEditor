import Foundation
import UIKit
import RichEditorView

extension CustomRichEditorView{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addToolbarOnKeyboard()
            }
        }
    }
    //MARK: new document methods added to RichEditorView

    public func getDocElementHtml()-> String {
        return runJS("getDocElementHtml();")
    }

    
    //MARK: Touchblock Methods
    
    public func cloneTouchblock() {
        runJS("method_cloneTouchblock();")
        self.initTouchblockCovers()
        self.enterLayoutMode()
    }

    public func setTouchblockFilter(_ filterType: String) {
        runJS("method_setTouchblockFilter('\(filterType)');")
    }
    
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
    
    public func initTouchblockCovers() {
        runJS("method_initTouchblockCovers();")
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
    
    func addToolbarOnKeyboard()
    {
        let buttonHeight = defaultParameters.UIToobarItemHeight
        let toolbarHeight = defaultParameters.UIToobarHeight
        let colorList = defaultColors.defaultColorList
        
        self.toolbarScroll = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolbarHeight))
        self.toolbarScroll!.showsHorizontalScrollIndicator = false
        self.toolbarScroll!.showsVerticalScrollIndicator = false
        self.toolbarScroll!.backgroundColor = .clear
        self.customToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolbarHeight))
        //let doneToolbar: UIToolbar = UIToolbar()
        self.customToolbar!.barStyle = .default
        self.toolbarScroll!.addSubview(self.customToolbar!)
        self.toolbarScroll!.contentSize.width = UIScreen.main.bounds.width
        
        //let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let iconUndo = UIImage(named: "undo")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconTypeSetting = UIImage(named: "typeSetting")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let icontoolbarInsertImage = UIImage(named: "toolbarInsertImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconleftImage = UIImage(named: "leftImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconrightImage = UIImage(named: "rightImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconcenterImage = UIImage(named: "centerImage")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconclear = UIImage(named: "clear")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconpallete = UIImage(named: "pallete")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let iconLayout = UIImage(named: "layouts")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        
        let alignRightImg = UIImage(named: "alignRight")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let alignLeftImg = UIImage(named: "alignLeft")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let alignMiddleImg = UIImage(named: "alignMiddle")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let underlineImg = UIImage(named: "underline")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let strikethroughImg = UIImage(named: "strikethrough")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let italicImg = UIImage(named: "italic")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let textBiggerImg = UIImage(named: "textBigger")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let textSmallerImg = UIImage(named: "textSmaller")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        let touchblockImg = UIImage(named: "touchblock")?.imageResize(sizeChange: CGSize(width: buttonHeight, height: buttonHeight))
        
        let undo: UIBarButtonItem = UIBarButtonItem(image: iconUndo, style: .done, target: self, action: #selector(self.undoAction))
        let typeSetting: UIBarButtonItem = UIBarButtonItem(image: iconTypeSetting, style: .done, target: self, action: #selector(self.showTypeSettingKeyboard))
        let testButton: UIBarButtonItem = UIBarButtonItem(title: "test", style: .plain, target: self, action: #selector(self.testButtonAction(sender:)))
        let insertImage: UIBarButtonItem = UIBarButtonItem(image: icontoolbarInsertImage, style: .done, target: self, action: #selector(self.insertImageAction))
        let floatLeftImage: UIBarButtonItem = UIBarButtonItem(image: iconleftImage, style: .done, target: self, action: #selector(self.floatLeftImage))
        let floatRightImage: UIBarButtonItem = UIBarButtonItem(image: iconrightImage, style: .done, target: self, action: #selector(self.floatRightImage))
        let centerImage: UIBarButtonItem = UIBarButtonItem(image: iconcenterImage, style: .done, target: self, action: #selector(self.centerImageAction))
        let clear: UIBarButtonItem = UIBarButtonItem(image: iconclear, style: .done, target: self, action: #selector(self.clear))
        let color: UIBarButtonItem = UIBarButtonItem(image: iconpallete?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(self.showColorKeyboard))
        let touchblock: UIBarButtonItem = UIBarButtonItem(image: touchblockImg?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(self.showTouchblockKeyboard))
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backButtonAction))
        let alignRight: UIBarButtonItem = UIBarButtonItem(image: alignRightImg, style: .done, target: self, action: #selector(self.alignRight))
        let alignLeft: UIBarButtonItem = UIBarButtonItem(image: alignLeftImg, style: .done, target: self, action: #selector(self.alignLeft))
        let alignMiddle: UIBarButtonItem = UIBarButtonItem(image: alignMiddleImg, style: .done, target: self, action: #selector(self.alignCenter))
        let underline: UIBarButtonItem = UIBarButtonItem(image: underlineImg, style: .done, target: self, action: #selector(self.underline))
        let strikethrough: UIBarButtonItem = UIBarButtonItem(image: strikethroughImg, style: .done, target: self, action: #selector(self.strikethrough))
        let italic: UIBarButtonItem = UIBarButtonItem(image: italicImg, style: .done, target: self, action: #selector(self.italic))
        let textBigger: UIBarButtonItem = UIBarButtonItem(image: textBiggerImg, style: .done, target: self, action: #selector(self.increaseTextSize))
        let textSmaller: UIBarButtonItem = UIBarButtonItem(image: textSmallerImg, style: .done, target: self, action: #selector(self.decreaseTextSize))
        let inlineTouchblock = UIBarButtonItem(image: touchblockImg, style: .done, target: self, action: #selector(insertInlineTouchblockAction))
        inlineTouchblock.tintColor = UIColor.darkestAlice()
        let floatingTouchblock = UIBarButtonItem(image: touchblockImg, style: .done, target: self, action: #selector(self.insertFloatTouchblockAction))
        floatingTouchblock.tintColor = UIColor.lighterRuby()
        
        self.colorMenu.append(backButton)
        for ele in colorList {
            let button = UIBarButtonItem(image: UIImage(named: "box"),style: .done, target: self, action: #selector(self.setColorAction(sender:)))
            button.tintColor = ele
            self.colorMenu.append(button)
        }
        
        self.mainMenu = [
            undo,
            typeSetting,
            touchblock,
            color,
            insertImage,
            floatLeftImage,
            floatRightImage,
            centerImage,
            clear,
            done]
        
        self.textEditingMenu = [
            backButton,
            alignLeft,
            alignRight,
            alignMiddle,
            underline,
            strikethrough,
            italic,
            textBigger,
            textSmaller]
        
        self.touchblockMenu = [
            backButton,
            inlineTouchblock,
            floatingTouchblock
        ]
        
        
        
        for item in self.mainMenu{
            item.tintColor = UIColor.ruby()
        }
        
        self.customToolbar!.items = self.mainMenu
        //doneToolbar.sizeToFit()
        self.toolbarScroll!.contentSize.width = self.customToolbar!.frame.width
        self.attachKeyboardToolbar()
    }
    
    //MARK: ToolbarItemActions
    
    func undoAction() {
        self.undo()
    }
    
    func testButtonAction(sender: UIBarButtonItem) {
        //self.setTextColor(UIColor.red.htmlRGBA)
        self.setTextColor((sender.tintColor?.htmlRGBA)!)
        self.endEditing(true)
    }
    
    func setColorAction(sender: UIBarButtonItem) {
        //self.setTextColor(UIColor.red.htmlRGBA)
        self.setTextColor((sender.tintColor?.htmlRGBA)!)
    }
    
    func backButtonAction() {
        let height = defaultParameters.UIToobarHeight
        let width = UIScreen.main.bounds.width
        
        self.customToolbar!.items = self.mainMenu
        self.toolbarScroll!.contentSize.width = width
        self.customToolbar?.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func attachKeyboardToolbar() {
        self.inputAccessoryView = self.toolbarScroll
    }
    
    func removeKeyboardToolbar() {
        self.inputAccessoryView = nil
    }
    
    func doneButtonAction()
    {
        self.resignFirstResponder()
        self.endEditing(true)
        print(self.html)
        self.delegate?.richEditorSaveHTML!()
    }
    
    func insertImageAction() {
        self.delegate?.richEditorInsertImage!()
    }
    
    func insertInlineTouchblockAction(sender: UIBarButtonItem) {
        let index = 0
        let selectedTouchblock = touchblockList[index]
        self.insertTouchblock(touchblock: selectedTouchblock)
    }
    
    func insertFloatTouchblockAction(sender: UIBarButtonItem) {
        let index = 1
        let selectedTouchblock = touchblockList[index]
        self.insertTouchblock(touchblock: selectedTouchblock)
    }
    
    func floatLeftImageAction() {
        self.floatLeftImage()
    }
    
    func floatRightImageAction() {
        self.floatRightImage()
    }
    
    func centerImageAction() {
        self.centerImage()
        print(self.html)
    }
    
    func clear() {
        self.removeFormat()
    }
    
    func showTypeSettingKeyboard() {
        // initiaate and attach TypesettingKeyboard custom keyboard. Diqing 09.04.2018
        self.customToolbar?.items = self.textEditingMenu
    }

    func showColorKeyboard() {
        let height = defaultParameters.UIToobarHeight
        let width = max (CGFloat(colorMenu.count) * height, UIScreen.main.bounds.width)
        
        self.customToolbar!.items = self.colorMenu
        self.toolbarScroll!.contentSize.width = width
        self.customToolbar?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
    }
    
    func showTouchblockKeyboard() {
        reloadToolbar(toolbarItems: self.touchblockMenu)
        
        /*
        let keyboardView = TouchblockKeyboard(frame: keyboardFrame)
        keyboardView.delegate = self
        self.attachTextView.inputView = keyboardView
        self.attachTextView.reloadInputViews()
        if !self.attachTextView.isFirstResponder {
            self.attachTextView.becomeFirstResponder()
        }*/
        
    }
    
    private func insertTouchblock(touchblock: htmlFile) {
        let fileName = touchblock.htmlFileName
        let isAppended = touchblock.append
        if let path = Bundle.main.path(forResource: fileName, ofType: "html") {
            do {
                let htmlStr = try String(contentsOfFile: path)
                if isAppended {
                    self.appendHTML(htmlStr)
                } else {
                    self.insertHTML(htmlStr)
                    //self.appendHTML(htmlStr)
                }
                self.initTouchblockCovers()
                self.enterContentMode()
            }
            catch {"error: file not found"}
        }
    }
    
    private func reloadToolbar(toolbarItems: [UIBarButtonItem]){
        let height = defaultParameters.UIToobarHeight
        let width = max (CGFloat(toolbarItems.count) * height, UIScreen.main.bounds.width)
        
        self.customToolbar!.items = toolbarItems
        self.toolbarScroll!.contentSize.width = width
        self.customToolbar?.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
}
