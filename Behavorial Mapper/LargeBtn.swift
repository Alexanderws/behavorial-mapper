//
//  LargeBtn.swift
//  Behavorial Mapper
//
//  Created by Alexander on 16/04/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class LargeBtn: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setTitleColor(Style.textPrimary, for: .normal)
        self.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 18)
    }

}
