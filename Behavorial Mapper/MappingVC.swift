//
//  MappingVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import Foundation

class MappingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MappingViewDelegate, ProjectDelegate {

    
    @IBOutlet weak var legendTableView: UITableView!
    @IBOutlet weak var entryTableView: UITableView!
    @IBOutlet weak var mappingBgImageView: UIImageView!
    @IBOutlet weak var mappingView: MappingView!
   
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var legendTitleView: UIView!
    @IBOutlet weak var historyTitleView: UIView!

    private var _centerPos: CGPoint!
    private var _angleInDegrees: CGFloat = 0

    private var _project: Project!
    private var _selectedLegend: Legend!
    
    private var _tagNumber = 0
    
    private var _arrowIcon: UIImageView!
    
    
    var project: Project {
        get {
            return _project
        } set {
            _project = newValue
        }
    }
    
    var selectedLegend: Legend {
        get {
            return _selectedLegend
        } set {
            _selectedLegend = newValue
        }
    }
    
    var tagNumber: Int {
        return _tagNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        legendTableView.delegate = self
        legendTableView.dataSource = self
        entryTableView.delegate = self
        entryTableView.dataSource = self
        
        selectedLegend = project.legend[0]
        
        project.projectDelegate = self
        mappingView.mappingViewDelegate = self
        
        let url = URL(string: project.background)
        let data = try? Data(contentsOf: url!)
        mappingBgImageView.image = UIImage(data: data!)
    }

    
    // PROJECT FUNCTIONS
    func entryDeleted(tagId: Int) {
        print("entryDeleted: tagId = \(tagId)")
        mappingView.viewWithTag(tagId)?.removeFromSuperview()
        mappingView.viewWithTag(tagId)?.removeFromSuperview()
    }
    
    // MAPPING VIEW FUNCTIONS
    func mappingViewTouchBegan(sender: MappingView, touches: Set<UITouch>) {
        if let touch = touches.first {
            _centerPos = touch.location(in: mappingView)
        }
        let _centerIcon = UIImageView(frame: CGRect(x: _centerPos.x - (CENTER_ICON_SIZE/2), y: _centerPos.y - (CENTER_ICON_SIZE/2), width: (CENTER_ICON_SIZE), height: CGFloat(CENTER_ICON_SIZE)))
        _centerIcon.image = UIImage(named: "\(selectedLegend.icon)")
        _arrowIcon = UIImageView(frame: CGRect(x: _centerPos.x - (ARROW_ICON_SIZE/2), y: _centerPos.y - (ARROW_ICON_SIZE/2), width: (ARROW_ICON_SIZE), height: (ARROW_ICON_SIZE)))
        _arrowIcon.image = UIImage(named: "arrowBlk_1x")
        _tagNumber += 1
        _centerIcon.tag = _tagNumber
        _arrowIcon.tag = _tagNumber
        _angleInDegrees = 0
        mappingView.addSubview(_arrowIcon)
        mappingView.addSubview(_centerIcon)
    }
    
    func mappingViewTouchMoved(sender: MappingView, touches: Set<UITouch>) {
        if let touch = touches.first {
            let newPos = touch.location(in: mappingView)
            let mPoint = bearingPoint(point0: _centerPos, point1: newPos)
            _angleInDegrees = pointToDegrees(x: mPoint.x, y: mPoint.y)
            _arrowIcon.transform = CGAffineTransform(rotationAngle: -_angleInDegrees * CGFloat(M_PI/180))
        }
    }
    
    func mappingViewTouchEnded(sender: MappingView, touches: Set<UITouch>) {
        _project.addEntry(legend: selectedLegend, angleInDegrees: _angleInDegrees, position: _centerPos!, tagId: _tagNumber)
        entryTableView.reloadData()
        //print("Angle in degrees: \(_angleInDegrees)")
    }
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == legendTableView {
            let cell = legendTableView.dequeueReusableCell(withIdentifier: "LegendCell", for: indexPath) as! LegendCell
            cell.configureCell(legend: project.legend[indexPath.row])
            return cell
        } else if tableView == entryTableView {
            let cell = entryTableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
            cell.configureCell(entry: project.entries[project.entries.count - (indexPath.row + 1)])
            return cell
        }
        let cell = legendTableView.dequeueReusableCell(withIdentifier: "LegendCell", for: indexPath) as! LegendCell
        cell.configureCell(legend: project.legend[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == legendTableView {
            return project.legend.count
        } else if tableView == entryTableView {
            return project.entries.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == legendTableView {
            return CGFloat(LEGEND_TABLEVIEW_CELL_HEIGHT)
        }
        if tableView == entryTableView {
            return CGFloat(ENTRY_TABLEVIEW_CELL_HEIGHT)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == legendTableView {
            selectedLegend = project.legend[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView == entryTableView {
            let delete = UITableViewRowAction(style: .destructive, title: "X") { action, index in
                self.project.removeEntry(index: self.project.entries.count - (indexPath.row + 1))
                print("editActionsForRowAt: indexPath.row = \(self.project.entries.count - (indexPath.row + 1))")
                self.entryTableView.reloadData()
            }
            return [delete]
        }
        return [UITableViewRowAction()]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == entryTableView {
            return true
        }
        return false
    }
}
