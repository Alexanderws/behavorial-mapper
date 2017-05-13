//
//  MappingVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

protocol MappingVCDelegate {
    func toggleMenu()
}

class MappingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ProjectDelegate, MappingMenuDelegate {
    
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
    
    var _menuVC: MappingMenuVC?
    
    private var _project: Project!
   
    var _selectedLegend: Legend!
    var _selectedEntry: Entry!
    var _selectedIndex: Int!
    var _firstCell = true
    
    // MappingViewDelegate
    var tagNumber = 0
    var touchesMovedDeadZone = DEADZONE_START_VALUE
    var _centerPos: CGPoint!
    var _angleInDegrees: CGFloat = 999
    var _arrowIcon: UIImageView!
    
    var detectionView: TouchDetectionView?

    
    private var _viewMode: Int = VIEW_ALL
    private var _menuShowing = false

    var delegate: MappingVCDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStyle()
        initTableViews()
        initEntries()
        initBackground()
    }
    
    func initEntries() {
        if _project.entries.count > 0 {
            tagNumber = _project.entries[_project.entries.count - 1].tagId
            for entry in _project.entries {
                createEntryIcon(xPos: entry.position.x, yPos: entry.position.y, targetView: mappingView, angleInDegrees: entry.angleInDegrees, tagId: entry.tagId, icon: entry.legend.icon)
            }
        }
    }
    
    func initBackground() {
        mappingBgImageView.image = getBackgroundImg(fromProject: _project)
    }
    
    func initStyle() {
        mappingLeftView.backgroundColor = Style.backgroundSecondary
        menuButton.backgroundColor = Style.backgroundPrimary
        legendTitleView.backgroundColor = Style.backgroundPrimary
        historyTitleView.backgroundColor = Style.backgroundPrimary
        
        viewLbl.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        viewLblContainerView.backgroundColor = Style.backgroundPrimary
        viewFilterView.backgroundColor = Style.backgroundPrimary
    }

    func initTableViews() {
        legendTableView.delegate = self
        legendTableView.dataSource = self
        entryTableView.delegate = self
        entryTableView.dataSource = self
        
        selectedLegend = project.legend[0]
        
        project.projectDelegate = self
        mappingView.mappingViewDelegate = self
    }
    
    func resetLegendTableView() {
        _firstCell = true
        selectedLegend = project.legend[0]
        legendTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverAddLegendVC" {
            if let addLegendVC = segue.destination as? AddLegendVC {
                addLegendVC.delegate = self
            }
        }
    }
    
    func madeChange() {
        project.saveProject()
    }
    
    func highlightEntry(onEntry: Entry) {
        if let entryIcon = mappingView.viewWithTag(onEntry.tagId) {
            for i in 1...5 {
                let delayTime = Double(i) * 0.05
                delay(delayTime) {
                    let circle = getCircle(forView: entryIcon, ofSize: HIGHLIGHT_CIRCLE_INIT_SIZE + CGFloat(i) * 3)
                    circle.opacity = 1 / Float(i)
                    self.mappingView.layer.addSublayer(circle)
                    delay(delayTime + 0.05) {
                        circle.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    func showEntryNote(indexPath: IndexPath, tableView: UITableView) {
        _selectedEntry = project.entries[self.project.entries.count - (indexPath.row + 1)]
        _selectedIndex = self.project.entries.count - (indexPath.row + 1)
        
        if let noteVC = UIStoryboard.noteVC() {
            noteVC.currentNote = _selectedEntry.note
            noteVC.senderType = NOTE_TYPE_ENTRY
            noteVC.noteDelegate = self
            noteVC.modalPresentationStyle = UIModalPresentationStyle.popover

        
            let popoverPresentationController = noteVC.popoverPresentationController
        
            if let _popoverPresentationController = popoverPresentationController {
                let cell = entryTableView.cellForRow(at: indexPath)
                let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
                let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
                _popoverPresentationController.sourceView = cell
                _popoverPresentationController.sourceRect = CGRect(x: rectOfCellInSuperview.origin.x, y: rectOfCellInSuperview.origin.x, width: rectOfCellInSuperview.width, height: rectOfCellInSuperview.height)
            
                self.present(noteVC, animated: false, completion: nil)
            }
        }
    }
    
    // PROJECT FUNCTIONS
    func entryDeleted(tagId: Int) {
        mappingView.viewWithTag(tagId)?.removeFromSuperview()
        mappingView.viewWithTag(tagId + 1)?.removeFromSuperview()
    }
    
    // MAPPING MENU FUNCTIONS
    func editProjectNotes() {
        if let noteVC = UIStoryboard.noteVC() {
            noteVC.currentNote = project.note
            noteVC.senderType = NOTE_TYPE_PROJECT
            noteVC.noteDelegate = self
            noteVC.modalPresentationStyle = UIModalPresentationStyle.popover
            
            let popoverPresentationController = noteVC.popoverPresentationController
            
            if let _popoverPresentationController = popoverPresentationController {
                _popoverPresentationController.sourceView = self.view
                _popoverPresentationController.sourceRect = CGRect(x: self.view.frame.origin.x - 200, y: self.view.frame.origin.x, width: self.view.frame.width, height: self.view.frame.height)
                
                self.present(noteVC, animated: false, completion: nil)
            }
        }
    }
    
    func exportProjectNotes () {
        displayTextShare(shareContent: project.note, self: self, anchor: menuButton)
    }
    
    func exportData() {
        let csvString = generateCsvString(project: project)
        displayCSVShare(shareContent: csvString, projectName: _project.name, self: self, anchor: menuButton)
    }
    
    func exportImage() {
        viewFilterView.isHidden = true
        let image = getImageSnapshot(fromView: mappingTopView)
        displayImageShare(shareContent: image, self: self, anchor: menuButton)
        viewFilterView.isHidden = false
    }
    
    func exportEntries() {
        mappingBgImageView.isHidden = true
        viewFilterView.isHidden = true
        let image = mappingView.snapshot()!
        displayImageShare(shareContent: image, self: self, anchor: menuButton)
        mappingBgImageView.isHidden = false
        viewFilterView.isHidden = false
    }
    
    func exportBackground() {
        viewFilterView.isHidden = true
        let image = mappingBgImageView.snapshot()!
        displayImageShare(shareContent: image, self: self, anchor: menuButton)
        viewFilterView.isHidden = false
    }

    
   
    
    // TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == legendTableView {
            let cell = legendTableView.dequeueReusableCell(withIdentifier: "LegendCell", for: indexPath) as! LegendCell
            cell.configureCell(legend: project.legend[indexPath.row])
            if (_firstCell == true) {
                legendTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.styleHighlighted()
                _firstCell = false
            } else {
                cell.styleNormal()
            }
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
            let selectedCell:LegendCell = tableView.cellForRow(at: indexPath)! as! LegendCell
            selectedCell.styleHighlighted()
        }
        if tableView == entryTableView {
            highlightEntry(onEntry: project.entries[self.project.entries.count - (indexPath.row + 1)])
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == legendTableView {
            let selectedCell:LegendCell = tableView.cellForRow(at: indexPath)! as! LegendCell
            selectedCell.styleNormal()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView == entryTableView {
            let addNote = UITableViewRowAction(style: .normal, title: "Note") { action, index in
                self.showEntryNote(indexPath: indexPath, tableView: tableView)
            }
            addNote.backgroundColor = Style.backgroundSecondary
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                self.project.removeEntry(index: self.project.entries.count - (indexPath.row + 1))
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            return [delete, addNote]
        }
      /*  if tableView == legendTableView {
            let delete = UITableViewRowAction(style: .destructive, title: "X") { action, index in
                if self.project.legend.count > 1 {
                    self.project.legend.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    self.resetLegendTableView()
                } else {
                    displayMessage(title: DELETE_LAST_LEGEND_TITLE, message: DELETE_LAST_LEGEND_MSG, self: self)
                }
            }
            return [delete]
        } */
        return [UITableViewRowAction()]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == entryTableView || tableView == legendTableView {
            return true
        }
        return false
    }
    
    func removeAllEntries(action: UIAlertAction) {
        for i in (0..<project.entries.count).reversed() {
            project.removeEntry(index: i)
        }
        entryTableView.reloadData()
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
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        madeChange()
        delegate?.toggleMenu()
    }
    
    @IBAction func addLegendPressed(_ sender: Any) {
        // Segue: AddLegendVC as Popover
    }
    
    @IBAction func deleteHistoryPressed(_ sender: Any) {
        let alert = UIAlertController(title: DELETE_ALL_ENTRIES_TITLE, message: DELETE_ALL_ENTRIES_MSG, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: removeAllEntries))
        self.present(alert, animated: true, completion: nil)
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

extension MappingVC: MappingViewDelegate {
    func mappingViewTouchBegan(sender: MappingView, touches: Set<UITouch>) {
        if let touch = touches.first {
            _centerPos = touch.location(in: mappingView)
        }
        tagNumber += 2
        _angleInDegrees = 999
        createEntryIcon(xPos: _centerPos.x, yPos: _centerPos.y, targetView: mappingView, angleInDegrees: _angleInDegrees, tagId: tagNumber, icon: selectedLegend.icon)
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
        targetView.addSubview(_arrowIcon)
        mappingView.addSubview(_centerIcon)
    }
    
    func rotateImage(imageId: Int, angleToRotate: CGFloat) {
        mappingView.viewWithTag(imageId)?.transform = CGAffineTransform(rotationAngle: -angleToRotate * CGFloat(Double.pi/180))
        mappingView.viewWithTag(imageId + 1)?.transform = CGAffineTransform(rotationAngle: -angleToRotate * CGFloat(Double.pi/180))
    }
    
    func mappingViewTouchMoved(sender: MappingView, touches: Set<UITouch>) {
        if(touchesMovedDeadZone == 0) {
            if(_arrowIcon.isHidden) {
                _arrowIcon.isHidden = false
            }
            if let touch = touches.first {
                let newPos = touch.location(in: mappingView)
                let mPoint = bearingPoint(point0: _centerPos, point1: newPos)
                _angleInDegrees = pointToDegrees(x: mPoint.x, y: mPoint.y)
                rotateImage(imageId: tagNumber, angleToRotate: _angleInDegrees)
            }
        } else {
            touchesMovedDeadZone -= 1
        }
    }
    
    func mappingViewTouchEnded(sender: MappingView, touches: Set<UITouch>) {
        touchesMovedDeadZone = DEADZONE_START_VALUE
        project.addEntry(legend: selectedLegend, angleInDegrees: _angleInDegrees, position: _centerPos!, tagId: tagNumber)
        entryTableView.reloadData()
        madeChange()
    }
}

extension MappingVC: AddLegendDelegate {
    func addLegend(legend: Legend) {
        project.legend.append(legend)
        resetLegendTableView()
        madeChange()
    }
}

extension MappingVC: NoteVCDelegate {
    func addNote(note: String, ofType: Int) {
        if ofType == NOTE_TYPE_ENTRY {
            project.entries[_selectedIndex].note = note
            entryTableView.reloadData()
            madeChange()
        }
        if ofType == NOTE_TYPE_PROJECT {
            project.note = note
            madeChange()
        }
    }
}
