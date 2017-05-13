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


protocol GMapsVCDelegate {
    func getProjectName() -> String

    func getScreenShot(image: UIImage)
}

class GMapsVC: UIViewController, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate {
        
    private var _camera = GMSCameraPosition.camera(withLatitude: 58.938100, longitude: 5.693730, zoom: 15) // UIS
    private var _mapView = GMSMapView()
    
    private let _toolBarHeight: CGFloat = 50.0

    private var _typeButtons = [UIBarButtonItem]()
    
    var delegate: GMapsVCDelegate?
    
    @IBOutlet weak var _toolBar: UIToolbar!
    @IBOutlet weak var _searchButton: UIBarButtonItem!
    @IBOutlet weak var _screenshotButton: UIBarButtonItem!
    @IBOutlet weak var _cancelButton: UIBarButtonItem!
    @IBOutlet weak var _typeNormalButton: UIBarButtonItem!
    @IBOutlet weak var _typeSatelliteButton: UIBarButtonItem!
    @IBOutlet weak var _typeHybridButton: UIBarButtonItem!
    @IBOutlet weak var _typeTerrainButton: UIBarButtonItem!
    
    @IBOutlet weak var _leftBorder: UIView!
    @IBOutlet weak var _rightBorder: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _toolBar.barTintColor = Style.backgroundPrimary
        _searchButton.tintColor = Style.textPrimary
        
        _leftBorder.layer.borderWidth = 1
        _leftBorder.layer.borderColor = Style.textPrimary.cgColor
        _leftBorder.alpha = 0.5
        _rightBorder.layer.borderWidth = 1
        _rightBorder.layer.borderColor = Style.textPrimary.cgColor
        _rightBorder.alpha = 0.5
        
        _mapView = GMSMapView.map(withFrame: self.view.bounds, camera: _camera)
        self.view.insertSubview(_mapView, at: 0)
        
        _screenshotButton.style = .done
        _screenshotButton.tintColor = Style.textPrimary
        _screenshotButton.title = "Create Background"
        _screenshotButton.action = #selector(GMapsVC.takeScreenshot)

        _typeNormalButton.style = .plain
        _typeNormalButton.tintColor = Style.textPrimary
        _typeNormalButton.title = "Normal"
        _typeNormalButton.tag = Int(GMSMapViewType.normal.rawValue)
        _typeNormalButton.target = self
        _typeNormalButton.action = #selector(setMapType(withSender:))

        _typeSatelliteButton.style = .plain
        _typeSatelliteButton.tintColor = Style.textPrimary
        _typeSatelliteButton.title = "Satellite"
        _typeSatelliteButton.tag = Int(GMSMapViewType.satellite.rawValue)
        _typeSatelliteButton.target = self
        _typeSatelliteButton.action = #selector(setMapType(withSender:))

        _typeHybridButton.style = .plain
        _typeHybridButton.tintColor = Style.textPrimary
        _typeHybridButton.title = "Hybrid"
        _typeHybridButton.tag = Int(GMSMapViewType.hybrid.rawValue)
        _typeHybridButton.target = self
        _typeHybridButton.action = #selector(setMapType(withSender:))

        _typeTerrainButton.style = .plain
        _typeTerrainButton.tintColor = Style.textPrimary
        _typeTerrainButton.title = "Terrain"
        _typeTerrainButton.tag = Int(GMSMapViewType.terrain.rawValue)
        _typeTerrainButton.target = self
        _typeTerrainButton.action = #selector(setMapType(withSender:))

        _typeButtons.append(_typeNormalButton)
        _typeButtons.append(_typeSatelliteButton)
        _typeButtons.append(_typeHybridButton)
        _typeButtons.append(_typeTerrainButton)
        
        _cancelButton.style = .done
        _cancelButton.title = "Cancel"
        _cancelButton.tintColor = Style.textPrimary
        _cancelButton.action = #selector(GMapsVC.cancelButtonClicked)
        
        _mapView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin,
                                     .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setMapType(withSender sender: UIBarButtonItem) {
        _mapView.mapType = GMSMapViewType(rawValue: UInt(sender.tag)) ?? GMSMapViewType.normal
    }

    func takeScreenshot() {
        _toolBar.isHidden = true
        let image = self.view.snapshot(of: CGRect(x: 100, y: 0, width: 824, height: 768))
        _toolBar.isHidden = false
        delegate?.getScreenShot(image: image!)
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
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
}
