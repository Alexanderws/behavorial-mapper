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
    @IBOutlet weak var mappingLeftView: UIView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var viewFilterView: UIView!
    @IBOutlet weak var viewLast10Btn: UIButton!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var viewNoneBtn: UIButton!
    
    @IBOutlet weak var viewLblContainerView: UIView!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var legendTitleView: UIView!
    @IBOutlet weak var historyTitleView: UIView!
    
    private var _project: Project!
    private var _selectedLegend: Legend!
    private var _selectedEntry: Entry!
    private var _selectedIndex: Int!
    
    private var _tagNumber = 0
    private var _touchesMovedDeadZone = DEADZONE_START_VALUE
    private var _centerPos: CGPoint!
    private var _angleInDegrees: CGFloat = 999
    private var _arrowIcon: UIImageView!
    private var _viewMode: Int = VIEW_ALL
    
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
        initStyle()
        initTableViews()
        
        if _project.backgroundType == BACKGROUND_IMAGE_UPLOADED {
            mappingBgImageView.contentMode = UIViewContentMode.scaleAspectFit
        } else {
            mappingBgImageView.contentMode = UIViewContentMode.scaleAspectFill
        }
        
        if _project.entries.count > 0 {
            _tagNumber = _project.entries[_project.entries.count - 1].tagId
            for entry in _project.entries {
                createEntryIcon(xPos: entry.position.x, yPos: entry.position.y, targetView: mappingView, angleInDegrees: entry.angleInDegrees, tagId: entry.tagId, icon: entry.legend.icon)
            }
        }
        
        if project.background == BACKGROUND_BLANK_STRING {
            mappingBgImageView.image = getWhiteBackground(width: 2000, height: 2000)
        } else {
            let mapFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent("/maps/\(project.name)").appendingPathExtension("map.png")
            let data = try? Data.init(contentsOf: mapFile)
            mappingBgImageView.image = UIImage.init(data: data!)
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        legendTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        legendTableView.delegate?.tableView!(legendTableView, didSelectRowAt: indexPath)
    
    }
    
    func initStyle() {
        mappingLeftView.backgroundColor = Style.backgroundSecondary
        menuButton.backgroundColor = Style.backgroundPrimary
        legendTitleView.backgroundColor = Style.backgroundPrimary
        historyTitleView.backgroundColor = Style.backgroundPrimary
        
        viewLbl.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        viewLblContainerView.backgroundColor = Style.backgroundPrimary
    }

    func initTableViews() {
        legendTableView.delegate = self
        legendTableView.dataSource = self
        entryTableView.delegate = self
        entryTableView.dataSource = self
        
        selectedLegend = project.legend[0]
        
        project.projectDelegate = self
        mappingView.mappingViewDelegate = self
        
        //legendTableView.tableFooterView = UIView(frame: CGRect.zero)
        //entryTableView.tableFooterView = UIView(frame: CGRect.zero)
        //legendTableView.separatorColor = UIColor.clear
        //entryTableView.separatorColor = UIColor.clear
        
        // entryTableView.reloadData()
        entryTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverMappingMenuVC" {
            if let mappingMenu = segue.destination as? MappingMenuVC {
                mappingMenu.delegate = self
                mappingMenu.preferredContentSize = CGSize(width: 200, height: 220)
            }
        }
    }
    
    func madeChange() {
        
    }
    
    // PROJECT FUNCTIONS
    func entryDeleted(tagId: Int) {
        mappingView.viewWithTag(tagId)?.removeFromSuperview()
        mappingView.viewWithTag(tagId + 1)?.removeFromSuperview()
    }
    
    // ENTRYNOTE FUNCTIONS
    func noteAdded(note: String) {
        project.entries[_selectedIndex].note = note
        entryTableView.reloadData()
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
        viewFilterView.isHidden = true
        //let image = mappingTopView.snapshotImage()!
        let image = getImageSnapshot(fromView: mappingTopView)
        displayImageShare(shareContent: image, self: self, anchor: menuButton)
        viewFilterView.isHidden = false
    }
    
//    func exportEntries() {
//        mappingBgImageView.isHidden = true
//        let image = mappingView.snapshotImage()!
//        displayImageShare(shareContent: image, self: self, anchor: menuButton)
//        mappingBgImageView.isHidden = false
//    }
    
    func exportBackground() {
        viewFilterView.isHidden = true
        let image = mappingBgImageView.snapshotImage()!
        //let image = getImageSnapshot(fromView: mappingBgImageView)
        displayImageShare(shareContent: image, self: self, anchor: menuButton)
        viewFilterView.isHidden = false
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
        
        _tagNumber += 2
        _angleInDegrees = 999
        
        createEntryIcon(xPos: _centerPos.x, yPos: _centerPos.y, targetView: mappingView, angleInDegrees: _angleInDegrees, tagId: _tagNumber, icon: _selectedLegend.icon)
    }
    
    func createEntryIcon(xPos: CGFloat, yPos: CGFloat, targetView: UIView, angleInDegrees: CGFloat, tagId: Int, icon: Int) {
        let _centerIcon = UIImageView(frame: CGRect(x: xPos - (CENTER_ICON_SIZE/2), y: yPos - (CENTER_ICON_SIZE/2), width: (CENTER_ICON_SIZE), height: CGFloat(CENTER_ICON_SIZE)))
        _centerIcon.image = UIImage(named: "entryIcon\(icon)")
        _arrowIcon = UIImageView(frame: CGRect(x: xPos - (ARROW_ICON_SIZE/2), y: yPos - (ARROW_ICON_SIZE/2), width: (ARROW_ICON_SIZE), height: (ARROW_ICON_SIZE)))
        _arrowIcon.image = UIImage(named: "arrow")
        
        _centerIcon.tag = tagId
        _arrowIcon.tag = tagId + 1

        targetView.addSubview(_arrowIcon)
        mappingView.addSubview(_centerIcon)
        
        if (angleInDegrees == 999) {
            _arrowIcon.isHidden = true
        } else {
            _arrowIcon.isHidden = false
            rotateImage(imageId: _centerIcon.tag, angleToRotate: angleInDegrees)
        }
        
    }
    
    func rotateImage(imageId: Int, angleToRotate: CGFloat) {
        mappingView.viewWithTag(imageId)?.transform = CGAffineTransform(rotationAngle: -angleToRotate * CGFloat(M_PI/180))
        mappingView.viewWithTag(imageId + 1)?.transform = CGAffineTransform(rotationAngle: -angleToRotate * CGFloat(M_PI/180))
    }
    
    func mappingViewTouchMoved(sender: MappingView, touches: Set<UITouch>) {
        if(_touchesMovedDeadZone == 0) {
            if(_arrowIcon.isHidden) {
                _arrowIcon.isHidden = false
            }
            if let touch = touches.first {
                let newPos = touch.location(in: mappingView)
                let mPoint = bearingPoint(point0: _centerPos, point1: newPos)
                _angleInDegrees = pointToDegrees(x: mPoint.x, y: mPoint.y)
                rotateImage(imageId: tagNumber, angleToRotate: _angleInDegrees)
                //_arrowIcon.transform = CGAffineTransform(rotationAngle: -_angleInDegrees * CGFloat(M_PI/180))
            }
        } else {
            _touchesMovedDeadZone -= 1
        }
    }
    
    func mappingViewTouchEnded(sender: MappingView, touches: Set<UITouch>) {
        _touchesMovedDeadZone = DEADZONE_START_VALUE
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
            let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
            selectedCell.contentView.backgroundColor = UIColor.red
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
                // self.entryTableView.reloadData()
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
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
    
    func showAllEntries() {
        for entry in project.entries {
            mappingView.viewWithTag(entry.tagId)?.isHidden = false
            if (entry.angleInDegrees != 999) {
                mappingView.viewWithTag(entry.tagId + 1)?.isHidden = false
            }
        }
    }
    
    func hideAllEntries() {
        for entry in project.entries {
            mappingView.viewWithTag(entry.tagId)?.isHidden = true
            mappingView.viewWithTag(entry.tagId + 1)?.isHidden = true
        }
    }
    
    func showEntry(index: Int) {
        mappingView.viewWithTag(project.entries[index].tagId)?.isHidden = false
        if (project.entries[index].angleInDegrees != 999) {
            mappingView.viewWithTag(project.entries[index].tagId + 1)?.isHidden = false
        }
    }
    
    func hideEntry(index: Int) {
        mappingView.viewWithTag(project.entries[index].tagId)?.isHidden = true
        mappingView.viewWithTag(project.entries[index].tagId + 1)?.isHidden = true
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        _viewMode = VIEW_ALL
        showAllEntries()
    }
    
   
    @IBAction func viewLast10Pressed(_ sender: Any) {
        if (project.entries.count > 10) {
            let maxMinus10: Int = project.entries.count - 10
            if _viewMode == VIEW_NONE {
                for index in maxMinus10...project.entries.count - 1 {
                    showEntry(index: index)
                }
            } else {
                for index in 0...maxMinus10 - 1 {
                    hideEntry(index: index)
                }
            }
        } else {
            showAllEntries()
        }
        _viewMode = VIEW_10
    }
    
    @IBAction func viewNonePressed(_ sender: Any) {
        _viewMode = VIEW_NONE
        hideAllEntries()
    }
    
    
}
