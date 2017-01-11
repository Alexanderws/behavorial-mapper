//
//  GMapsVC.swift
//  Behavorial Mapper
//
//  Created by Espen on 11/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class GMapsVC: UINavigationController {
    
    private let APIKEY = "AIzaSyAWl80sWS2kbP-REQex8HK5FL6bM1DxgVE"
    private var _camera = GMSCameraPosition.camera(withLatitude: 58.938100, longitude: 5.693730, zoom: 15) // UIS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: _camera)
        self.view = mapView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
