//
//  Meme.swift
//  MemeMe
//
//  Created by Vince Chan on 8/16/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import UIKit

class Meme {
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    init (topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage  = originalImage
        self.memedImage = memedImage
    }
}