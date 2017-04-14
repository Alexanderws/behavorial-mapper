//
//  MappingImageView.swift
//  Behavorial Mapper
//
//  Created by Alexander on 17/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

protocol MappingViewDelegate {
    func mappingViewTouchBegan(sender: MappingView, touches: Set<UITouch>)
    func mappingViewTouchMoved(sender: MappingView, touches: Set<UITouch>)
    func mappingViewTouchEnded(sender: MappingView, touches: Set<UITouch>)
}

class MappingView: UIView {
    
    

    var mappingViewDelegate: MappingViewDelegate?
    
    var centerPos: CGPoint!
    var centerIcon: UIImageView!
    var legend: Legend!
    var entries: [Entry]!
    var nc = NotificationCenter.default
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mappingViewDelegate?.mappingViewTouchBegan(sender: self, touches: touches)
   
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        mappingViewDelegate?.mappingViewTouchMoved(sender: self, touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mappingViewDelegate?.mappingViewTouchEnded(sender: self, touches: touches)
        //  entries.append(Entry(start: centerPos, legend: legend, idTag: id))
    }
    
    
    
    
    
    
}
