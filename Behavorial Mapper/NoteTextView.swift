//
//  NoteTextField.swift
//  Behavorial Mapper
//
//  Created by Alexander on 23/03/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class NoteTextField: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = Style.textSecondary
        self.backgroundColor = UIColor.white
        self.font = UIFont(name: "Helvetica Neue", size: 14.0)
    }

}
