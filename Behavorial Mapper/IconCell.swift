//
//  IconCell.swift
//  Behavorial Mapper
//
//  Created by Alexander on 11/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    
    var iconId: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // layer.cornerRadius = 5.0
    }
    
    func configureCell(_ iconId: Int) {
        self.iconId = iconId
        
        iconImg.image = UIImage(named: "entryIcon\(iconId)")
    }
    

}
