//
//  ViewController.swift
//  Behavorial Mapper
//
//  Created by Alexander on 05/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import GoogleMaps

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        var legends = [Legend]()
        let legend_m = Legend(name: "Mann", icon: 1)
        let legend_k = Legend(name: "Kvinne", icon: 2)
        legends.append(legend_m)
        legends.append(legend_k)
        
        var entries = [Entry]()
        let entry_m = Entry(start: CGPoint.init(x: 1.0, y: 1.0), angleInDegrees: 20.4, legend: legend_m, tagId: 9)
        entry_m.note = "Test Entry Mann"
        let entry_k = Entry(start: CGPoint(x:2.0, y: 2.0), angleInDegrees: 123.3, legend: legend_k, tagId: 8)
        entry_k.note = "Test Entry Kvinne"
        entries.append(entry_m)
        entries.append(entry_k)
        
        let project = Project(name: "My Project", background: "/path/to/background/image.png", legend: legends, note: "Project note")
        project.entries = entries
        
        print(project.entries[0].csvHeader())
        for entry in project.entries {
            print(entry.csvBody())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func StartNewProjectPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreateProjectVC", sender: sender)
    }
    
    
    @IBAction func LoadProjectPressed(_ sender: Any) {
        
        
        
    }


}

