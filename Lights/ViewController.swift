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
    
    let utils = Utils()
    
    //var indicator = UIActivityIndicatorView()
    
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lightDataArray = [LightData]()
        loadLights()
    }
    
    @IBAction func reloadLightsAction(_ sender: UIBarButtonItem) {
        loadLights()
    }
    
    @IBAction func onOffAction(_ sender: UIBarButtonItem) {
        for lightData: LightData in lightDataArray {
            if (lightData.reachable!) {
                self.lightAPi.turnLightOnOff(lightData: lightData)
            }
        }
        loadLights()
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
        loadLights()
    }
    
    func startIndicator() {
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        indicator.startAnimating()
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
    func loadLights() {
        if (utils.isConnectedToNetwork()) {
            startIndicator()
            self.lightAPi.loadLights(didLoadLightData)
        } else {
            let alert = UIAlertController(title: "No WI-FI", message: "No WI-FI connection!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Got It!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didLoadLightData(_ loadedLightData: [LightData]) {
        self.lightDataArray.removeAll()
        for light in loadedLightData {
            self.lightDataArray.append(light)
        }
        tableView.reloadData()
        stopIndicator()
    }
    
}
