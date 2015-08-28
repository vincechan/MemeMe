//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Vince Chan on 8/18/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        collectionView?.reloadData()
    }
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        // present the edit meme view controller to add a meme
        let controller = storyboard!.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        let navigation = UINavigationController(rootViewController: controller)
        presentViewController(navigation, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.allMemes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> MemeCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
    
        let meme = Meme.allMemes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        return cell
        
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // present the detail view when a meme is selected
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        controller.memeIndex = indexPath.row
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func configureLayout() {
        let space: CGFloat = 3.0
        let narrowSideLength = view.frame.width < view.frame.height ?
            view.frame.width : view.frame.height
        let dimension = (narrowSideLength  - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
}
