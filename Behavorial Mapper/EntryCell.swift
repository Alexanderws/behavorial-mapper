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
    @IBOutlet weak var entryTimeTopLbl: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var entryTimeBottomLbl: UILabel!
    @IBOutlet weak var entryIconImage: UIImageView!
    @IBOutlet weak var entryTitleBarView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var spacerView: UIView!
    
    
    
    private var entry: Entry!
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.backgroundColor = Style.backgroundPrimary.cgColor
    }
    
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
        self.entryTimeBottomLbl.text = timeFormat(date: entry.time)
        self.entryTimeTopLbl.text = dateFormat(date: entry.time)
        self.entryIconImage.image = UIImage(named: "entryIcon\(entry.legend.icon)")
        entryTitleBarView.backgroundColor = Style.backgroundPrimary
        detailsView.backgroundColor = Style.backgroundPrimary
        spacerView.backgroundColor = Style.backgroundSecondary
        noteImageView.image = UIImage(named: "note")

        
        if (!entry.note.isEmpty) {
            noteImageView.isHidden = false
        } else {
            noteImageView.isHidden = true
        }
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
    }
}
