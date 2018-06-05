//
//  ViewController.swift
//  image cropper
//
//  Created by Diqing Chang on 16.04.18.
//  Copyright © 2018 Diqing Chang. All rights reserved.
//

import UIKit

class ImageCropperViewController: UIViewController{

    @IBOutlet weak var bottomPanBar: UIView!
    @IBOutlet weak var rightPanBar: UIView!
    @IBOutlet weak var topPanBar: UIView!
    @IBOutlet weak var leftPanBar: UIView!
    @IBOutlet weak var bottomPanToBottom: NSLayoutConstraint!
    @IBOutlet weak var sidePanToRight: NSLayoutConstraint!
    @IBOutlet weak var sidePanToLeft: NSLayoutConstraint!
    @IBOutlet weak var topPanToTop: NSLayoutConstraint!
    @IBOutlet weak var cropAreaToBottom: NSLayoutConstraint!
    @IBOutlet weak var cropAreaToRight: NSLayoutConstraint!
    @IBOutlet weak var cropAreaToTop: NSLayoutConstraint!
    @IBOutlet weak var cropAreaToLeft: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 10.0
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cropAreaView: CropAreaView!
    
    private var attachTextView: UITextView!
    var image: UIImage?
    
    var translation: CGPoint!
    
    var cropArea:CGRect{
        get{
            let factor = max(imageView.image!.size.width/imageView.frame.width, imageView.image!.size.height/imageView.frame.height)
            let scale = 1/scrollView.zoomScale
            let scale2 = imageView.image!.scale
            let imageFrame = imageView.imageFrame()
            //print("imageFrame: \(imageFrame)")
            /*
            print("factor: \(factor)")
            print("scroll scale: \(scale)")
            print("image scale: \(scale2)")
            print(scrollView.contentOffset.x)
            print(cropAreaView.frame.origin.x)
            print(scrollView.frame.origin.y)
            print(imageFrame.origin.x)*/
            
            let x = (scrollView.contentOffset.x + cropAreaView.frame.origin.x - scrollView.frame.origin.x - imageFrame.origin.x) * factor * scale2
            let y = (scrollView.contentOffset.y + cropAreaView.frame.origin.y - scrollView.frame.origin.y - imageFrame.origin.y) * factor * scale2
            
            let width = cropAreaView.frame.size.width  * factor * scale2
            let height = cropAreaView.frame.size.height * factor * scale2

            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewDidDragged(_:)))
        bottomPanBar.addGestureRecognizer(panGesture)
        let sidePanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.rightViewDidDragged(_:)))
        rightPanBar.addGestureRecognizer(sidePanGesture)
        let leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.leftViewDidDragged(_:)))
        leftPanBar.addGestureRecognizer(leftPanGesture)
        let topPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.topViewDidDragged(_:)))
        topPanBar.addGestureRecognizer(topPanGesture)
        
        // Uncomment to draw a border on image view programmatically
        //self.imageView.image.layer.borderWidth = 1
        //self.imageView.image.layer.borderColor = UIColor.black.cgColor
        initKeyboardView()
        resetCropViews()

        if image != nil {
            self.imageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crop(_ sender: UIButton) {
        let myHeight = imageView.image?.size.height
        let myScale = imageView.image?.scale
        
        print("initial crop frame: \(cropAreaView.frame)")
        print("initial contentoffset: \(scrollView.contentOffset)")
        print("initial image frame: \(imageView.imageFrame().origin)")
        print("initial scrollview frame: \(scrollView.frame.origin)")
        
        print("image size: \(imageView.image?.size)")
        print("cropArea: \(cropArea)")
        if let croppedCGImage = imageView.image?.cgImage?.cropping(to: cropArea) {
            let croppedImage = UIImage(cgImage: croppedCGImage)
            imageView.image = croppedImage
        }
        scrollView.zoomScale = 1
        resetCropViews()
    }
    
    @objc func viewDidDragged(_ sender: UIPanGestureRecognizer) {
            translation = sender.translation(in: self.view)
            sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
        
            bottomPanToBottom.constant = bottomPanToBottom.constant - translation.y
            cropAreaToBottom.constant = cropAreaToBottom.constant - translation.y
    }
    
    @objc func rightViewDidDragged(_ sender: UIPanGestureRecognizer) {
        translation = sender.translation(in: self.view)
        sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
        
        sidePanToRight.constant = sidePanToRight.constant - translation.x
        cropAreaToRight.constant = cropAreaToRight.constant - translation.x
    }
    
    @objc func topViewDidDragged(_ sender: UIPanGestureRecognizer) {
        translation = sender.translation(in: self.view)
        sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
        
        topPanToTop.constant = topPanToTop.constant + translation.y
        cropAreaToTop.constant = cropAreaToTop.constant + translation.y
    }
    
    @objc func leftViewDidDragged(_ sender: UIPanGestureRecognizer) {
        translation = sender.translation(in: self.view)
        sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
        
        sidePanToLeft.constant = sidePanToLeft.constant + translation.x
        cropAreaToLeft.constant = cropAreaToLeft.constant + translation.x
    }
    
    // MARK: Actions
    
    @IBAction func shareAction(_ sender: Any) {
        self.attachTextView.becomeFirstResponder()
    }
    
    // MARK: Private Methods
    private func resetCropViews(){
        bottomPanToBottom.constant = 0
        sidePanToRight.constant = 0
        sidePanToLeft.constant = 0
        topPanToTop.constant = 0
        cropAreaToBottom.constant = 0
        cropAreaToRight.constant = 0
        cropAreaToLeft.constant = 0
        cropAreaToTop.constant = 0
        
    }
    
    private func initKeyboardView() {
        
        // instantiate a gesture recognizer to allow dismiss keyboard on tap
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // init puppetTextView
        attachTextView = UITextView(frame: CGRect.zero)
        attachTextView.alpha = 0.0
        self.view.addSubview(attachTextView)
        
        let keyboardFrame = CGRect(x: 0, y: 0, width: 300, height: 271)
        let keyboardView = ShareKeyboard(frame: keyboardFrame)
        keyboardView.delegate = self
        self.attachTextView.inputView = keyboardView
        self.attachTextView.reloadInputViews()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.attachTextView.resignFirstResponder()
    }

}

extension ImageCropperViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImageCropperViewController: KeyboardDelegate {
    func keyWasTapped(color: UIColor) {
        print("key was tapped")
    }
    
    func cutomKeyTapped(keyId: String) {
        switch keyId {
        case "iosphoto":
            //Save it to the camera roll
            if let image = self.imageView.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        default:
            print("share to wechat")
        }
        self.dismissKeyboard()
    }
    
    
}
