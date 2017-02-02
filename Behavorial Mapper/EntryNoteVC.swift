//
//  EntryNotesVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 25/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit


protocol EntryNoteDelegate {
    func noteAdded(note: String)
}

class EntryNoteVC: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var noteTxtView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    private var _entry: Entry!
    private var _index: Int!
    
    var entryNoteDelegate: EntryNoteDelegate?
    
    var entry: Entry {
        get {
            return _entry
        } set {
            _entry = newValue
        }
    }
    
    var index: Int {
        get {
            return _index
        } set {
            _index = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTxtView.text = entry.note
    }

    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        entryNoteDelegate?.noteAdded(note: noteTxtView.text)
        dismiss(animated: true, completion: nil)
    }
    
    

}
