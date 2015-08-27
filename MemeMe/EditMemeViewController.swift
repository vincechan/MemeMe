//
//  ViewController.swift
//  MemeMe
//
//  Created by Vince Chan on 8/15/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate {

    var editMeme: Meme?
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.toolbarHidden = false
        
        configureTextFields()
        initControlStates()
    }
    
    override func viewWillAppear(animated: Bool) {
        // disable camera if it's not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        controller.delegate = self
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> Void in
            if (completed) {
                self.save()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // handle user picked an image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            updateControlsToAfterImagePicked()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // handle user canceled image picking
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // clear default text on top and bottom text field
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topTextField && textField.text == "TOP") {
            textField.text = ""
        }
        if (textField == bottomTextField && textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    // dismiss keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // shift view up when keyboard for bottom text field is showing
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // shift view back down when keyboard for bottom text field is hiding
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y =  CGFloat(0)
        }
    }
    
    // determine the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // generate a meme image
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        navigationController?.navigationBar.hidden = true
        navigationController?.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.navigationBar.hidden = false
        navigationController?.toolbar.hidden = false
        
        return memedImage
    }
    
    // save a meme
    func save() {
        let image = generateMemedImage()
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image!, memedImage: image)
        Meme.add(meme)
    }
    
    // configure the text fields appearance
    func configureTextFields() {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        // assign the view controller to be the delegate of the text fields
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    // init controls states
    func initControlStates() {
        if let meme = editMeme {
            // edit mode
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            imageView.image  = meme.originalImage
            updateControlsToAfterImagePicked()
            navigationItem.title = "Edit Meme"
        } else {
            // add mode
            topTextField.text = "TOP"
            topTextField.enabled = false
            bottomTextField.text = "BOTTOM"
            bottomTextField.enabled = false
            shareButton.enabled = false
            imageView.image = nil
            navigationItem.title = "Add Meme"
            
            // if user run this for the first time with no previous created memes,
            // do not allow user to cancel out of the screen that creates a new meme
            cancelButton.enabled = Meme.allMemes.count > 0
        }
       
    }
    
    // update control states to what they should be once an image is picked
    func updateControlsToAfterImagePicked() {
        topTextField.enabled = true
        bottomTextField.enabled = true
        shareButton.enabled = true
        cancelButton.enabled = true
    }
}
