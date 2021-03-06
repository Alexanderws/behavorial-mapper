//
//  Constants.swift
//  Behavorial Mapper
//
//  Created by Alexander on 11/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

// StartVC
let INITIAL_NOTES_TEXT = "No project selected"
let NO_NOTE_FOUND_TEXT = "No notes found"

// MappingVC
let VIEW_ALL = 1
let VIEW_10 = 2
let VIEW_NONE = 3

let LEGEND_TABLEVIEW_CELL_HEIGHT = 47
let ENTRY_TABLEVIEW_CELL_HEIGHT = 60
let DEADZONE_START_VALUE = 5

let CENTER_ICON_SIZE: CGFloat = 35
let ARROW_ICON_SIZE: CGFloat = 35
let MENU_EXPAND_OFFSET: CGFloat = 210
let HIGHLIGHT_CIRCLE_INIT_SIZE: CGFloat = 3

// GoogleMapsVC
let MAPPING_VIEW_SIZE = CGSize(width: 824, height: 768)

// NoteVC
let NOTE_TYPE_ENTRY: Int = 1
let NOTE_TYPE_PROJECT: Int = 2

// CreateProjectVC
let NUMBER_OF_ICONS = 25
let ICON_CELL_SIZE = 35

let BACKGROUND_IMAGE_UPLOADED = 1
let BACKGROUND_GOOGLE_MAPS = 2
let BACKGROUND_BLANK = 3

let BACKGROUND_GOOGLE_MAPS_STRING = "mapsIcon"
let BACKGROUND_IMAGE_UPLOADED_STRING = "imageIcon"
let BACKGROUND_BLANK_STRING = "blankIcon"

// WARNING MESSAGES
let DELETE_PROJECT_TITLE = "Delete project"
let DELETE_PROJECT_MSG = "Delete project and contained data?"
let NO_PROJECT_NAME_TITLE = "No project name"
let NO_PROJECT_NAME_MSG = "Enter a name for your project."
let NO_LEGEND_NAME_TITLE = "No legend name"
let NO_LEGEND_NAME_MSG = "Enter a name for the legend entry."
let NO_LEGEND_ENTERED_TITLE = "No legends entered"
let NO_LEGEND_ENTERED_MSG = "You need at least 1 legend."
let DELETE_LAST_LEGEND_TITLE = "Can't delete legend"
let DELETE_LAST_LEGEND_MSG = "You need at least 1 legend."
let ALERT_CANCEL_TITLE = "Dismiss"
let DELETE_ALL_ENTRIES_TITLE = "Delete entries"
let DELETE_ALL_ENTRIES_MSG = "Delete all recorded entries?"
let NO_PROJECT_SELECTED_TITLE = "No project selected"
let NO_PROJECT_SELECTED_MSG = "You need to select a project to do this."

// CSV HEADERS
let CSV_TIME = "Time"
let CSV_COORDINATES = "Position"
let CSV_ANGLE_IN_DEGREES = "Angle in degrees"
let CSV_ENTRY_NOTE = "Note"
let CSV_ENTRY_NAME = "Type"
let CSV_ENTRY_ICON = "Icon"
let CSV_ENTRY_HEADER = "\(CSV_TIME);\(CSV_COORDINATES);\(CSV_ANGLE_IN_DEGREES);\(CSV_ENTRY_NOTE);\(CSV_ENTRY_NAME);\(CSV_ENTRY_ICON)"
let CSV_X_COORDINATE = "X-coordinate"
let CSV_Y_COORDINATE = "Y-coordinate"
let CSV_LOCATION_NAME = "Not in use"
