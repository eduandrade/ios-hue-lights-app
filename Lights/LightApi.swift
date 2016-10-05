//
//  LightApi.swift
//  Lights
//
//  Created by Eduardo Andrade on 29/09/16.
//  Copyright © 2016 Eduardo Andrade. All rights reserved.
//

import Foundation

class LightApi {
    
    var apiUrl : String!
    
    let restClient = RestClient()
    
    func getApiUrl() -> String {
        return "http://192.168.0.15/api/k733vjvJqHk1fN0ZN6krLFkvaWtUPCItWCS0oYqD"
    }
    
    func loadLights(_ completion: (([LightData]) -> Void)!) {
        //TODO pegar IP https://www.meethue.com/api/nupnp
        let lightsApiAddress = getApiUrl() + "/lights"
        let session = URLSession.shared
        let lightsUrl = URL(string: lightsApiAddress)
        let task = session.dataTask(with: lightsUrl!, completionHandler: {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                var lightDataArray = [LightData]()
                do {
                    let lightArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    for light in lightArray {
                        let lightData = LightData(id: light.key as! String, data: light.value as! NSDictionary)
                        lightDataArray.append(lightData)
                    }
                } catch {
                    print("Fetch failed: \((error as NSError).localizedDescription)")
                }
                
                let priority = DispatchQueue.GlobalQueuePriority.default
                DispatchQueue.global(priority: priority).async {
                    DispatchQueue.main.async {
                        completion(lightDataArray)
                    }
                }
            }
        })
        task.resume()
    }
    
    func changeLightColor(lightData: LightData) {
        let lightsApiAddress = getApiUrl() + "/lights/" + lightData.id! + "/state"
        let body = "{\"on\":true, \"sat\":254, \"bri\":254, \"hue\":" + String(generateHueColorNumber()) + "}"
        if (lightData.reachable!) {
            restClient.put(url: lightsApiAddress, requestBody: body)
        }
    }
    
    func turnLightOnOff(lightData: LightData) {
        let lightsApiAddress = getApiUrl() + "/lights/" + lightData.id! + "/state"
        var body = "{\"on\":true, \"sat\":254, \"bri\":254, \"hue\":" + String(generateHueColorNumber()) + "}"
        if (lightData.reachable!) {
            if (lightData.on!) {
                body = "{\"on\":false}"
            }
            restClient.put(url: lightsApiAddress, requestBody: body)
        }
    }
    
    func generateHueColorNumber() -> UInt32 {
        let lower : UInt32 = 1
        let upper : UInt32 = 65535
        return arc4random_uniform(upper - lower) + lower
    }
    
}
