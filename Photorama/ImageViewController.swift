//
//  ImageViewController.swift
//  Photorama
//
//  Created by Akshit Upneja on 2018-03-19.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var dispayImage: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo, completion: { (result) -> Void in
            switch result {
            case let .success(image):
                self.dispayImage.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        })
    }
}
