//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Vince Chan on 8/23/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memeIndex = -1
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = Meme.allMemes[memeIndex].memedImage
        
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
        let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "delete")
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }

    func edit() {
        // present the edit meme view controller to edit a meme
        let controller = storyboard!.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        controller.editMeme = Meme.allMemes[memeIndex]
        controller.editMemeIndex = memeIndex
        let navigation = UINavigationController(rootViewController: controller)
        presentViewController(navigation, animated: true, completion: nil)
    }
    
    func delete() {
        // delete the meme and go back to previous view
        Meme.remove(memeIndex)
       
        navigationController?.popViewControllerAnimated(true)
    }
}
