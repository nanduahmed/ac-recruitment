//
//  Model.swift
//  Realtor
//
//  Created by Nandu Ahmed on 4/4/18.
//  Copyright © 2018 Baabul Ilm. All rights reserved.
//

import Foundation
import CoreLocation


enum PlacesStatus:String {
    case Ok = "OK"
    case ZeroResults = "ZERO_RESULTS"
    case Unknown
}

class Place {
    var address:String?
    var coordinates:CLLocationCoordinate2D?
}


class Models {
    
    static var shared = Models()
    
    var all:[Place] = [Place]()
    var status:PlacesStatus = .Unknown
    
    public func create(data:[String:Any]) {
        self.all.removeAll()
        if let content = data["results"] as? [Any] , let status = data["status"] as? String {
            for item in content {
                if let itemDict = item as? [String:Any] ,
                    let add = itemDict["formatted_address"] as? String,
                    let geometryItem = itemDict["geometry"] as? [String:Any] ,
                    let location = geometryItem["location"] as? [String:Any] ,
                    let lat = location["lat"] as? CLLocationDegrees ,
                    let long = location["lng"] as? CLLocationDegrees {
                    
                    let model = Place()
                    model.address = add
                    model.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    
                    self.all.append(model)
                }
            }
            if (status == PlacesStatus.Ok.rawValue) {
                self.status = .Ok
            } else if (status == PlacesStatus.ZeroResults.rawValue ) {
                self.status = .ZeroResults
            }
        }
    }
    
    init() {
        self.status = .Unknown
    }
    
}
