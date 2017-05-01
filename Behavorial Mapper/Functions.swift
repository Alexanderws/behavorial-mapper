//
//  Functions.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

var docController: UIDocumentInteractionController!

func displayMessage(title: String, message: String, self: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: ALERT_CANCEL_TITLE, style: UIAlertActionStyle.cancel, handler: {
        (alertAction: UIAlertAction!) in
        alertController.dismiss(animated: true, completion: nil)
    }))
    self.present(alertController, animated: true, completion: nil)
}

func displayTextEntry(title: String, placeholder: String, self: UIViewController) {
    let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
        
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
        (action : UIAlertAction!) -> Void in
    })
    alertController.addTextField { (textField : UITextField!) -> Void in
        textField.placeholder = placeholder
        textField.textRect(forBounds: CGRect(x: textField.frame.origin.x, y: textField.frame.origin.y, width: 200, height: 400))
    }
    alertController.addAction(cancelAction)
    alertController.addAction(saveAction)
    self.present(alertController, animated: true, completion: nil)
}

func displayTextShare(shareContent: String, self: UIViewController, anchor: UIView) {
    let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = anchor
    // activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
    self.present(activityViewController, animated: true, completion: {})
}

func displayCSVShare(shareContent: String, projectName: String, self: UIViewController, anchor: UIView) {
    let fileName = "\(projectName).csv"
    let contentsOfFile = shareContent
    if let tempPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) {
        do {
            try contentsOfFile.write(to: tempPath, atomically: true, encoding: String.Encoding.utf8)
            print("File \(fileName) created at tmp directory")
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        docController = UIDocumentInteractionController(url: tempPath)
        docController.presentOptionsMenu(from: anchor.frame, in: self.view, animated: true)
    }
}

func displayImageShare(shareContent: UIImage, self: UIViewController, anchor: UIView) {
    let activityViewController = UIActivityViewController(activityItems: [shareContent as UIImage], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = anchor
    // activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
    self.present(activityViewController, animated: true, completion: {})
}

func getWhiteBackground(width: CGFloat, height: CGFloat) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 1)
    UIColor.white.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

func getBackgroundImg(fromProject: Project) -> UIImage? {
    var bkgImage: UIImage?
    if fromProject.background == BACKGROUND_BLANK_STRING {
        bkgImage = getWhiteBackground(width: 2000, height: 2000)
    } else {
        let mapFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("/maps/\(fromProject.name)").appendingPathExtension("map.png")
        let data = try? Data.init(contentsOf: mapFile)
        if let image = UIImage.init(data: data!) {
            bkgImage = image
        }
    }
    return bkgImage!
}

func getImageSnapshot(fromView: UIView) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, false, 3.0)
    fromView.drawHierarchy(in: fromView.bounds, afterScreenUpdates: true)
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    return image
}

func containsText(object: Any) -> Bool {
    return !((object as AnyObject).text!.isEmpty)
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func dateFormat(date: Date)-> String {
    let df = DateFormatter()
    df.dateFormat = "dd MMM yyyy"
    return df.string(from: date)
}

func timeFormat(date: Date)-> String {
    let df = DateFormatter()
    df.dateFormat = "hh:mm:ss"
    return df.string(from: date)
}

func bearingPoint(point0: CGPoint, point1: CGPoint) -> CGPoint {
    let newPoint = CGPoint(x:(point1.x - point0.x), y:(point0.y - point1.y))
    return newPoint
}

func pointToDegrees(x: CGFloat, y: CGFloat) -> CGFloat {
    let bearingRadian = atan2f(Float(y), Float(x))
    return CGFloat(bearingRadian) * (180 / CGFloat(Double.pi))
}

func getCircle(forView: UIView, ofSize: CGFloat) -> CAShapeLayer {
    let x = forView.frame.origin.x
    let y = forView.frame.origin.y
    let circlePath = UIBezierPath(roundedRect: CGRect(x: x - ofSize, y: y - ofSize, width: forView.frame.width + (2 * ofSize), height: forView.frame.width + (2 * ofSize)), cornerRadius: (forView.frame.width + (2 * ofSize)) / 2).cgPath
    
    let circleShape = CAShapeLayer()
    circleShape.path = circlePath
    circleShape.lineWidth = 2
    circleShape.strokeColor = Style.iconPrimary.cgColor
    circleShape.fillColor = UIColor.clear.cgColor
    
    return circleShape
}

func generateCsvString(project: Project) -> String {
    var csvString = String()
    csvString.append(CSV_ENTRY_HEADER + "\n")
    for e in project.entries {
        csvString.append(e.csvBody() + "\n")
    }
    return csvString
}

func getProjectFiles() -> [String]? {
    let projectDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        .appendingPathComponent("/projects/")
    let properties = [URLResourceKey.creationDateKey, URLResourceKey.contentModificationDateKey]
    
    if let projectNameArray = try? FileManager.default.contentsOfDirectory(at: projectDirectory,
                                                                                   includingPropertiesForKeys: properties,
                                                                                   options: .skipsHiddenFiles) {
        return projectNameArray.map({ url -> (String, TimeInterval) in
            let lastModified = try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
            return (url.deletingPathExtension().lastPathComponent, lastModified!!.timeIntervalSinceReferenceDate )
        })
            .sorted(by: {$0.1 > $1.1})
            .map({ $0.0 })
    } else {
        return nil
    }
}

/**
 Deletes the project file correspnding to the given projectName.
 
 - parameters:
    - projectName: Name of the project you wish to delete.
 
 - important:
 Do NOT include the project exstension in the projectName parameter.
 */
func deleteProject(projectName: String) {
    let projectDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        .appendingPathComponent("projects")
    do {
        try FileManager.default.removeItem(at: projectDirectory.appendingPathComponent(projectName).appendingPathExtension("proj"))
    } catch let error {
        print(error.localizedDescription)
    }
}

func createProjectDirectories() {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let mapDir = paths[0].appendingPathComponent("maps/")
    let projectDir = paths[0].appendingPathComponent("projects/")
    do {
        try FileManager.default.createDirectory(at: projectDir, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: mapDir, withIntermediateDirectories: true, attributes: nil)
    } catch let error {
        print("Error: \(error.localizedDescription)")
    }

}

// Doesn't work
func getGPSCoordinates(screenBounds: GMSVisibleRegion, point: CGPoint) -> CLLocationCoordinate2D {
    /*
    let yStd = Double(point.y) / 768.0
    let xStd = Double(point.x) / 824.0

    let latitude = yStd * (screenBounds.farLeft.latitude - screenBounds.nearLeft.latitude) + screenBounds.nearLeft.latitude
    let longitude = xStd * (screenBounds.nearRight.longitude - screenBounds.nearLeft.longitude) + screenBounds.nearLeft.longitude
    */

    let leftLong = screenBounds.farLeft.longitude
    let eastLong = screenBounds.nearRight.longitude
    let deltaLong = eastLong - leftLong

    let northLat = screenBounds.farLeft.latitude
    let southLat = screenBounds.nearLeft.latitude
    let deltaLat = northLat - southLat

    let longitude = eastLong - ((Double(point.x) * deltaLong) / 824)
    let latitude = northLat - ((Double(point.y) * deltaLat) / 768)

    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}

extension Project {
    func saveProject() {
        self.lastSaved = Date()
        
        let data = self.toJSON()
        
        let projectDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("projects")      
        let projectPath = projectDir.appendingPathComponent(self.name).appendingPathExtension("proj")
        try? data?.write(to: projectPath, atomically: true, encoding: .utf8)
        
        print("Wrote project to \(projectPath.absoluteString)")
    }
}

extension UIView {
    func snapshotView() -> UIView? {
        guard let image = snapshotImage() else { return nil }
        return UIImageView(image: image)
    }
    
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 1.0)
        defer { UIGraphicsEndImageContext() }
        
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
