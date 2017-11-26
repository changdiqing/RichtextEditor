//
//  ViewController.swift
//  journal
//
//  Created by Diqing Chang on 01.11.17.
//  Copyright © 2017 Diqing Chang. All rights reserved.
//

import UIKit
import RichEditorView

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        editorView.delegate = self
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
            print(myUrl)
            editorView.insertImage(myUrl, alt: myUrl)
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

extension ViewController: RichEditorDelegate {
    func richEditorInsertImage() {
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
}
