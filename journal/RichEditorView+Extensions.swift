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
        
        let alignRight: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "alignRight"), style: .done, target: self, action: #selector(self.alignRight))
        let alignLeft: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "alignLeft"), style: .done, target: self, action: #selector(self.alignLeft))
        let underline: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "underline"), style: .done, target: self, action: #selector(self.underline))
        let strikethrough: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "strikethrough"), style: .done, target: self, action: #selector(self.strikethrough))
        let italic: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "italic"), style: .done, target: self, action: #selector(self.italic))
        let color: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pallete")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(self.colorAction))
        
        let items = [underline, strikethrough,alignRight,alignLeft,italic,color,insertImage,enlargeImage,lessenImage,done]
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
        delegate?.richEditorInsertImage!(self)
    }
    
    func enlargeImageAction() {
        self.enlargeImage()
    }
    
    func lessenImageAction() {
        self.lessenImage()
    }
    
    
    
    /*
    func insertImageButtonAction()
    {
        let pickedImage = UIImage(named: "pallete")
        //let imageUrl = pickedImage.
        self.insertImage("https:////c2.staticflickr.com/6/5450/buddyicons/89692371@N00.jpg?1381089634#89692371@N00", alt: "Gravatar")
    }*/

    func colorAction() {
        let color = randomColor()
        self.setTextBackgroundColor(color)
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
