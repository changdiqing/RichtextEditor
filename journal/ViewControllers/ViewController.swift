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
    var chooseLayout: Bool = false
    var touchBlockClicked: Bool = false
    var testDate:Date {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            return formatter.date(from: "2016/10/08 22:31")!
        }
    }
    
    
    /*
    // Here instantiate a toolbar instance, loaded only when accessed
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0,width: self.view.bounds.width, height: 44))
        toolbar.editor = self.editorView
        //toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        editorView.delegate = self
        
        //editorView.becomeFirstResponder()
        
        

        let jsContext = self.editorView.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(/*JavaScriptFunc()*/self, forKeyedSubscript: "javaScriptCallToSwift" as (NSCopying & NSObjectProtocol)!)
        
        /*  for fethcing save journals, will be used afterwards, Diqing Chang on 21.01.2018
         if let fetchedDiary = CoreDataHandler.fetchDiaryByDate(testDate)?.first{
         self.journal = fetchedDiary
         //editorView.html = fetchedDiary.html!
         } else {
         self.journal = nil
         }*/
        
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html"){
            let url = URL(fileURLWithPath: filePath, isDirectory: false)
            let request = URLRequest(url: url)
            editorView.webView.loadRequest(request)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if chooseLayout {presentJournalLayouts()}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        //self.editorView.becomeFirstResponder()
        touchBlockClicked = false
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
            if !touchBlockClicked {
                editorView.insertImage(myUrl, alt: myUrl)
            } else {
                touchBlockClicked = false
                editorView.setTouchBlockBackgroundImage(myUrl, alt: myUrl)
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
    
    func presentJournalLayouts() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let journalLayoutsViewController = storyBoard.instantiateViewController(withIdentifier: "JournalLayoutsViewController") as! JournalLayoutCollectionViewController
        self.present(journalLayoutsViewController, animated:true, completion:nil)
    }
    
    @IBAction func unwindToRichtextEditor(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ColorCardTableViewController {
            if let selectedColor = sourceViewController.selectedColor{
                print(selectedColor)
                if touchBlockClicked {
                    touchBlockClicked = false
                    self.editorView.setTouchBlockBackgroundColor(selectedColor.htmlRGBA)
                }else {
                    self.editorView.restoreSelectionRange()
                    self.editorView.setTextColor(selectedColor.htmlRGBA)
                }
            } else if sender.identifier == "textHorizon"{
                self.editorView.setTouchblockTextOrientationHorizon()
            } else if sender.identifier == "clone"{
                self.editorView.cloneTouchblock()
            } else if sender.identifier == "textVertical"{
                self.editorView.setTouchblockTextOrientationVertical()
            } else if sender.identifier == "delete"{
                self.editorView.removeClickedTouchblock()
            } else if sender.identifier == "setFilter"{
                if let selectedFilter = sourceViewController.selectedFilter{
                    self.editorView.setTouchblockFilter(selectedFilter.jsCommand)
                }
            } else {
                let imagePickerController = UIImagePickerController()
                
                // Only allow photos to be picked, not taken.
                imagePickerController.sourceType = .photoLibrary
                
                // Make sure ViewController is notified when the user picks an image.
                imagePickerController.delegate = self
                DispatchQueue.main.async {
                    self.present(imagePickerController, animated: true, completion: nil)
                }
            }
            
        } else if let sourceViewController = sender.source as? JournalLayoutCollectionViewController {
            chooseLayout = false
            if let layout = sourceViewController.selectedLayout {
                insertHTML(filename: layout.htmlFileName, isAppended: layout.append)
            }
            
            
        }
    }
    
    //MARK: Private Methods
    func insertHTML(filename: String, isAppended: Bool) {
        if let path = Bundle.main.path(forResource: filename, ofType: "html") {
            do {
                let htmlStr = try String(contentsOfFile: path)
                if isAppended {
                    self.editorView.appendHTML(htmlStr)
                } else {
                    self.editorView.insertHTML(htmlStr)
                }
                self.editorView.initTouchblockCovers()
                self.editorView.enterContentMode()
            }
            catch {"error: file not found"}
        }
    }
    
    func appendHTML(from filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: "html") {
            do {
                let htmlStr = try String(contentsOfFile: path)
                self.editorView.appendHTML(htmlStr)
                self.editorView.enterContentMode()
            }
            catch {"error: file not found"}
        }
    }
}

extension ViewController: JavaScriptFuncProtocol {
    func test() {
        
        touchBlockClicked = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let colorCardViewController = storyBoard.instantiateViewController(withIdentifier: "colorCardViewController") as! ColorCardTableViewController
        colorCardViewController.buttonHeight = colorCardViewController.defaultButtonHeight
        self.present(colorCardViewController, animated:true, completion:nil)
//        let imagePickerController = UIImagePickerController()
//
//        // Only allow photos to be picked, not taken.
//        imagePickerController.sourceType = .photoLibrary
//
//        // Make sure ViewController is notified when the user picks an image.
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
    }
    
    func test2(_ value: String, _ num: Int) {
        print("value: \(value), num: \(num)")
    }
}


extension ViewController: RichEditorDelegate {
    func richEditorDidLoad(_ editor: RichEditorView) {
        // for testing, always load the same demo
        let path = Bundle.main.path(forResource: "touchsurfaceTable", ofType: "html")
        let htmlStr: String = try! String(contentsOfFile: path!)
        editor.insertHTML(htmlStr)
        //self.editorView.insertHTML(htmlStr)
        //self.editorView.webView.reload()
        //print(self.editorView.runJS("document.documentElement.outerHTML"))
        //self.editorView.html = self.journal?.html ??
    }
    
    func richEditorInsertImage() {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func richEditorInsertlayout() {
        self.presentJournalLayouts()
    }
    
    func richEditorChangeColor() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let colorCardViewController = storyBoard.instantiateViewController(withIdentifier: "colorCardViewController") as! ColorCardTableViewController
        colorCardViewController.buttonHeight = 0.00
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
