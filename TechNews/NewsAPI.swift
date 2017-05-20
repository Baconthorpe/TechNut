//
//  NewsAPI.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/19/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

internal class NewsAPIClient {
    internal static func sampleGet(completion: @escaping () -> ()) {
        let url = URL(string: "https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=\(newsAPIKey)")!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = data {
                print("DATA: \(data)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("JSON: \(json)")
                    completion()
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
        
//        let url = URL(string: "https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/SWA/1936/arr/2017/4/19")!
//        
//        let request = NSMutableURLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("91b929e6", forHTTPHeaderField: "appId")
//        request.setValue("2eebba75c50ce13c31b9ef0b331fb93a", forHTTPHeaderField: "appKey")
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//            if let data = data {
//                print("DATA: \(data)")
//                
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print("JSON: \(json)")
//                } catch {
//                    print("Uh-oh.")
//                }
//                
//            }
//            if let response = response {
//                print("RESPONSE: \(response)")
//                
//            }
//            if let error = error {
//                print("ERROR: \(error)")
//            }
//        }
//        task.resume()
    }
}
