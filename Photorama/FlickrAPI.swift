//
//  FlickrAPI.swift
//  Photorama
//  Akshit Upneja: 300976590
//  AmanPreet Kaur: 300966930
//  Created by Akshit Upneja on 2018-03-12.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation

struct FlickrAPI {
     static let baseURLString = "https://www.flickr.com/services/rest/"
        static let apiKey = "608c765df174d6693907973466210427"
}

enum FlickrError: Error{
    case invalidJSONdata
}

enum Method : String {
    case interstingPhotos  = "flickr.interestingness.getList"
}


    


private  func flickrURL(method: Method, parameters: [String : String]?) -> URL {
   
    var components = URLComponents(string: FlickrAPI.baseURLString)!
    var queryItems = [URLQueryItem]()
    
    let baseParams = [
        "method" : method.rawValue,
        "format" : "json",
        "nonjsoncallback" : "1",
        "api_key" : FlickrAPI.apiKey
    ]
    
    
    for (key,value) in baseParams {
        let item = URLQueryItem(name: key, value: value)
        queryItems.append(item)
    }
    
   
    
    
    
    if let addtionalParams = parameters{
        for (key,value) in addtionalParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
    }
    components.queryItems = queryItems
    
    return components.url!
}

var interestingPhotosURL: URL {
    return flickrURL(method: .interstingPhotos, parameters: ["extras" : "url_h, date_taken"])
}

func photos(fromJson data: Data) -> PhotosResult {
    do {
        let jsonObeject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard
        let jsonDictionary = jsonObeject as? [AnyHashable: Any],
        let photos = jsonDictionary["photos"] as? [String: Any],
            let photosArray = photos["photo"] as? [[String: Any]] else{
                return .failure(FlickrError.invalidJSONdata)
        }
        var finalPhotos = [Photo]()
        for photoJSON in photosArray {
            if let photo = photo(fromJSON: photoJSON){
                finalPhotos.append(photo)
            }
        }
        
        if finalPhotos.isEmpty && !photosArray.isEmpty{
            return .failure(FlickrError.invalidJSONdata)
        }
        
        
        return.success(finalPhotos)
    
    }catch let error{
        return.failure(error)
    }
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()



func photo(fromJSON json: [String : Any]) -> Photo? {
    guard
    let photoID = json["id"] as? String,
    let title = json["title"] as? String,
    let dateString = json["datetaken"] as? String,
    let photoURLString = json["url_h"] as? String,
        let url = URL(string: photoURLString),
        let dateTaken = dateFormatter.date(from: dateString) else {
            return nil
    }
return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
}


