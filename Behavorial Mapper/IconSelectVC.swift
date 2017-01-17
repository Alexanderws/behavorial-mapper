//
//  IconSelectVC.swift
//  Behavorial Mapper
//
//  Created by Alexander on 11/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

class IconSelectVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var iconCollection: UICollectionView!

    var iconArray = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // iconCollection.dataSource = self
       // iconCollection.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCell
            cell.configureCell(indexPath.row)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return NUMBER_OF_ICONS
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.presentingViewController as? CreateProjectVC {
            vc.enterLegendIcon(iconId: indexPath.row)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ICON_CELL_SIZE, height: ICON_CELL_SIZE)
    }
    
  
    
    
}
