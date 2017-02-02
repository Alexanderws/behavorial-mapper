//
//  CreateProjectVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 09/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class CreateProjectVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var projectNameTxtFld: UITextField!
    @IBOutlet weak var projectNotesTxtView: UITextView!
    
    @IBOutlet weak var loadPictureButton: UIButton!
    @IBOutlet weak var createMapButton: UIButton!
    @IBOutlet weak var blankBackgroundButton: UIButton!
    
    @IBOutlet weak var legendNameTxtFld: UITextField!
    @IBOutlet weak var legendIconImage: UIButton!
    
    @IBOutlet weak var legendTableView: UITableView!

    
    var legendArray = [Legend]()
    var selectedIconId = 0
    
    
    
    
    private var project: Project!
    private var projectName: String!
    private var projectNote: String!
    private var projectBackground: UIImage!
    
    private var _mapScreenshot = UIImage()
    private var _backgroundImage = UIImage()
    
    private var _chosenBackground = BACKGROUND_BLANK
    
    var chosenBackground: Int {
        get {
            return _chosenBackground
        } set {
            _chosenBackground = newValue
        }
    }
    
    var backgroundImage: UIImage {
        get {
            return _backgroundImage
        } set {
            _backgroundImage = newValue
        }
    }
    
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
                legendNameTxtFld.text = ""
                updateLegendList()
            }
        } else {
            warningMessage(title: NO_LEGEND_NAME_TITLE, message: NO_LEGEND_NAME_MSG)
        }
    }
    
    func updateLegendList() {
        self.legendTableView.reloadData()
    }
    
    func createProject() -> Bool {
        if containsText(object: projectNameTxtFld) {
            projectName = projectNameTxtFld.text!
        } else {
            warningMessage(title: NO_PROJECT_NAME_TITLE, message: NO_PROJECT_NAME_MSG)
            return false
        }
        if legendArray.count < 1 {
            warningMessage(title: NO_LEGEND_ENTERED_TITLE, message: NO_LEGEND_ENTERED_MSG)
            return false
        }
        if containsText(object: projectNotesTxtView) {
            projectNote = projectNotesTxtView.text!
        } else {
            projectNote = ""
        }
        
        setBackground()
        
        project = Project(name: projectName, background: projectBackground, legend: legendArray, note: projectNote)
        return true
    }
    
    func setBackground() {
        switch chosenBackground {
        case BACKGROUND_GOOGLE_MAPS:
            projectBackground = _backgroundImage
        case BACKGROUND_IMAGE_UPLOADED:
            projectBackground = _backgroundImage
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
        if createProject() {
            performSegue(withIdentifier: "showDetailMappingVC", sender: sender)
        }
    }
    
    @IBAction func uploadImagePressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
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
    
    func updateImageButtons() {
        loadPictureButton.setImage(UIImage(named: BACKGROUND_IMAGE_UPLOADED_STRING), for: .normal)
        createMapButton.setImage(UIImage(named: BACKGROUND_GOOGLE_MAPS_STRING), for: .normal)
        // TO DO: blankBackgroundButton.setImage(UIImage(named: BACKGROUND_BLANK_STRING), for: .normal)
        switch chosenBackground {
        case BACKGROUND_IMAGE_UPLOADED:
            loadPictureButton.setImage(backgroundImage, for: .normal)
        case BACKGROUND_GOOGLE_MAPS:
            createMapButton.setImage(backgroundImage, for: .normal)
        case BACKGROUND_BLANK: break
            // TO DO: blankBackgroundButton.setImage(UIImage(named: BACKGROUND_BLANK_STRING), for: .normal)
        default: break
            // TO DO: blankBackgroundButton.setImage(UIImage(named: BACKGROUND_BLANK_STRING), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMappingVC" {
            if let mappingVC = segue.destination as? MappingVC {
                mappingVC.project = project
            }
        }
    }
    
    // IMAGE PICKER FUNCTIONS
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        chosenBackground = BACKGROUND_IMAGE_UPLOADED
        backgroundImage = newImage
        updateImageButtons()
        dismiss(animated: true)
    }
    
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = legendTableView.dequeueReusableCell(withIdentifier: "LegendCell", for: indexPath) as! LegendCell
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
