//
//  MappingVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class MappingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var legendTableView: UITableView!
    @IBOutlet weak var entryTableView: UITableView!
    @IBOutlet weak var mappingImageView: UIImageView!
   
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var legendTitleView: UIView!
    @IBOutlet weak var historyTitleView: UIView!
    
    
    
    
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        legendTableView.delegate = self
        legendTableView.dataSource = self
        entryTableView.delegate = self
        entryTableView.dataSource = self
        
        
    }

    
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == legendTableView {
            
        } else if tableView == entryTableView {
        
        }
        let cell = legendTableView.dequeueReusableCell(withIdentifier: "LegendCell", for: indexPath) as! LegendCell
        cell.configureCell(legend: project.legend[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project.legend.count
    }

    
    
    
}

