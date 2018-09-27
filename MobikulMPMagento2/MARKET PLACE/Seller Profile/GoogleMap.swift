//
//  GoogleMap.swift
//  MobikulOpencartMp
//
//  Created by Webkul on 11/09/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMap: UIViewController,GMSMapViewDelegate {
var countryName:String = ""
    
public var longitude:Double = 12.01
public var latitude:Double = 11.01

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let post = NSMutableString();
        let urlString = countryName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        post .appendFormat("http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", urlString!)
        guard let requestUrl = URL(string:post as String) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: usableData, options:JSONSerialization.ReadingOptions()) as (AnyObject)
                    var googleJson:JSON = JSON(json);
                    var dict = googleJson["results"][0];
                    self.latitude = dict["geometry"]["location"]["lat"].doubleValue
                    print("ssss", dict)
                    self.longitude = dict["geometry"]["location"]["lng"].doubleValue
                    DispatchQueue.main.async {
                        let camera = GMSCameraPosition.camera(withLatitude:self.latitude, longitude: self.longitude, zoom: 8)
                        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
                        mapView.delegate = self
                        self.view.addSubview(mapView)
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude:self.longitude)
        
                        marker.map = mapView
                    }
                    
                }catch {
                    print(error)
                }
            }
        }
        task.resume()
        
        
       
    }

    }
