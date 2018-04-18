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
import os.log

class JournalViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var editorView: RichEditorView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var changeModeButton: UIBarButtonItem!
    
    var journal: Journal?
    var touchBlockClicked: Bool = false
    var touchBlockClickedCopy: Bool = false
    var indexFile: String = "index2"
    
    private var isContentMode: Bool = true
    private let contentModeIcon = #imageLiteral(resourceName: "editMode")
    private let layoutModeIcon = #imageLiteral(resourceName: "layoutMode")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get selected template
        

        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        editorView.delegate = self // Diqing Debug 13.03.2017
        
        let jsContext = self.editorView.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(/*JavaScriptFunc()*/self, forKeyedSubscript: "javaScriptCallToSwift" as (NSCopying & NSObjectProtocol)!)
        
        if let journal = journal {
            editorView.webView.loadHTMLString("\(journal.html)", baseURL: Bundle.main.bundleURL)
        } else {//empty, add new journal
            
            
            if let filePath = Bundle.main.path(forResource: self.indexFile, ofType: "html"){
                let url = URL(fileURLWithPath: filePath, isDirectory: false)
                let request = URLRequest(url: url)
                editorView.webView.loadRequest(request)
            }
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
            if !touchBlockClickedCopy {
                print("here")
                editorView.insertImage(myUrl, alt: myUrl)
            } else {
                editorView.setTouchBlockBackgroundImage(myUrl, alt: myUrl)
            }
        }
        catch
        {
            print("failed to save image")
            // Catch exception here and act accordingly
        }
        touchBlockClickedCopy = false
        self.editorView.initTouchblockCovers()
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        if let button = sender as? UIBarButtonItem, button === saveButton {
            var photo: UIImage!
            if let screenshot = takeUIWebViewScreenShot(webView: self.editorView.webView) {
                photo = screenshot
            } else {
                photo = UIImage(named: "layoutMode")
            }
            let html = self.editorView.getDocElementHtml()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            var date = formatter.date(from: "2018/05/02")
            date = Date()
            journal = Journal(html: html, photo: photo, month: date)
            
        }
        
    }
    
    
    func presentJournalLayouts() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let journalLayoutsViewController = storyBoard.instantiateViewController(withIdentifier: "JournalLayoutsViewController") as! JournalLayoutCollectionViewController
        self.present(journalLayoutsViewController, animated:true, completion:nil)
    }
    

    
    // MARK: Actions
    
    @IBAction func changeModeAction(_ sender: Any) {
        self.isContentMode = !self.isContentMode
        if self.isContentMode {
            self.changeModeButton.image = self.contentModeIcon
            self.editorView.enterContentMode()
            self.editorView.isEditingEnabled = true
            self.editorView.attachKeyboardToolbar()
        } else {
            self.changeModeButton.image = self.layoutModeIcon
            self.editorView.enterLayoutMode()
            self.editorView.isEditingEnabled = false
            self.editorView.removeKeyboardToolbar()
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddJournalMode = presentingViewController is UINavigationController
        
        if isPresentingInAddJournalMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The JournalViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func unwindToRichtextEditor(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ColorCardTableViewController {
            if let fillingEffect = sourceViewController.selectedFillingEffect{
                if let selectedColor = fillingEffect.color {
                    if touchBlockClicked {  // if triggered by touchblock then update touchblock color
                        touchBlockClicked = false
                        self.editorView.setTouchBlockBackgroundColor(selectedColor.htmlRGBA)
                    } else {  // else update selected text color
                       
                    }
                } else if fillingEffect.type == "No Filling" {
                    self.editorView.setTouchBlockBackgroundColor("transparent")
                } else if fillingEffect.type == "Photo" {
                    touchBlockClickedCopy = true // raise a second flag for image picker (multithread..)
                    let imagePickerController = UIImagePickerController()
                    // Only allow photos to be picked, not taken.
                    imagePickerController.sourceType = .photoLibrary
                    
                    // Make sure ViewController is notified when the user picks an image.
                    imagePickerController.delegate = self
                    DispatchQueue.main.async {
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                } else {
                    fatalError("Unexpected filling effect type: \(fillingEffect.type)")
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
            } else if sender.identifier == "cancel"{
                print("Canceled")
            } else {
                fatalError("Unexpected segue identifier: \(sender.identifier)")
            }
            touchBlockClicked = false // reset touchBlockClicked
        } else if let sourceViewController = sender.source as? JournalLayoutCollectionViewController {
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
                    //self.editorView.insertHTML(htmlStr)
                    self.editorView.appendHTML(htmlStr)
                }
                
                self.editorView.initTouchblockCovers()
                self.editorView.enterContentMode()
                print(self.editorView.html)
            }
            catch {"error: file not found"}
        }
    }
    func takeUIWebViewScreenShot(webView: UIWebView)->UIImage?{
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(webView.frame.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil}
        webView.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil}
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        return image
    }
}

extension JournalViewController: JavaScriptFuncProtocol {
    func test() {
        touchBlockClicked = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let colorCardViewController = storyBoard.instantiateViewController(withIdentifier: "colorCardViewController") as! ColorCardTableViewController
        colorCardViewController.buttonHeight = colorCardViewController.defaultButtonHeight
        self.present(colorCardViewController, animated:true, completion:nil)
    }
    
    func test2(_ value: String, _ num: Int) {
        print("value: \(value), num: \(num)")
    }
}


extension JournalViewController: RichEditorDelegate {
    func richEditorDidLoad(_ editor: RichEditorView) {
        // for testing, always load the same demo
        print("view did load")
        self.editorView.initTouchblockCovers()
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
    
    func richEditorSaveHTML() {
        if self.editorView.html.isEmpty {  // if no content then delete journal
            //CoreDataHandler.deleteDiary(self.journal)
        } else {  // if there is content then save to core data
            if self.journal != nil {
                self.journal?.html = self.editorView.html
                print("existing journal saved!")
            } else {
                //self.journal = CoreDataHandler.createNewDiary(testDate)
                self.journal?.html = self.editorView.html
                print("new journal created!")
            }
            //CoreDataHandler.saveDiary()
        }
    }
}
