//
//  PostViewController.swift
//  NearBoddy
//
//  Created by 岡本　優河 on 2018/07/15.
//  Copyright © 2018年 岡本　優河. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var NowlocationLabel:UILabel!
    
    var ido :Double!
    var keido:Double!
    var country:String = String()
    var administrativeArea:String = String()
    var subAdministrativeArea:String = String()
    var locality:String = String()
    var subLocality:String = String()
    var thoroughfare:String = String()
    var subThoroughfare:String = String()
    var address:String = String()

    var location:Location = Location()

    
     var locationManager : CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        catchLocationData()
      
       

    }


    func catchLocationData(){

        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }


    }


    /*******************************************

     //位置情報取得に関するアラートメソッド

     ********************************************/


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    /**********************************

     // 位置情報が更新されるたびに呼ばれるメソッド

     ***********************************/

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        ido = newLocation.coordinate.latitude
        keido = newLocation.coordinate.longitude
        self.reverseGeocode(latitude: ido!, longitude: keido!)

    }


    // 逆ジオコーディング処理(緯度・経度を住所に変換)
    func reverseGeocode(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemark, error) -> Void in
            let placeMark = placemark?.first
            if let country = placeMark?.country {


//                print("\(country)")

                self.country = country
            }
            if let administrativeArea = placeMark?.administrativeArea {
//                print("\(administrativeArea)")

                self.administrativeArea = administrativeArea
            }
            if let subAdministrativeArea = placeMark?.subAdministrativeArea {
//                print("\(subAdministrativeArea)")

                self.subAdministrativeArea = subAdministrativeArea

            }

            if let locality = placeMark?.locality {
//                print("\(locality)")

                self.locality = locality
            }
            if let subLocality = placeMark?.subLocality {
//                print("\(subLocality)")

                self.subLocality = subLocality
            }
            if let thoroughfare = placeMark?.thoroughfare {
//                print("\(thoroughfare)")

                self.thoroughfare = thoroughfare
            }
            if let subThoroughfare = placeMark?.subThoroughfare {
                print("\(subThoroughfare)")

                self.subThoroughfare = subThoroughfare
            }

            self.address = self.country + self.administrativeArea + self.subAdministrativeArea
                + self.locality + self.subLocality + self.thoroughfare
          
            self.NowlocationLabel.text = self.address
            print("住所　\(self.address)")
            
        })}

}
