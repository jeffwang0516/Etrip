//
//  ViewController.swift
//  eTrip
//
//  Created by JeffWang on 2018/5/27.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UITableViewController {

    
    @IBOutlet weak var image: UIImageView!
    var db: DBManager!
    var placeInfos: [PlaceInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = DBManager.instance
        
        // TESTs for Database read
        placeInfos = db.searchForPlaceInfos(with: "石門旗艦", of: 4)
        if placeInfos.count > 0 {
            let place = placeInfos[0]
            image.image = place.getUIImage()
            
            print(place.name, place.lng, "  ", place.lat)
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }


}

