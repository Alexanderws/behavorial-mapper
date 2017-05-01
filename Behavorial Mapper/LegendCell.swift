//
//  LegendCreateList.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class LegendCell: UITableViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var legendNameLbl: UILabel!
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var spacerView: UIView!
 
    private var legend: Legend!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func configureCell (legend: Legend) {
        
        bkgView.backgroundColor = Style.backgroundPrimary
        spacerView.backgroundColor = Style.backgroundSecondary
        legendNameLbl.textColor = Style.textPrimary
        
        self.legend = legend
        self.iconImg.image = UIImage(named: "entryIcon\(legend.icon)")
        self.legendNameLbl.text = legend.name
    }
    
    func styleHighlighted() {
        bkgView.backgroundColor = UIColor.white
        legendNameLbl.textColor = Style.textSecondary
    }
    
    func styleNormal() {
        bkgView.backgroundColor = Style.backgroundPrimary
        legendNameLbl.textColor = Style.textPrimary
    }
    
}
