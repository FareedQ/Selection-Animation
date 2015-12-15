//
//  ViewController.swift
//  SelectionAnimation
//
//  Created by FareedQ on 2015-12-13.
//  Copyright © 2015 FareedQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var SelectionViewTopContraint: NSLayoutConstraint!
    
    weak var mySelectionVC:selectionViewController!
    var originalMainImageFrame = CGRect()
    var originalFirstImageFrame = CGRect()
    var originalSecondImageFrame = CGRect()
    var originalThirdImageFrame = CGRect()
    var originalFourthImageFrame = CGRect()
    
    var selectedImage:imageSelection = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectionViewTopContraint.constant = -108
        
        originalMainImageFrame = mainImage.frame
        originalFirstImageFrame = mySelectionVC.img1.frame
        originalSecondImageFrame = mySelectionVC.img2.frame
        originalThirdImageFrame = mySelectionVC.img3.frame
        originalFourthImageFrame = mySelectionVC.img4.frame
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "selectedMainImage:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func selectedMainImage(sender: UIGestureRecognizer){
        let touchPosition = sender.locationInView(self.view)
        
        switch sender.state {
        case .Began:
            if mainImage.frame.contains(touchPosition){
                animateLoweringTheSelectionView(touchPosition)
            }
            break
        case .Changed:
            self.mainImage.center = touchPosition
            changeToSelectedOption(touchPosition)
            break
        case .Ended:
            if(selectedImage != .none){ SwitchToTheSelectedOption() }
            animatePuttingThingsBackInTheirPlaces()
            break
        default:
            break
        }
        
    }
    
    func changeToSelectedOption(touchPosition:CGPoint){
        if(originalFirstImageFrame.contains(touchPosition)){
            animateOptionSelected(self.mySelectionVC.img1)
            selectedImage = .firstImage
        } else if(originalSecondImageFrame.contains(touchPosition)){
            animateOptionSelected(self.mySelectionVC.img2)
            selectedImage = .secondImage
        } else if(originalThirdImageFrame.contains(touchPosition)){
            animateOptionSelected(self.mySelectionVC.img3)
            selectedImage = .thirdImage
        } else if(originalFourthImageFrame.contains(touchPosition)){
            animateOptionSelected(self.mySelectionVC.img4)
            selectedImage = .fourthImage
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.returnSelectableImagesToScale()
            })
            selectedImage = .none
        }
    }
    
    func animateOptionSelected(selectedImage:UIImageView){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.returnSelectableImagesToScale()
            selectedImage.frame = self.originalMainImageFrame
            self.mySelectionVC.view.bringSubviewToFront(selectedImage)
        })
    }
    
    func animatePuttingThingsBackInTheirPlaces(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.SelectionViewTopContraint.constant = -108
            self.view.layoutIfNeeded()
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mainImage.transform = CGAffineTransformMakeScale(1, 1)
                    self.mainImage.frame = self.originalMainImageFrame
                    self.view.bringSubviewToFront(self.mainImage)
                    self.mainImage.alpha = 1
                })
        })
    }
    
    func animateLoweringTheSelectionView(touchPosition:CGPoint){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainImage.transform = CGAffineTransformMakeScale(0.3, 0.3)
            self.mainImage.alpha = 0.3
            self.mainImage.center = touchPosition
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.SelectionViewTopContraint.constant = 0
                    self.view.layoutIfNeeded()
                    self.mainImage.center = touchPosition
                })
        })
    }
    
    func SwitchToTheSelectedOption(){
        switch selectedImage{
        case .firstImage:
            swapImages(&mainImage.image!, SecondImage:&mySelectionVC.img1.image!)
            mySelectionVC.img1.frame = originalFirstImageFrame
            break
        case .secondImage:
            swapImages(&mainImage.image!, SecondImage:&mySelectionVC.img2.image!)
            mySelectionVC.img2.frame = originalSecondImageFrame
            break
        case .thirdImage:
            swapImages(&mainImage.image!, SecondImage:&mySelectionVC.img3.image!)
            mySelectionVC.img3.frame = originalThirdImageFrame
            break
        case .fourthImage:
            swapImages(&mainImage.image!, SecondImage:&mySelectionVC.img4.image!)
            mySelectionVC.img4.frame = originalFourthImageFrame
            break
        default:
            break
        }
        
        mainImage.transform = CGAffineTransformMakeScale(1, 1)
        mainImage.frame = self.originalMainImageFrame
        mainImage.alpha = 1
        view.sendSubviewToBack(mainImage)
        selectedImage = .none
    }
    
    func swapImages(inout FirstImage:UIImage, inout SecondImage:UIImage){
        let tempImage = FirstImage
        FirstImage = SecondImage
        SecondImage = tempImage
    }

    func returnSelectableImagesToScale(){
        mySelectionVC.img1.frame = originalFirstImageFrame
        mySelectionVC.img2.frame = originalSecondImageFrame
        mySelectionVC.img3.frame = originalThirdImageFrame
        mySelectionVC.img4.frame = originalFourthImageFrame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectionSegue" {
            guard let tempVC = segue.destinationViewController as? selectionViewController else {return}
            mySelectionVC = tempVC
        }
    }

}

