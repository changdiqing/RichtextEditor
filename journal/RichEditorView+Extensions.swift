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
        let toolbarScroll = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbarScroll.showsHorizontalScrollIndicator = false
        toolbarScroll.showsVerticalScrollIndicator = false
        toolbarScroll.backgroundColor = .clear
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width*1.5, height: 50))
        //let doneToolbar: UIToolbar = UIToolbar()
        doneToolbar.barStyle = .default
        toolbarScroll.addSubview(doneToolbar)
        toolbarScroll.contentSize.width = UIScreen.main.bounds.width
        
        //let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let insertImage: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "toolbarInsertImage"), style: .done, target: self, action: #selector(self.insertImageAction))
        let enlargeImage: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "enlarge"), style: .done, target: self, action: #selector(self.enlargeImageAction))
        let lessenImage: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "lessen"), style: .done, target: self, action: #selector(self.lessenImageAction))
        let floatLeftImage: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftImage"), style: .done, target: self, action: #selector(self.floatLeftImage))
        let floatRightImage: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "rightImage"), style: .done, target: self, action: #selector(self.floatRightImage))
        let centerImage: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "centerImage"), style: .done, target: self, action: #selector(self.centerImageAction))
        let clear: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "clear"), style: .done, target: self, action: #selector(self.clear))
        let alignRight: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "alignRight"), style: .done, target: self, action: #selector(self.alignRight))
        let alignLeft: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "alignLeft"), style: .done, target: self, action: #selector(self.alignLeft))
        let alignCenter: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "alignMiddle"), style: .done, target: self, action: #selector(self.alignCenter))
        let underline: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "underline"), style: .done, target: self, action: #selector(self.underline))
        let strikethrough: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "strikethrough"), style: .done, target: self, action: #selector(self.strikethrough))
        let italic: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "italic"), style: .done, target: self, action: #selector(self.italic))
        let color: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pallete")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(self.colorAction))
        
        let items = [clear,
                     underline,
                     strikethrough,
                     alignRight,
                     alignCenter,
                     alignLeft,
                     italic,
                     color,
                     insertImage,
                     floatLeftImage,
                     floatRightImage,
                     centerImage,
                     enlargeImage,
                     lessenImage,
                     done]
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
    }
    
    func insertImageAction() {
        delegate?.richEditorInsertImage!()
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
    
    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
}
