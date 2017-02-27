//
//  Functions.swift
//  Behavorial Mapper
//
//  Created by Alexander on 12/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation
import UIKit

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
    UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
    UIColor.white.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

func getImageSnapshot(fromView: UIView) -> UIImage {
    let snapShot:UIView = fromView.snapshotView(afterScreenUpdates: true)!
    UIGraphicsBeginImageContextWithOptions(fromView.frame.size, false, UIScreen.main.scale)
    snapShot.drawHierarchy(in: fromView.bounds, afterScreenUpdates: true)
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    return image
}

extension UIColor {
    /**
     Creates a UIColor from a standard 0xRRGGBB color representation.
     
     - parameters:
        - hex: Color in 0xRRGGBB hex representation.
     
     - important:
     Does not support alpha values.
     */
    class func fromHex(hex: Int) -> UIColor {
        let red: CGFloat = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green: CGFloat = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue: CGFloat = CGFloat(hex & 0xFF) / 255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

func containsText(object: Any) -> Bool {
    return !((object as AnyObject).text!.isEmpty)
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
    return CGFloat(bearingRadian) * (180 / CGFloat(M_PI))
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
                                                                                   options:.skipsHiddenFiles) {
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

extension Project {
    func saveProject() {
        self.lastSaved = Date()
        
        let data = self.toJSON()
        
        let projectDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("projects")

        do {
            try FileManager.default.createDirectory(at: projectDir, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
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
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, contentScaleFactor)
        defer { UIGraphicsEndImageContext() }
        
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
