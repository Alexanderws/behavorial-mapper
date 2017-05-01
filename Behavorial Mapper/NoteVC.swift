//
//  NoteVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 28/04/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

protocol NoteVCDelegate {
    func addNote(note: String, ofType: Int)
}

class NoteVC: UIViewController {
    
    @IBOutlet weak var noteTxtVw: UITextView!
    @IBOutlet weak var bkgVw: UIView!
    @IBOutlet weak var titleLbl: TitleLbl!
    
    var currentNote: String?
    var senderType: Int?
    var noteDelegate: NoteVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initStyle()
        if let currentNote = currentNote {
            noteTxtVw.text = currentNote
        }
        if senderType == NOTE_TYPE_PROJECT {
            titleLbl.text = "PROJECT NOTES"
        } else {
            titleLbl.text = "NOTE"
        }
    }

    func initStyle(){
        bkgVw.backgroundColor = Style.backgroundPrimary
    }
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if let senderType = senderType {
            noteDelegate?.addNote(note: noteTxtVw.text, ofType: senderType)
        }
        dismiss(animated: true, completion: nil)
    }


}
