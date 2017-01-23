//
//  GMapsVC.swift
//  Behavorial Mapper
//
//  Created by Espen on 11/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GMapsVC: UIViewController, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate {
        
    private var _camera = GMSCameraPosition.camera(withLatitude: 58.938100, longitude: 5.693730, zoom: 15) // UIS
    private var _mapView = GMSMapView()
    
    private let _toolBarHeight: CGFloat = 50.0
    
    @IBOutlet weak var _toolBar: UIToolbar!
    @IBOutlet weak var _screenshotButton: UIBarButtonItem!
    @IBOutlet weak var _cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _mapView = GMSMapView.map(withFrame: self.view.bounds, camera: _camera)
        self.view.insertSubview(_mapView, at: 0)
        
        _screenshotButton.style = .done
        _screenshotButton.title = "Take Screenshot"
        _screenshotButton.action = #selector(GMapsVC.takeScreenshot)
        
        _cancelButton.style = .done
        _cancelButton.title = "Cancel"
        _cancelButton.tintColor = UIColor.red
        _cancelButton.action = #selector(GMapsVC.cancelButtonClicked)
        
        _mapView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin,
                                     .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
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
        /* Uncomment to save screenshot
         *
        let data = UIImagePNGRepresentation(image!)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let imagePath = paths[0].appendingPathComponent("map.png")
        try? data?.write(to: imagePath)
         */
        UIGraphicsEndImageContext()
        _toolBar.isHidden = false
        
        
        if let vc = self.presentingViewController as? CreateProjectVC {
            vc.createMapButton.setImage(image!, for: .normal)
            vc.chosenBackground = BACKGROUND_GOOGLE_MAPS
            vc.mapScreenShot = image!
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        _camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                           longitude: place.coordinate.longitude,
                                           zoom: 15)
        self._mapView.camera = _camera
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
        print("Error: \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func searchLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        self.present(autocompleteController, animated: true, completion: nil)
    }
}