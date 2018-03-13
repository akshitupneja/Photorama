//
//  PhotosViewController.swift
//  Photorama
//  Akshit Upneja: 300976590
//  AmanPreet Kaur: 300966930
//  Created by Akshit Upneja on 2018-03-12.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    
    @IBOutlet var imageView: UIImageView!
    var store : PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        store.fetchInterestingPhotos{
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Success found \(photos.count) photos")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }   
                
            case let .failure(error):
                print("Error fetching \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo){
            ImageResult -> Void in
            
            switch ImageResult {
            case let .success(image):
                self.imageView.image = image
            case let  .failure(error):
                print("Error downloading image : \(error)")
                
            }
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
