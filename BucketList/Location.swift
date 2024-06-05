//
//  Location.swift
//  BucketList
//
//  Created by surya sai on 30/05/24.
//

import Foundation
import MapKit


struct Location:Codable,Equatable,Identifiable {
    let id:UUID
    var name:String
    var descriptor:String
    var latitude:Double
    var longitude:Double
    var coordinate:CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs:Location,rhs:Location) ->Bool {
        lhs.id == rhs.id||(lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
    
}
