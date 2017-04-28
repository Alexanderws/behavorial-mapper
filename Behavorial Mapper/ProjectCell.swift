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
    @IBOutlet weak var lastEditedTopLbl: UILabel!
    @IBOutlet weak var lastEditedBottomLbl: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func configureCell(project: Project) {
        self.projectNameLbl.text = project.name
        self.lastEditedTopLbl.text = dateFormat(date: project.lastSaved)
        self.lastEditedBottomLbl.text = timeFormat(date: project.lastSaved)
    }
    
    func styleHighlighted() {
        layer.backgroundColor = UIColor.white.cgColor
        projectNameLbl.textColor = Style.textSecondary
        lastEditedTopLbl.textColor = Style.textSecondary
        lastEditedBottomLbl.textColor = Style.textSecondary
    }
    
    func styleNormal() {
        layer.backgroundColor = UIColor.clear.cgColor
        projectNameLbl.textColor = Style.textPrimary
        lastEditedTopLbl.textColor = Style.textPrimary
        lastEditedBottomLbl.textColor = Style.textPrimary
    }

}
