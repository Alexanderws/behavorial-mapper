//
//  MappingMenuVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 02/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit


protocol MappingMenuDelegate {
    func editProjectNotes()
    func exportProjectNotes()
    func exportData()
    func exportImage()
    func exportEntries()
    func exportBackground()
}

protocol MenuContainerDelegate {
    func closeMenu()
    func exitProject()
}

class MappingMenuVC: UIViewController {
    
    
    @IBOutlet weak var projectNotesBtn: UIButton!
    @IBOutlet weak var exportDataBtn: UIButton!
    @IBOutlet weak var exportImageBtn: UIButton!
    @IBOutlet weak var exportBackgroundBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    
    
    var mappingDelegate: MappingMenuDelegate?
    var containerDelegate: MenuContainerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStyle()
    }

    func initStyle() {
     
    }
    
    @IBAction func projectNotesPressed(_ sender: Any) {
        self.mappingDelegate?.editProjectNotes()
        self.containerDelegate?.closeMenu()
    }
    
    @IBAction func exportNotesPressed(_ sender: Any) {
        self.mappingDelegate?.exportProjectNotes()
        self.containerDelegate?.closeMenu()
    }
    
    @IBAction func exportDataPressed(_ sender: Any) {
        self.containerDelegate?.closeMenu()
        self.mappingDelegate?.exportData()
    }

    @IBAction func exportImagePressed(_ sender: Any) {
        self.containerDelegate?.closeMenu()
        self.mappingDelegate?.exportImage()
    }
    
    @IBAction func exportEntriesPressed(_ sender: Any) {
        self.containerDelegate?.closeMenu()
        self.mappingDelegate?.exportEntries()
    }

    @IBAction func exportBackgroundPressed(_ sender: Any) {
        self.containerDelegate?.closeMenu()
        self.mappingDelegate?.exportBackground()
    }
    
    
    @IBAction func exitPressed(_ sender: Any) {
        self.containerDelegate?.exitProject()
    }

}
