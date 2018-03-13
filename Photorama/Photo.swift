//
//  Photo.swift
//  Photorama
//  Akshit Upneja: 300976590
//  AmanPreet Kaur: 300966930
//  Created by Akshit Upneja on 2018-03-12.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation

enum PhotosResult {
    case success([Photo])
    case failure (Error)
}
class Photo {
    let title : String
    let remoteURL : URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date){
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
