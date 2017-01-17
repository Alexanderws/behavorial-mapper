//
//  CreateProjectVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 09/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class CreateProjectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var legendArray = [Legend]()
    var selectedIconId = 0
    
    private var project: Project!
    private var projectName: String!
    private var projectNote: String!
    private var projectBackground: UIImage!
    
    private var _mapScreenshot = UIImage()
    private var _uploadedImage = UIImage()
    
    private var chosenBackground = BACKGROUND_BLANK
    
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

        legendTableView.delegate = self
        legendTableView.dataSource = self
        
    }

    
    
    func enterLegendIcon(iconId: Int) {
        legendIconImage.setTitle("", for: .normal)
        legendIconImage.setImage(UIImage(named: "\(iconId)"), for: .normal)
        selectedIconId = iconId
    }
    
    func addLegend() {
        if legendNameTxtFld.hasText {
        
            if let name = legendNameTxtFld.text {
                let legend = Legend(name: name, icon: selectedIconId)
                legendArray.append(legend)
                updateLegendList()
            }
        } else {
            warningMessage(title: NO_LEGEND_NAME_TITLE, message: NO_LEGEND_NAME_MSG)
        }
    }
    
    func updateLegendList() {
        self.legendTableView.reloadData()
    }
    
    func createProject() {
        if let name = projectNameTxtFld.text {
            projectName = name
        } else {
            warningMessage(title: NO_PROJECT_NAME_TITLE, message: NO_PROJECT_NAME_MSG)
            return
        }
        if legendArray.count < 1 {
            warningMessage(title: NO_LEGEND_ENTERED_TITLE, message: NO_LEGEND_ENTERED_MSG)
            return
        }
        if let note = projectNotesTxtView.text {
            projectNote = note
        } else {
            projectNote = ""
        }
        
        project = Project(name: projectName, background: projectBackground, legend: legendArray, note: projectNote)
    }
    
    func setBackground() {
        switch chosenBackground {
        case BACKGROUND_GOOGLE_MAPS:
            projectBackground = _mapScreenshot
        case BACKGROUND_IMAGE_UPLOADED:
            projectBackground = _uploadedImage
        default:
            projectBackground = getWhiteBackground(width: 2000, height: 2000)
        }
    }
    
    func warningMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: ALERT_CANCEL_TITLE, style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func legendIconPressed(_ sender: UIButton) {
        //Segue to IconSelectVC
    }
    
    @IBAction func legendAddPressed(_ sender: UIButton) {
        addLegend()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func createMapPressed(sender: UIButton) {
        performSegue(withIdentifier: "GMapsSegue", sender: sender)
    }
    
    func checkInputs() -> String {
        return ""
    }
    
    func checkLegendList() -> Bool {
        return false
    }
    
    
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = legendTableView.dequeueReusableCell(withIdentifier: "CreateLegendCell", for: indexPath) as! CreateLegendCell
        cell.configureCell(legend: legendArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return legendArray.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "X") { action, index in
            self.legendArray.remove(at: indexPath.row)
            self.legendTableView.reloadData()
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }

}
