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
    
    
    @IBOutlet weak var editorView: CustomRichEditorView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var modeSwitcher: UISegmentedControl!
    
    var journal: Journal?
    var touchBlockClicked: Bool = false
    var touchBlockClickedCopy: Bool = false
    var indexFile: String = "index2"
    
    private var isContentMode: Bool = true
    private var isCreatingJournal: Bool = false
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary  // Only allow photos to be picked, not taken.
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        // Add UISegmentControl action
        modeSwitcher.addTarget(
            self,
            action:
            #selector(self.onChange),
            for:.valueChanged)
        
        // Set editoView delegate
        editorView.delegate = self as RichEditorDelegate // Diqing Debug 13.03.2017
        editorView.customDelegate = self as CustomRichEditorDelegate
        
        // Set jsContext
        let jsContext = self.editorView.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(/*JavaScriptFunc()*/self, forKeyedSubscript: "javaScriptCallToSwift" as (NSCopying & NSObjectProtocol)?)
        
        // Load selected journal or create new journal from template
        if let journal = journal {
            editorView.webView.loadHTMLString("\(journal.html)", baseURL: Bundle.main.bundleURL)
            if journal.id == nil {
                journal.id = NSUUID() as UUID  // in case of an old version journal with id==nil, create an id
            }
        } else {  //empty, add new journal and create a unique journal ID
            isCreatingJournal = true
            let newJournalID = NSUUID() as UUID
            journal = Journal(html: "", photo: nil, month: nil, id: newJournalID)  // create an empty journal but with id, because we need this for saving temp images
            
            if let filePath = Bundle.main.path(forResource: self.indexFile, ofType: "html"){
                let url = URL(fileURLWithPath: filePath, isDirectory: false)
                let request = URLRequest(url: url)
                editorView.webView.loadRequest(request)
            }
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
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
        
        if let myUrl = self.saveImageAndReturnUrl(image: selectedImage) {
            if !touchBlockClickedCopy {
                editorView.insertImage(myUrl, alt: myUrl)
            } else {
                editorView.setTouchBlockBackgroundImage(myUrl, alt: myUrl)
            }
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
            // before save make sure editor is in content mode
            self.editorView.enterContentMode()
            var photo: UIImage!
            if let screenshot = takeUIWebViewScreenShot(webView: self.editorView.webView, isFullSize: false) {
                photo = screenshot
            } else {
                photo = UIImage(named: "layoutMode")
            }
            
            //let formatter = DateFormatter()
            //formatter.dateFormat = "yyyy/MM/dd"
            //var date = formatter.date(from: "2018/05/02")
            let date = Date()
            let html = self.editorView.getDocElementHtml()
            journal?.html = html
            journal?.photo = photo
            journal?.month = date
            return
        }
        
        switch(segue.identifier ?? "") {
        case "cropImage":
            guard let destinationController = segue.destination as? ImageCropperViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            if let screenshot = takeUIWebViewScreenShot(webView: self.editorView.webView, isFullSize: true) {
                destinationController.image = screenshot
            }
        case "showHelp":
            guard let destinationController = segue.destination as? HelpTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destinationController.helpInfo = HelpInfo.journalEditorHelp
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    

    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "End Editing", message: "Do you want to exit without saving?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped")
            self.noSaveEditingAction()
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "我先冷静冷静。。", style: .cancel) { (action:UIAlertAction!) in
            print("End canceled")
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func unwindToRichtextEditor(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ColorCardTableViewController {
            if let fillingEffect = sourceViewController.selectedFillingEffect{
                if let selectedColor = fillingEffect.color {
                    if touchBlockClicked {  // if triggered by touchblock then update touchblock color
                        touchBlockClicked = false
                        self.editorView.setTouchBlockBackgroundColor(selectedColor.htmlRGBA)
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
                    fatalError("Unexpected filling effect type: \(String(describing: fillingEffect.type))")
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
            } else if sender.identifier == "setBorder"{
                let selectedBorder = sourceViewController.selectedBorder
                let selectedBorderColor = sourceViewController.selectedBorderColor
                
                self.editorView.setTouchblockBorder(selectedBorder?.jsCommand ?? "")
                self.editorView.setTouchblockBorderColor(selectedBorderColor?.htmlRGBA ?? "")
            } else if sender.identifier == "setTouchblockFonts" {
                let selectedFont = sourceViewController.selectedBorder
                self.editorView.setTouchblockFonts(selectedFont?.name ?? "")
            } else if sender.identifier == "cancel"{
                print("Canceled")
            } else {
                fatalError("Unexpected segue identifier: \(String(describing: sender.identifier))")
            }
            touchBlockClicked = false // reset touchBlockClicked
        }
    }
    
    @IBAction func unwindFontTableToRichtextEditor(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? FontsTableViewController {
            if sender.identifier == "setFont" {
                let selectedFont = sourceViewController.selectedFont
                self.editorView.setFontOfThisDiv(selectedFont?.name ?? "")
            }
        }
    }
    
    @IBAction func unwindImgMenuToRichtextEditor(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ImageEditMenuController {
            if sender.identifier == "setImg" {
                    touchBlockClickedCopy = true // raise a second flag for image picker (multithread..)
                    let imagePickerController = UIImagePickerController()
                    // Only allow photos to be picked, not taken.
                    imagePickerController.sourceType = .photoLibrary
                    
                    // Make sure ViewController is notified when the user picks an image.
                    imagePickerController.delegate = self
                    DispatchQueue.main.async {
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
            } else if sender.identifier == "setBorder"{
                print("set border")
                if let selectedBorder = sourceViewController.selectedBorder{
                    self.editorView.setImgBorder(selectedBorder.jsCommand)
                }
                if let selectedBorderColor = sourceViewController.selectedBorderColor {
                    self.editorView.setTouchblockBorderColor(selectedBorderColor.htmlRGBA)
                }
            } else if sender.identifier == "floatLeft" {
                self.editorView.setImgFloat("left")
            }  else if sender.identifier == "floatMid" {
                self.editorView.setImgFloat("none")
            }  else if sender.identifier == "floatRight" {
                self.editorView.setImgFloat("right")
            } else if sender.identifier == "delete" {
                self.editorView.removeClickedTouchblock()
            } else if sender.identifier == "cancel"{
                print("Canceled")
            } else if sender.identifier == "setFilter" {
                if let selectedFilter = sourceViewController.selectedFilter{
                    self.editorView.setImgFilter(selectedFilter.jsCommand)
                }
            } else {
                fatalError("Unexpected segue identifier: \(String(describing: sender.identifier))")
            }
            touchBlockClicked = false // reset touchBlockClicked
        }
        
    }
    
    // MARK: Private Methods
    
    // If end without saving, return to the galary and clean the temp files.
    private func noSaveEditingAction() {
        let fileManager = FileManager.default
        let imgDir = ImageHandler.getDocumentsDirectory()
        if isCreatingJournal {
            let filepath = imgDir.appendingPathComponent((journal?.id?.uuidString)!)
            print(filepath)
            do {
                try fileManager.removeItem(at: filepath)
                print("I think this is removed..... \(filepath)")
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
        let isPresentingInAddJournalMode = presentingViewController is UINavigationController
        
        if isPresentingInAddJournalMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The JournalViewController is not inside a navigation controller.")
        }
    }
    
    // Triggered when switching modes, detect sender(Normal Image or Block) index and choose action
    @objc private func onChange(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            self.editorView.enterContentMode()
            self.editorView.isEditingEnabled = true
            self.editorView.attachKeyboardToolbar()
        case 1:
            self.editorView.enterLayoutMode()
            self.editorView.isEditingEnabled = false
            self.editorView.removeKeyboardToolbar()
        case 2:
            self.editorView.layoutOnlyImage()
            self.editorView.isEditingEnabled = false
            self.editorView.removeKeyboardToolbar()
        default:
            self.editorView.enterContentMode()
            self.editorView.isEditingEnabled = true
            self.editorView.attachKeyboardToolbar()
        }
    }
    
    private func saveImageAndReturnUrl(image: UIImage) -> String?{
        
        // get a unique name for the image file
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        let imageName = "\(dateFormatter.string(from: Date())).png"
        var myImage: UIImage?
        // get save path of image file
        
        let journalPath = ImageHandler.getDocumentsDirectory().appendingPathComponent((journal?.id?.uuidString)!)
        print(journalPath)
        do {
            try FileManager.default.createDirectory(atPath: journalPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        let imgPath = journalPath.appendingPathComponent(imageName)
        print("this is my file path ############ \(imgPath)")
        if image.updateImageOrientionUpSide() != nil {
            myImage = image.updateImageOrientionUpSide()
        } else {
            myImage = image
        }
        
        //let data = image.mediumQualityJPEGNSData
        let data = jpegImage(image: myImage!, maxSize: 600000)
        do
        {
            try data?.write(to: imgPath, options: Data.WritingOptions.atomic)
            return imgPath.absoluteString  // if succeeds then return the url of saved image
        }
        catch
        {
            print("failed to save image")
            // Catch exception here and act accordingly
            return nil
        }
    }
    
    private func takeUIWebViewScreenShot(webView: UIWebView, isFullSize: Bool)->UIImage?{
        let webViewFrame = webView.frame
        
        var imageHeight: CGFloat?
        let stringHeight = runJS("document.getElementById('editor').scrollHeight;")
        imageHeight = CGFloat(Float(stringHeight) ?? 0.00)
        let myFrame = CGRect(x: webViewFrame.origin.x, y: webViewFrame.origin.y, width: webView.scrollView.contentSize.width, height: imageHeight!)
        webView.frame = myFrame
        
        if isFullSize {
//            let stringHeight = runJS("document.getElementById('editor').scrollHeight;")
//            imageHeight = CGFloat(Float(stringHeight) ?? 0.00)
//            let myFrame = CGRect(x: webViewFrame.origin.x, y: webViewFrame.origin.y, width: webView.scrollView.contentSize.width, height: imageHeight!)
//            webView.frame = myFrame
            UIGraphicsBeginImageContextWithOptions(CGSize(width: webView.scrollView.contentSize.width, height: imageHeight!), false, 0)
            
        } else {
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: webView.scrollView.contentSize.width, height: webView.scrollView.contentSize.width), false, 0)

            
        }
        
        //UIGraphicsBeginImageContextWithOptions(webView.scrollView.contentSize, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil}
        webView.scrollView.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil}
        UIGraphicsEndImageContext()
        webView.frame = webViewFrame
        return image
    }
    
    func runJS(_ js: String) -> String {
        let string = self.editorView.webView.stringByEvaluatingJavaScript(from: js) ?? ""
        return string
    }
    
    // MATK: Obsolete
    private func localizeImgsOfTemplate() {
        if let imgSrcList = self.editorView.getImgSrcs(){
            if let srcArray = imgSrcList.toArray() {
                for imgSrc in srcArray {
                    print(imgSrc)
                }
            }
            
        }
    }
    
    func jpegImage(image: UIImage, maxSize: Int) -> Data? {
        var maxQuality: CGFloat = 1.0
        let interval: CGFloat = 0.1
        var bestData: Data?
        var thisQuality = maxQuality
        for _ in 0...10 {
            thisQuality = maxQuality -  interval
            guard let data = UIImageJPEGRepresentation(image, thisQuality) else { return nil }
            bestData = data
            let thisSize = data.count
            if thisSize > maxSize {
                maxQuality = thisQuality
            } else {
                return bestData
                }
            }
        return bestData
    }
    
}

extension JournalViewController: JavaScriptFuncProtocol {
    func showTouchblockMenu() {
        touchBlockClicked = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let colorCardViewController = storyBoard.instantiateViewController(withIdentifier: "touchBlockEditMenuNavi") as! UINavigationController
        self.present(colorCardViewController, animated:true, completion:nil)
    }
    
    func showImgMenu() {
        touchBlockClicked = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let imgEditMenuController = storyBoard.instantiateViewController(withIdentifier: "imageEditMenuNavi") as! UINavigationController
        self.present(imgEditMenuController, animated:true, completion:nil)
    }
    
}


extension JournalViewController: RichEditorDelegate {
    func richEditorDidLoad(_ editor: RichEditorView) {
        self.editorView.initTouchblockCovers()
        let docDirectory = ImageHandler.getDocumentsDirectory().path + "/"
        self.editorView.updateImgSrcs(docDirectory)
        
        
        // You might want to ask: What the hell are you doing here!?
        // Well.. I do not understand either..but..without following codes.
        // But they stop app from crashing....
        _ = self.editorView.becomeFirstResponder()
        self.editorView.endEditing(true)
    }
    
    func richEditorInsertImage() {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func richEditorSaveHTML() {
        if self.editorView.html.isEmpty {  // if no content then delete journal
            //CoreDataHandler.deleteDiary(self.journal)
        } else {  // if there is content then save to core data
            if self.journal != nil {
                self.journal?.html = self.editorView.html
            } else {
                //self.journal = CoreDataHandler.createNewDiary(testDate)
                self.journal?.html = self.editorView.html
            }
            //CoreDataHandler.saveDiary()
        }
    }
}

extension JournalViewController: CustomRichEditorDelegate {
    func richEditorSetFont() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let fontsTableNaviController = storyBoard.instantiateViewController(withIdentifier: "FontsTableNaviController") as! UINavigationController
        self.present(fontsTableNaviController, animated:true, completion:nil)
    }
}

extension UIImage {
    var uncompressedPNGData: NSData {return UIImagePNGRepresentation(self)! as NSData}
    var highestQualityJPEGNSData: NSData {return UIImageJPEGRepresentation(self,1.0)! as NSData}
    var highQualityJPEGNSData: NSData {return UIImageJPEGRepresentation(self, 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData {return UIImageJPEGRepresentation(self, 0.5)! as NSData}
    var lowQualityJPEGNSData: NSData {return UIImageJPEGRepresentation(self, 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData {return UIImageJPEGRepresentation(self, 0.0)! as NSData}
}
