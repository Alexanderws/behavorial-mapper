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
    
    func exportData()
    
    func exportImage()
    
    func exitProject()
    
}

class MappingMenuVC: UIViewController {
    
    
    @IBOutlet weak var projectNotesBtn: UIButton!
    @IBOutlet weak var exportDataBtn: UIButton!
    @IBOutlet weak var exportImageBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    var delegate: MappingMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func projectNotesPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.editProjectNotes()
        }
    }
    
    @IBAction func exportDataPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.exportData()
        }
    }

    @IBAction func exportImagePressed(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.exportImage()
        }
    }
        
    @IBAction func exitPressed(_ sender: Any) {
        delegate?.exitProject()
    }

}
