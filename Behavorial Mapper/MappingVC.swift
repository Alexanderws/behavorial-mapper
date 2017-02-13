//
//  MappingVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import Foundation

class MappingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MappingViewDelegate, ProjectDelegate, EntryNoteDelegate, MappingMenuDelegate {
    
    
    @IBOutlet weak var legendTableView: UITableView!
    @IBOutlet weak var entryTableView: UITableView!
    @IBOutlet weak var mappingBgImageView: UIImageView!
    @IBOutlet weak var mappingView: MappingView!
    @IBOutlet weak var mappingTopView: UIView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var legendTitleView: UIView!
    @IBOutlet weak var historyTitleView: UIView!
    
    private var _project: Project!
    private var _selectedLegend: Legend!
    private var _selectedEntry: Entry!
    private var _selectedIndex: Int!
    
    private var _tagNumber = 0
    private var _touchesMovedDeadZone = 0
    private var _centerPos: CGPoint!
    private var _angleInDegrees: CGFloat = 999
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
        
        if project.background == BACKGROUND_BLANK_STRING {
            mappingBgImageView.image = getWhiteBackground(width: 2000, height: 2000)
        } else {
            let url = URL(string: project.background)
            let data = try? Data(contentsOf: url!)
            mappingBgImageView.image = UIImage(data: data!)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverMappingMenuVC" {
            if let mappingMenu = segue.destination as? MappingMenuVC {
                mappingMenu.delegate = self
            }
        }
    }
    
    // PROJECT FUNCTIONS
    func entryDeleted(tagId: Int) {
        print("entryDeleted: tagId = \(tagId)")
        mappingView.viewWithTag(tagId)?.removeFromSuperview()
        mappingView.viewWithTag(tagId)?.removeFromSuperview()
    }
    
    // ENTRYNOTE FUNCTIONS
    func noteAdded(note: String) {
        project.entries[_selectedIndex].note = note
    }
    
    // MAPPING MENU FUNCTIONS
    func editProjectNotes() {
        displayTextEntry(title: "Project Notes", placeholder: "Enter notes", self: self)
    }
    
    func exportData() {
        let csvString = generateCsvString(project: project)
        // displayTextShare(shareContent: csvString, self: self, anchor: menuButton)
        displayCSVShare(shareContent: csvString, projectName: _project.name, self: self, anchor: menuButton)
    }
    
    func exportImage() {
        let image = mappingTopView.snapshotImage()!
        displayImageShare(shareContent: image, self: self, anchor: menuButton)
    }
    
    func exitProject() {
        project.saveProject()
        performSegue(withIdentifier: "showStartVC", sender: nil)
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
        _angleInDegrees = 999
        _arrowIcon.tag = _tagNumber
        _arrowIcon.isHidden = true
        mappingView.addSubview(_arrowIcon)
        
        mappingView.addSubview(_centerIcon)
    }
    
    func mappingViewTouchMoved(sender: MappingView, touches: Set<UITouch>) {
        if(_touchesMovedDeadZone == 4) {
            if(_arrowIcon.isHidden) {
                _arrowIcon.isHidden = false
            }
            if let touch = touches.first {
                let newPos = touch.location(in: mappingView)
                let mPoint = bearingPoint(point0: _centerPos, point1: newPos)
                _angleInDegrees = pointToDegrees(x: mPoint.x, y: mPoint.y)
                _arrowIcon.transform = CGAffineTransform(rotationAngle: -_angleInDegrees * CGFloat(M_PI/180))
            }
        } else {
            _touchesMovedDeadZone += 1
        }
    }
    
    func mappingViewTouchEnded(sender: MappingView, touches: Set<UITouch>) {
        _touchesMovedDeadZone = 0
        _project.addEntry(legend: selectedLegend, angleInDegrees: _angleInDegrees, position: _centerPos!, tagId: _tagNumber)
        entryTableView.reloadData()
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
        if tableView == entryTableView {
            _selectedEntry = project.entries[self.project.entries.count - (indexPath.row + 1)]
            _selectedIndex = self.project.entries.count - (indexPath.row + 1)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let entryNoteVC = storyboard.instantiateViewController(withIdentifier: "EntryNoteVC") as! EntryNoteVC
            entryNoteVC.entry = _selectedEntry
            entryNoteVC.index = _selectedIndex
            entryNoteVC.modalPresentationStyle = UIModalPresentationStyle.popover
            entryNoteVC.entryNoteDelegate = self
            
            let popoverPresentationController = entryNoteVC.popoverPresentationController
                
            if let _popoverPresentationController = popoverPresentationController {
                
                let cell = entryTableView.cellForRow(at: indexPath)
                
                let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
                let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
                
                _popoverPresentationController.sourceView = cell
                _popoverPresentationController.sourceRect = CGRect(x: rectOfCellInSuperview.origin.x, y: rectOfCellInSuperview.origin.x, width: rectOfCellInSuperview.width, height: rectOfCellInSuperview.height)

                self.present(entryNoteVC, animated: true, completion: nil)
            }
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
