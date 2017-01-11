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
    var selectedColor = 0
    var selectedIcon = 0
    
    
    @IBOutlet weak var projectNameTxtFld: UITextField!
    @IBOutlet weak var projectNotesTxtView: UITextView!
    
    @IBOutlet weak var loadPictureButton: UIButton!
    @IBOutlet weak var createMapButton: UIButton!
    @IBOutlet weak var blankBackgroundButton: UIButton!
    
    @IBOutlet weak var legendNameTxtFld: UITextField!
    @IBOutlet weak var legendIconImage: UIButton!
    @IBOutlet weak var legendColorImage: UIButton!
    
    @IBOutlet weak var legendTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func legendIconPressed(_ sender: Any) {
        
    }
    
    @IBAction func legendColorPressed(_ sender: Any) {
        
    }
    
    @IBAction func legendAddPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPressed(_ sender: Any) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
