//
//  LightData.swift
//  Lights
//
//  Created by Eduardo Andrade on 27/09/16.
//  Copyright © 2016 Eduardo Andrade. All rights reserved.
//

import Foundation

class LightData {
    
    var id : String!
    var name : String!
    var bri : Int!
    var hue : Int!
    var sat : Int!
    var on : Bool!
    var reachable : Bool!
    
    init(id : String, data : NSDictionary) {
        self.id = id
        self.name = getStringFromJSON(data, key: "name")
        self.bri = data.value(forKeyPath: "state.bri") as! Int
        self.hue = data.value(forKeyPath: "state.hue") as! Int
        self.sat = data.value(forKeyPath: "state.sat") as! Int
        self.on = data.value(forKeyPath: "state.on") as! Bool
        self.reachable = data.value(forKeyPath: "state.reachable") as! Bool
    }
    
    func getStringFromJSON(_ data: NSDictionary, key: String) -> String {
        if let info = data[key] as? String {
            return info
        }
        return ""
    }
    
}
