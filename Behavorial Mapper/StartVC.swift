//
//  ViewController.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps


protocol StartVCDelegate {
    func loadProject(fromProject: Project)
    func loadFromTemplate(fromProject: Project)
    func createNewProject()
}

class StartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leftSideView: UIView!
    @IBOutlet weak var storedProjectsTableView: UITableView!
    @IBOutlet weak var newProjectBtn: LargeBtn!
    @IBOutlet weak var loadProjectBtn: LargeBtn!
    @IBOutlet weak var newFromTemplateBtn: LargeBtn!
    @IBOutlet weak var deleteProjectBtn: LargeBtn!
    @IBOutlet weak var projectNotesTxtView: UITextView!
    @IBOutlet weak var projectBkgImageView: UIImageView!
    
    private var _storedProjects: [String]!
    private var _selectedProject: String = ""
    
    var delegate: StartVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStyle()
        initStoredProjectsTableView()
    }

    func initStyle() {
        let proxyTextField = UITextField.appearance()
        let proxyTextView = UITextView.appearance()
        let proxyButton = UIButton.appearance()
        let proxyLabel = UILabel.appearance()
        
        proxyTextField.textColor = Style.textPrimary
        proxyTextField.backgroundColor = Style.backgroundTextField
        proxyTextView.backgroundColor = Style.backgroundTextField
        proxyTextView.textColor = Style.textPrimary
        proxyButton.setTitleColor(Style.textPrimary, for: .normal)
        proxyButton.layer.borderColor = Style.textPrimary.cgColor
        proxyLabel.textColor = Style.textPrimary
        
        bkgView.backgroundColor = Style.backgroundSecondary
        menuView.backgroundColor = Style.backgroundPrimary
    }

    func initStoredProjectsTableView() {
        storedProjectsTableView.dataSource = self
        storedProjectsTableView.delegate = self
        _storedProjects = getProjectFiles()
        if _storedProjects == nil {
            self._storedProjects = [String]()
        }
    }
    
    func loadProjectDetails() {
        if let loadedProject = Project(projectName: _selectedProject) {
            projectBkgImageView.image = getBackgroundImg(fromProject: loadedProject)
            projectNotesTxtView.text = loadedProject.note
        }
    }
    
    func clearProjectDetails() {
        projectNotesTxtView.text = INITIAL_NOTES_TEXT
        projectBkgImageView.image = nil
    }

    @IBAction func newProjectPressed(_ sender: Any) {
        delegate?.createNewProject()
    }
    
    @IBAction func loadProjectPressed(_ sender: Any) {
        if let loadedProject = Project(projectName: _selectedProject) {
            delegate?.loadProject(fromProject: loadedProject)
        } else {
            displayMessage(title: NO_PROJECT_SELECTED_TITLE, message: NO_PROJECT_SELECTED_MSG, self: self)
        }
    }
    
    @IBAction func newFromTemplatePressed(_ sender: Any) {
        if let loadedProject = Project(projectName: _selectedProject) {
            delegate?.loadFromTemplate(fromProject: loadedProject)
        } else {
            displayMessage(title: NO_PROJECT_SELECTED_TITLE, message: NO_PROJECT_SELECTED_MSG, self: self)
        }
    }
    
    @IBAction func deleteProjectPressed(_ sender: Any) {
        if let _ = Project(projectName: _selectedProject) {
            deleteProject(projectName: _selectedProject)
            _storedProjects = getProjectFiles()
            if _storedProjects == nil {
                self._storedProjects = [String]()
            }
            clearProjectDetails()
            storedProjectsTableView.reloadData()
        } else {
            displayMessage(title: NO_PROJECT_SELECTED_TITLE, message: NO_PROJECT_SELECTED_MSG, self: self)
        }
    }
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedProject = _storedProjects[indexPath.row]
        if let selectedCell = tableView.cellForRow(at: indexPath) as! ProjectCell? {
            selectedCell.styleHighlighted()
        }
        loadProjectDetails()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath) as! ProjectCell? {
            selectedCell.styleNormal()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return _storedProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storedProjectsTableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        cell.configureCell(project: Project(projectName: _storedProjects[indexPath.row])!)
        if _selectedProject == _storedProjects[indexPath.row] {
            cell.styleHighlighted()
        } else {
            cell.styleNormal()
        }
        return cell
    }
}
