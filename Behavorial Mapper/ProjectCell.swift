//
//  ProjectCell.swift
//  Behavorial Mapper
//
//  Created by Alexander on 16/02/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

    
    
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var lastEditedLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(project: Project) {
        self.projectNameLbl.text = project.name
        self.lastEditedLbl.text = dateFormat(date: project.lastSaved)
    }

}
