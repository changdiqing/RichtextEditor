//
//  ViewController.swift
//  journal
//
//  Created by Diqing Chang on 01.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import RichEditorView

class ViewController: UIViewController {
    
    @IBOutlet var editorView: RichEditorView!
    
    // Here instantiate a toolbar instance, loaded only when accessed
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0,width: self.view.bounds.width, height: 44))
        toolbar.editor = self.editorView
        //toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView.delegate = self
        //editorView.inputAccessoryView = toolbar
        
        toolbar.delegate = self
        toolbar.editor = editorView
        
        loadToolbarItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Private Methods
    func loadToolbarItems() {
        
        let Clear = RichEditorOptionItem(image: nil, title: "Clear") {
            toolbar in
            toolbar.editor?.html = ""
        }
        
        
        let InserImage = RichEditorOptionItem(image: UIImage(named: "toolbarInsertImage"), title: "Insert Image") {
            toolbar in
            toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
        }
        
        let tailItem = RichEditorOptionItem(image: nil, title: ""){
            toolbar in
            print("placeholder clicked, nothing will happen")
        }
        
        
        //&print(InserImage.image?.alignmentRectInsets)
        
        toolbar.options = RichEditorDefaultOption.all
        var options = toolbar.options
        options.append(InserImage)
        options.append(Clear)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        options.append(tailItem)
        toolbar.options = options
        
    }


}

extension ViewController: RichEditorDelegate {
    
}

extension ViewController: RichEditorToolbarDelegate {
    
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
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
    
    
}
