//
//  ViewController.swift
//  journal
//
//  Created by Diqing Chang on 01.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import RichEditorView
import JavaScriptCore

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var editorView: RichEditorView!
    var journal: Journal?
    var isLayoutMode: Bool = false
    var testDate:Date {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            return formatter.date(from: "2016/10/08 22:31")!
        }
    }
    
    
    
    // Here instantiate a toolbar instance, loaded only when accessed
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0,width: self.view.bounds.width, height: 44))
        toolbar.editor = self.editorView
        //toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        editorView.delegate = self
    
        if let fetchedDiary = CoreDataHandler.fetchDiaryByDate(testDate)?.first{
            self.journal = fetchedDiary
            editorView.html = fetchedDiary.html!
        } else {
            self.journal = nil
        }
        
        // for testing, always load the same demo
        let path = Bundle.main.path(forResource: "htmlLayout1", ofType: "html")
        let htmlStr: String = try! String(contentsOfFile: path!)
        print("htmlStr is \(htmlStr)")
        self.editorView.html = htmlStr
        
        let jsContext = self.editorView.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(/*JavaScriptFunc()*/self, forKeyedSubscript: "javaScriptCallToSwift" as (NSCopying & NSObjectProtocol)!)
        
        //self.editorView.html = self.journal?.html ??
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("finger is not touching.")
        if touches.first != nil {
            print("finger is not touching.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        let imageName = "\(dateFormatter.string(from: Date())).png"
        let filepath = ImageHandler.getDocumentsDirectory().appendingPathComponent(imageName)
        let data = UIImagePNGRepresentation(selectedImage)
        
        do
        {
            try data?.write(to: filepath, options: Data.WritingOptions.atomic)
            let myUrl = filepath.absoluteString
            if isLayoutMode {
                editorView.setBackgroundImage(myUrl, alt: myUrl)
            } else {
                editorView.insertImage(myUrl, alt: myUrl)
            }
        }
        catch
        {
            print("failed to save image")
            // Catch exception here and act accordingly
        }
        
        // Set photoImageView to display the selected image.
        //photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
    
    //Mark: Navigation
    
    @IBAction func unwindToRichtextEditor(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ColorCardTableViewController {

            let selectedColor = sourceViewController.selectedColor
            
            self.editorView.restoreSelectionRange()
            self.editorView.setTextColor(selectedColor.htmlRGBA)
            
            //save new event
            // here code for saving the LTP.
            // 首先我得知道如何编辑event，需要删除旧的event添加新的event还是可以直接编辑已有的event呢？
        }
    }
}

extension ViewController: JavaScriptFuncProtocol {
    func test() {
        isLayoutMode = true
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func test2(_ value: String, _ num: Int) {
        print("value: \(value), num: \(num)")
    }
}


extension ViewController: RichEditorDelegate {
    func richEditorInsertImage() {
        isLayoutMode = false
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func richEditorChangeColor() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let colorCardViewController = storyBoard.instantiateViewController(withIdentifier: "colorCardViewController") as! ColorCardTableViewController
        self.present(colorCardViewController, animated:true, completion:nil)
    }
    
    func richEditorSaveHTML() {
        if self.editorView.html.isEmpty {  // if no content then delete journal
            print("is empty!")
            CoreDataHandler.deleteDiary(self.journal)
        } else {  // if there is content then save to core data
            print("prepare to save!")
            if self.journal != nil {
                self.journal?.html = self.editorView.html
                print("existing journal saved!")
            } else {
                self.journal = CoreDataHandler.createNewDiary(testDate)
                self.journal?.html = self.editorView.html
                print("new journal created!")
            }
            CoreDataHandler.saveDiary()
        }
    }
}
