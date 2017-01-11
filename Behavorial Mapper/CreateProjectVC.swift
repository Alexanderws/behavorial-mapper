//
//  CreateProjectVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 09/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class CreateProjectVC: UIViewController {

    var legendArray = [Legend]()
    var selectedIconId = nil
    
    
    
    @IBOutlet weak var projectNameTxtFld: UITextField!
    @IBOutlet weak var projectNotesTxtView: UITextView!
    
    @IBOutlet weak var loadPictureButton: UIButton!
    @IBOutlet weak var createMapButton: UIButton!
    @IBOutlet weak var blankBackgroundButton: UIButton!
    
    @IBOutlet weak var legendNameTxtFld: UITextField!
    @IBOutlet weak var legendIconImage: UIButton!
    
    @IBOutlet weak var legendTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    func enterLegendIcon(iconId: Int) {
        legendIconImage.setTitle("", for: .normal)
        legendIconImage.setImage(UIImage(named: "\(iconId)"), for: .normal)
        selectedIconId = iconId
    }
    
    func addLegend() {
//        if selectedIcon != nil {
//            
//            if let legendName = legendNameTxtFld.text {
//            
//            }
//        }
    }
    
    @IBAction func legendIconPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func legendAddPressed(_ sender: Any) {
        addLegend()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPressed(_ sender: Any) {
        
    }
    
    func checkInputs() -> String {
        return ""
    }
    
    func checkLegendList() -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverIconSelectVC" {
            let vc = segue.destination as! IconSelectVC
            vc.preferredContentSize = CGSize(width: 260, height: 140)
        }
    }


}
