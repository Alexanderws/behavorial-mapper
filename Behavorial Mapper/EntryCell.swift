//
//  EntryCell.swift
//  Behavorial Mapper
//
//  Created by Alexander on 17/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {

    
    
    @IBOutlet weak var entryNameLbl: UILabel!
    @IBOutlet weak var entryTimeLbl: UILabel!
    @IBOutlet weak var entryDateLbl: UILabel!
    @IBOutlet weak var entryIconImage: UIImageView!
    
    private var entry: Entry!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    func configureCell (entry: Entry) {
        self.entry = entry
        self.entryNameLbl.text = entry.legend.name
        self.entryTimeLbl.text = timeFormat(date: entry.time)
        self.entryDateLbl.text = dateFormat(date: entry.time)
        self.entryIconImage.image = UIImage(named: "\(entry.legend.icon)")
    }
}
