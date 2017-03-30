//
//  CreateProjectVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 09/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateProjectVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GMapsVCDelegate {

    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var createProjectView: CreateProjectView!
    
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
    
    private var _backgroundImage = UIImage()
    private var _backgroundString = BACKGROUND_BLANK_STRING
    
    private var _chosenBackground = BACKGROUND_BLANK

    // TODO: START - Test Stuff !!!
    /*
    private var _visibleRegion: GMSVisibleRegion!

    var visibleRegion: GMSVisibleRegion {
        get {
            return _visibleRegion
        } set {
            _visibleRegion = newValue
        }
    }
    */
    // TODO: END - Test Stuff !!!
    
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
    
    var backgroundString: String {
        get {
            return _backgroundString
        } set {
            _backgroundString = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStyle()
        legendTableView.delegate = self
        legendTableView.dataSource = self
    }
    
    func initStyle() {
        createProjectView.backgroundColor = Style.backgroundPrimary
        bkgView.backgroundColor = Style.backgroundSecondary
        legendIconImage.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        legendIconImage.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        
        blankBackgroundButton.layer.borderWidth = 3
        blankBackgroundButton.layer.borderColor = Style.textPrimary.cgColor
        blankBackgroundButton.backgroundColor = Style.backgroundTextField
        createMapButton.layer.borderColor = Style.textPrimary.cgColor
        createMapButton.backgroundColor = Style.backgroundTextField
        loadPictureButton.layer.borderColor = Style.textPrimary.cgColor
        loadPictureButton.backgroundColor = Style.backgroundTextField
    }
    
    func enterLegendIcon(iconId: Int) {
        legendIconImage.setTitle("", for: .normal)
        legendIconImage.setImage(UIImage(named: "entryIcon\(iconId)"), for: .normal)
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
            displayMessage(title: NO_LEGEND_NAME_TITLE, message: NO_LEGEND_NAME_MSG, self: self)
        }
    }
    
    func updateLegendList() {
        self.legendTableView.reloadData()
    }
    
    func createProject() -> Bool {
        if containsText(object: projectNameTxtFld) {
            projectName = projectNameTxtFld.text!
        } else {
            displayMessage(title: NO_PROJECT_NAME_TITLE, message: NO_PROJECT_NAME_MSG, self: self)
            return false
        }
        if legendArray.count < 1 {
            displayMessage(title: NO_LEGEND_ENTERED_TITLE, message: NO_LEGEND_ENTERED_MSG, self: self)
            return false
        }
        if containsText(object: projectNotesTxtView) {
            projectNote = projectNotesTxtView.text!
        } else {
            projectNote = ""
        }
        if (chosenBackground != BACKGROUND_BLANK) {
            let data = UIImagePNGRepresentation(_backgroundImage)
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let mapDir = paths[0].appendingPathComponent("maps/")
            let imagePath = mapDir.appendingPathComponent("\(projectName!).map.png")
            _backgroundString = imagePath.absoluteString
            try? data?.write(to: imagePath)
        }
        project = Project(name: projectName, background: _backgroundString, legend: legendArray, note: projectNote, backgroundType: _chosenBackground)
        
        return true
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
    
    @IBAction func uploadImagePressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0, height: 0)
        imagePicker.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func createMapPressed(sender: UIButton) {
        performSegue(withIdentifier: "GMapsSegue", sender: sender)
    }
    
    @IBAction func blankBackgroundPressed(_ sender: Any) {
        chosenBackground = BACKGROUND_BLANK
        //backgroundString = BACKGROUND_BLANK_STRING
        updateImageButtons()
    }
    
    func updateImageButtons() {
        loadPictureButton.setImage(UIImage(named: BACKGROUND_IMAGE_UPLOADED_STRING), for: .normal)
        createMapButton.setImage(UIImage(named: BACKGROUND_GOOGLE_MAPS_STRING), for: .normal)
        loadPictureButton.layer.borderWidth = 0
        createMapButton.layer.borderWidth = 0
        blankBackgroundButton.layer.borderWidth = 0
        // TO DO: blankBackgroundButton.setImage(UIImage(named: BACKGROUND_BLANK_STRING), for: .normal)
        switch chosenBackground {
        case BACKGROUND_IMAGE_UPLOADED:
            loadPictureButton.setImage(_backgroundImage, for: .normal)
            loadPictureButton.layer.borderWidth = 3
        case BACKGROUND_GOOGLE_MAPS:
            createMapButton.setImage(_backgroundImage, for: .normal)
            createMapButton.layer.borderWidth = 3
        case BACKGROUND_BLANK:
            // TO DO: blankBackgroundButton.setImage(UIImage(named: BACKGROUND_BLANK_STRING), for: .normal)
            blankBackgroundButton.layer.borderWidth = 3
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMappingVC" {
            if let mappingVC = segue.destination as? MappingVC {
                mappingVC.project = project

                //mappingVC.visibleRegion = _visibleRegion
            }
        }
        else if segue.identifier == "GMapsSegue" {
            if let gMap = segue.destination as? GMapsVC {
                gMap.delegate = self
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
        _backgroundImage = newImage
        
        /*
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let imagePath = paths[0].appendingPathComponent("map.png")
        let data = UIImagePNGRepresentation(_backgroundImage)
        try? data?.write(to: imagePath)
        _backgroundString = imagePath.absoluteString
         */
        
        updateImageButtons()
        dismiss(animated: true)
    }
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = legendTableView.dequeueReusableCell(withIdentifier: "LegendCell", for: indexPath) as! LegendCell
        cell.configureCell(legend: legendArray[legendArray.count - (indexPath.row + 1)])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return legendArray.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "X") { action, index in
            self.legendArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }
    
    
    func getProjectName() -> String {
        return self.projectNameTxtFld.text!
    }
}
