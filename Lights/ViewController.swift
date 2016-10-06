//
//  ViewController.swift
//  Lights
//
//  Created by Eduardo Andrade on 14/09/16.
//  Copyright © 2016 Eduardo Andrade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var lightDataArray : [LightData]!
    
    let lightAPi = LightApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lightDataArray = [LightData]()
        
        let utils = Utils()
        if (utils.isConnectedToNetwork()) {
            self.lightAPi.loadLights(didLoadLightData)
        } else {
            let alert = UIAlertController(title: "No WI-FI", message: "No WI-FI connection!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Got It!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func reloadLightsAction(_ sender: UIBarButtonItem) {
        self.lightAPi.loadLights(didLoadLightData)
    }
    
    @IBAction func onOffAction(_ sender: UIBarButtonItem) {
        for lightData: LightData in lightDataArray {
            if (lightData.reachable!) {
                self.lightAPi.turnLightOnOff(lightData: lightData)
            }
        }
        self.lightAPi.loadLights(didLoadLightData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (lightDataArray?.isEmpty)! {
            return 0
        }
        return lightDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont(name:"Avenir", size:22)
        let lightData = lightDataArray[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = lightData.name
        if (lightData.reachable!) {
            if (lightData.on!) {
                cell.detailTextLabel?.text = "On (" + String(lightData.hue) + ")"
            } else {
                cell.detailTextLabel?.text = "Off"
            }
        } else {
            cell.contentView.backgroundColor = UIColor.red
            cell.detailTextLabel?.text = "Not reachable!"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let lightData = lightDataArray[(indexPath as NSIndexPath).row]
        self.lightAPi.changeLightColor(lightData: lightData)
        self.lightAPi.loadLights(didLoadLightData)
    }
    
    func didLoadLightData(_ loadedLightData: [LightData]) {
        self.lightDataArray.removeAll()
        for light in loadedLightData {
            self.lightDataArray.append(light)
        }
        tableView.reloadData()
    }
    
}
