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
            let scale2 = imageView.image!.scale
            let imageFrame = imageView.imageFrame()
            
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
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: Private Methods
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your jounral has been saved as image to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
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

}

extension ImageCropperViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
