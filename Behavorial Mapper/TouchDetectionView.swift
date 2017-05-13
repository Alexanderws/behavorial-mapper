//
//  TouchDetectionView.swift
//  Behavorial Mapper
//
//  Created by Alexander on 06/05/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

protocol TouchDetectionViewDelegate {
    func touchEnded()
}

class TouchDetectionView: UIView {

    var touchDetectionViewDelegate: TouchDetectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDetectionViewDelegate?.touchEnded()
    }

}
