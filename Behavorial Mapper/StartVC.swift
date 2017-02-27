//
//  ViewController.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class StartVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var menuView: StartScreenMenu!
    @IBOutlet weak var leftSideView: UIView!
    @IBOutlet weak var storedProjectsTableView: UITableView!
    @IBOutlet weak var createProjectBtn: UIButton!
    
    
    private var _storedProjects: [String]!
    private var _selectedProject: String = ""
    
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
        
        proxyTextField.backgroundColor = Style.backgroundTextField
        proxyTextField.textColor = Style.textPrimary
        proxyTextField.placeHolderColor = Style.textSecondary
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

    @IBAction func StartNewProjectPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreateProjectVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMappingVC" {
            if let mappingVC = segue.destination as? MappingVC {
                mappingVC.project = Project(projectName: _selectedProject)!
            }
        }
        
    }
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedProject = _storedProjects[indexPath.row]
        performSegue(withIdentifier: "showDetailMappingVC", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return _storedProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storedProjectsTableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        cell.configureCell(project: Project(projectName: _storedProjects[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "X") { action, index in
            deleteProject(projectName: self._storedProjects[indexPath.row])
            self._storedProjects = getProjectFiles()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.storedProjectsTableView.reloadData()
        }
        return [delete]
    }
}

