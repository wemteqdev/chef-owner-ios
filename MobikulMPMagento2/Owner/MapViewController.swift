//
//  MapViewController.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/25/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    var customerAddress:String!;
    var supplierAddress:String!;
    var customerName:String!;
    var supplierName:String!;
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "back_color"), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationItem.title = customerName;
        
        var customerPosition: GMSCameraPosition!;
        var supplierPosition: GMSCameraPosition!;
        if(self.customerAddress != nil){
            getCoordinate(addressString: self.customerAddress){
                (location: CLLocationCoordinate2D, error: NSError?) in
                if(error == nil){
                    customerPosition = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 16.0)
                    self.showMarker(position: customerPosition.target, mapType: 0)
                } else {
                    //let AC = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
                    let AC = UIAlertController(title: "Error", message: "Wrong Address", preferredStyle: .alert)
                    let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "ok"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(noBtn)
                    self.parent!.present(AC, animated: true, completion: {  })
                }
            }
        }
        if(self.supplierAddress != nil){
            getCoordinate(addressString: self.supplierAddress){
                (location: CLLocationCoordinate2D, error: NSError?) in
                if(error == nil){
                    supplierPosition = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 16.0)
                    self.mapView.camera = supplierPosition
                    self.showMarker(position: supplierPosition.target, mapType: 1)
                    //self.circle(position: supplierPosition.target)
                } else {
                    //let AC = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: .alert)
                    let AC = UIAlertController(title: "Error", message: "Wrong Address", preferredStyle: .alert)
                    let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "ok"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(noBtn)
                    self.parent!.present(AC, animated: true, completion: {  })
                }
            }
        }
    }
    
    func circle(position: CLLocationCoordinate2D){
        let circleCenter = CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude)
        
        let circ = GMSCircle(position: circleCenter, radius: 200)
        circ.fillColor = UIColor(red: 30/255, green: 167/255, blue: 241/255, alpha: 0.2);
        circ.strokeColor = UIColor(red: 30/255, green: 167/255, blue: 241/255, alpha: 0.2);
        circ.strokeWidth = 1
        circ.map = mapView
    }
    
    func showMarker(position: CLLocationCoordinate2D, mapType: Int){
        let marker = GMSMarker()
        marker.position = position
        if(mapType == 0) {//customer
            marker.title = self.customerName
            marker.snippet = self.customerAddress
        } else {
            marker.title = self.supplierName
            marker.snippet = self.supplierAddress
        }
        marker.map = self.mapView
    }
}
extension MapViewController: GMSMapViewDelegate{
    
}
