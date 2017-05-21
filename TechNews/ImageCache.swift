//
//  ImageCache.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/21/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class ImageCache {
    private var urlToImage: [String : UIImage] = [:]
    private static let defaultImage = UIImage()
    
    internal static func getImage(from url: String, completion: @escaping (UIImage) -> ()) {
        if let cachedImage = sharedImageCache.urlToImage[url] {
            OperationQueue.main.addOperation {
                completion(cachedImage)
            }
        } else {
            retrieveImage(from: url, completion: { (image) in
                OperationQueue.main.addOperation {
                    completion(image)
                }
            })
        }
    }
    
    private static func retrieveImage(from url: String, completion: @escaping (UIImage) -> ()) {
        guard let verifiedURL = URL(string: url) else { completion(defaultImage); return }
        
        let task = URLSession.shared.dataTask(with: verifiedURL) { (data, response, error) in
            guard error == nil else { print("ERROR: \(String(describing: error))"); completion(defaultImage); return }
            
            if let response = response {
                print("RESPONSE: \(response)")
            }
            
            guard let data = data else { print("INVALID IMAGE DATA"); completion(defaultImage); return }
            guard let image = UIImage(data: data) else { print("INVALID IMAGE DATA"); completion(defaultImage); return }
            
            sharedImageCache.urlToImage[url] = image
            completion(image)
        }
        
        task.resume()
    }
}

fileprivate let sharedImageCache = ImageCache()
