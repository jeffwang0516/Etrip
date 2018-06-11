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
        db.test()
        // TESTs for Database read
        placeInfos = db.searchForPlaceInfos(by: 243, with: LandmarkWay.all)
        for place in placeInfos {
            image.image = place.getUIImage()
            
            print(place.id, place.name, place.score )
            break
        }
        
        print(placeInfos.count)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }


}

