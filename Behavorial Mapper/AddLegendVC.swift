//
//  AddLegendVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 06/04/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

protocol AddLegendDelegate {
    func addLegend(legend: Legend)
}

class AddLegendVC: UIViewController {
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var iconBtn: FramedButton!
    @IBOutlet weak var legendTitleLbl: UILabel!
    
    private var selectedIconId = 0
    var delegate: AddLegendDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initStyle()
    }
    
    func initStyle() {
        bkgView.backgroundColor = Style.backgroundPrimary
        
        iconBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        iconBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
    }

    func enterLegendIcon(iconId: Int) {
        iconBtn.setTitle("", for: .normal)
        iconBtn.setImage(UIImage(named: "entryIcon\(iconId)"), for: .normal)
        selectedIconId = iconId
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if nameTextField.hasText {
            if let name = nameTextField.text {
                let legend = Legend(name: name, icon: selectedIconId)
                self.delegate?.addLegend(legend: legend)
                dismiss(animated: true, completion: nil)
            }
        } else {
            displayMessage(title: NO_LEGEND_NAME_TITLE, message: NO_LEGEND_NAME_MSG, self: self)
        }
    }
    
    @IBAction func iconBtnPressed(_ sender: Any) {
        // Segue: IconSelectVC as Popover
    }
    
}
