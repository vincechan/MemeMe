//
//  TableViewController.swift
//  MemeMe
//
//  Created by Vince Chan on 8/18/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        // present the edit meme view controller to add a meme
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        let navigation = UINavigationController(rootViewController: controller)
        presentViewController(navigation, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.allMemes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! UITableViewCell

        let meme = Meme.allMemes[indexPath.row]
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // present the detail view when a meme is selected
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        controller.memeIndex = indexPath.row
        self.navigationController!.pushViewController(controller, animated: true)
    }
}
