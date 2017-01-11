//
//  GMapsVC.swift
//  Behavorial Mapper
//
//  Created by Espen on 11/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class GMapsVC: UIViewController {
        
    private var _camera = GMSCameraPosition.camera(withLatitude: 58.938100, longitude: 5.693730, zoom: 15) // UIS
    
    private let _toolBarHeight: CGFloat = 50.0
    private var _toolBarItems = [UIBarButtonItem]()
    
    private var _toolBar = UIToolbar()
    private var _screenshotButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: _camera)
        self.view = mapView
        
        _toolBar = UIToolbar(frame: CGRect.init(x: 0,
                                                y: self.view.bounds.height-_toolBarHeight,
                                                width: self.view.bounds.width,
                                                height: _toolBarHeight))
        
        _screenshotButton = UIBarButtonItem(title: "Take Screenshot",
                                            style: UIBarButtonItemStyle.plain,
                                            target: self,
                                            action: #selector(takeScreenshot))
        
        _toolBarItems.append(_screenshotButton)
        _toolBar.setItems(_toolBarItems, animated: false)
        self.view.insertSubview(_toolBar, at: 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // This function dismissed the GMapsVC
    // TODO: Check where screenshot should be saved
    func takeScreenshot() {
        _toolBar.isHidden = true
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let data = UIImagePNGRepresentation(image!)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let imagePath = paths[0].appendingPathComponent("map.png")
        try? data?.write(to: imagePath)
        print(image?.size ?? 0)
        UIGraphicsEndImageContext()
        _toolBar.isHidden = false
        
        
        if let vc = self.presentingViewController as? CreateProjectVC {
            vc.createMapButton.setImage(image!, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
