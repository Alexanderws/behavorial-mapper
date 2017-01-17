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
    
    @IBOutlet weak var _toolBar: UIToolbar!
    @IBOutlet weak var _screenshotButton: UIBarButtonItem!
    @IBOutlet weak var _cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: _camera)
        self.view.insertSubview(mapView, at: 0)
        
        _screenshotButton.style = .done
        _screenshotButton.title = "Take Screenshot"
        _screenshotButton.action = #selector(GMapsVC.takeScreenshot)
        
        _cancelButton.style = .done
        _cancelButton.title = "Cancel"
        _cancelButton.tintColor = UIColor.red
        _cancelButton.action = #selector(GMapsVC.cancelButtonClicked)
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
        UIGraphicsEndImageContext()
        _toolBar.isHidden = false
        
        
        if let vc = self.presentingViewController as? CreateProjectVC {
            vc.createMapButton.setImage(image!, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
}
