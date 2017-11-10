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
    
    //Mark: Private Methods


}

extension ViewController: RichEditorDelegate {
    func richEditorInsertImage(_ editor: RichEditorView) {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
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
