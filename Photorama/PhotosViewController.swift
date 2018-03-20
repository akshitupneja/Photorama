//
//  PhotosViewController.swift
//  Photorama
//  Akshit Upneja: 300976590
//  AmanPreet Kaur: 300966930
//  Created by Akshit Upneja on 2018-03-12.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store : PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self

        // Do any additional setup after loading the view.
         collectionView.dataSource = photoDataSource
       
        store.fetchInterestingPhotos{
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Success found \(photos.count) photos")
                
                self.photoDataSource.photos = photos
//                if let firstPhoto = photos.first {
//                    self.updateImageView(for: firstPhoto)
//                }
//
            case let .failure(error):
                print("Error fetching \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func  collectionView(_ collectionView: UICollectionView, willDisplay cell : UICollectionViewCell, forItemAt  indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        //Download the image data
        
        store.fetchImage(for: photo){ (result) -> Void in
          
           guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
            }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath =
                collectionView.indexPathsForSelectedItems?.first {
                
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC =
                    segue.destination as! ImageViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
}
    
    
//    func updateImageView(for photo: Photo) {
//        store.fetchImage(for: photo){
//            ImageResult -> Void in
//
//            switch ImageResult {
//            case let .success(image):
//                self.imageView.image = image
//            case let  .failure(error):
//                print("Error downloading image : \(error)")
//
//            }
//        }
//    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


