//
//  LegendCreateList.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class CreateLegendCell: UITableViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var legendName: UILabel!
    
    private var legend: Legend!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell (legend: Legend) {
        self.legend = legend
        self.iconImg.image = UIImage(named: "\(legend.icon)")
        self.legendName.text = legend.name
    }
    
}
