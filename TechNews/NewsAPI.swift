//
//  NewsAPI.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/19/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

internal class NewsAPIClient {
    internal static func sampleGet(completion: @escaping (Any) -> ()) {
        let url = URL(string: "https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=\(newsAPIKey)")!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = data {
                print("DATA: \(data)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("JSON: \(json)")
                    completion(json)
                } catch {
                    print("Uh-oh.")
                }
                
            }
            if let response = response {
                print("RESPONSE: \(response)")
                
            }
            if let error = error {
                print("ERROR: \(error)")
            }
        }
        
        task.resume()
    }
    
    internal static func getStories(from source: String, andThen completion: @escaping (Any?, NewsAPIError?) -> ()) {
        let url = URL(string: "https://newsapi.org/v1/articles?source=\(source)&sortBy=latest&apiKey=\(newsAPIKey)")!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let response = response {
                print("RESPONSE: \(response)")
            }
            
            if let data = data {
                print("DATA: \(data)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("JSON: \(json)")
                    completion(json, nil)
                } catch {
                    print("Uh-oh.")
                    completion(nil, NewsAPIError.badData)
                }
                
            } else if let error = error {
                print("ERROR: \(error)")
                completion(nil, NewsAPIError.badResponse)
            } else {
                completion(nil, NewsAPIError.badResponse)
            }
        }
        
        task.resume()
    }
    
    internal static func articlesFrom(json: Any) -> [[String:Any]] {
        guard let jsonDictionary = json as? [String:Any] else { return [] }
        guard let articles = jsonDictionary["articles"] as? [[String:Any]] else { return [] }
        
        return articles
    }
    
    internal static func sourceFrom(json: Any) -> String {
        guard let jsonDictionary = json as? [String:Any] else { return "" }
        guard let source = jsonDictionary["source"] as? String else { return "" }
        
        return source
    }
}

enum NewsAPIError {
    case badResponse
    case badData
}
