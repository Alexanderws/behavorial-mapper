//
//  Constants.swift
//  Behavorial Mapper
//
//  Created by Alexander on 11/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

// GENERAL STRINGS
let TITLE_LABEL = "Behavioral Mapping"

// StartVC
let INITIAL_NOTES_TEXT = "No project selected"

// MappingVC
let VIEW_ALL = 1
let VIEW_10 = 2
let VIEW_NONE = 3

let CENTER_ICON_SIZE: CGFloat = 35
let ARROW_ICON_SIZE: CGFloat = 35

let MENU_EXPAND_OFFSET: CGFloat = 200

let HIGHLIGHT_CIRCLE_INIT_SIZE: CGFloat = 3

// GoogleMapsVC
let MAPPING_VIEW_SIZE = CGSize(width: 824, height: 768)

// Icons in CreateProjectVC
let NUMBER_OF_ICONS = 25
let ICON_CELL_SIZE = 35


// Map selection in CreateProjectVC
let BACKGROUND_IMAGE_UPLOADED = 1
let BACKGROUND_GOOGLE_MAPS = 2
let BACKGROUND_BLANK = 3

let BACKGROUND_GOOGLE_MAPS_STRING = "maps-icon-16"
let BACKGROUND_IMAGE_UPLOADED_STRING = "ImageIcon"
let BACKGROUND_BLANK_STRING = "BLANK"

// WARNING MESSAGES
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

// Sizes
let LEGEND_TABLEVIEW_CELL_HEIGHT = 47
let ENTRY_TABLEVIEW_CELL_HEIGHT = 60
let DEADZONE_START_VALUE = 5

// CSV HEADERS
let CSV_TIME = "Tidspunkt"
let CSV_COORDINATES = "Koordinater"
let CSV_ANGLE_IN_DEGREES = "Vinkel i grader"
let CSV_ENTRY_NOTE = "Notat"
let CSV_ENTRY_NAME = "Type"
let CSV_ENTRY_ICON = "Ikon"
let CSV_ENTRY_HEADER = "\(CSV_TIME);\(CSV_COORDINATES);\(CSV_ANGLE_IN_DEGREES);\(CSV_ENTRY_NOTE);\(CSV_ENTRY_NAME);\(CSV_ENTRY_ICON)"
let CSV_X_COORDINATE = "X-koordinat"
let CSV_Y_COORDINATE = "Y-koordinat"
let CSV_LOCATION_NAME = "Ikke i bruk"
