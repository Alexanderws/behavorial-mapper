//
//  TitleLbl.swift
//  Behavorial Mapper
//
//  Created by Alexander on 16/04/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class TitleLbl: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = Style.textPrimary
        self.font = UIFont(name: "Helvetica Neue", size: 10)
    }

}
