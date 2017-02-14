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

    
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var menuView: StartScreenMenu!
    @IBOutlet weak var leftSideView: UIView!
    @IBOutlet weak var rightSideTableView: UITableView!
    @IBOutlet weak var createProjectBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStyle()
    }

    func initStyle() {
        let proxyTextField = UITextField.appearance()
        let proxyTextView = UITextView.appearance()
        let proxyButton = UIButton.appearance()
        let proxyLabel = UILabel.appearance()
        
        proxyTextField.backgroundColor = Style.backgroundTextField
        proxyTextField.textColor = Style.textPrimary
        proxyTextField.placeHolderColor = Style.textSecondary
        proxyTextField.placeholder = "LOLOLOL"
        proxyTextView.backgroundColor = Style.backgroundTextField
        proxyTextView.textColor = Style.textPrimary
        proxyButton.setTitleColor(Style.textPrimary, for: .normal)
        proxyLabel.textColor = Style.textPrimary
        
        bkgView.backgroundColor = Style.backgroundSecondary
        menuView.backgroundColor = Style.backgroundPrimary
    }

    @IBAction func StartNewProjectPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreateProjectVC", sender: sender)
    }
    
    
    @IBAction func LoadProjectPressed(_ sender: Any) {
        
        
        
    }


}

