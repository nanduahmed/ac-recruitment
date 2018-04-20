//
//  NetworkManager.swift
//  Realtor
//
//  Created by Nandu Ahmed on 4/4/18.
//  Copyright © 2018 Baabul Ilm. All rights reserved.
//

import UIKit
import Foundation

typealias NetworkCompletionType = (_ success:Bool, _ data:[String:Any]?,  [Place]?) -> (Void)

class NetworkManager {
 
    static var shared = NetworkManager()
    
    func getData(values:String, completion:@escaping NetworkCompletionType)  {
        
        //Convert Space in address to +
        let address = values.replacingOccurrences(of: " ", with: "+")
        
        let apiKey = "AIzaSyBB4wCIVJbzyg_Fg_uTie8AtLp6Mg8_SYU"
        let url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&sensor=false&key=\(apiKey)"
        let aUrl = URL.init(string: url)
        
        let task = URLSession.shared.dataTask(with: aUrl!) { (data, resp, error) in
            if error != nil {
                print(error ?? "error")
                completion(false, nil, nil)
            } else {
                if let usableData = data {
                    print(usableData) //JSONSerialization
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                        
                        Models.shared.create(data: json!)
                        completion(true, json, Models.shared.all)
                    }
                }
            }

        }
        task.resume()
        
    }

}
