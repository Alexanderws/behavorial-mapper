//
//  ViewController.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class StartVC: UIViewController {

    private let _APIKEY = "AIzaSyAWl80sWS2kbP-REQex8HK5FL6bM1DxgVE"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GMSServices.provideAPIKey(_APIKEY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func StartNewProjectPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreateProjectVC", sender: sender)
    }
    
    
    @IBAction func LoadProjectPressed(_ sender: Any) {
        
        
        
    }


}

