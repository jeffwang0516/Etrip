//
//  PlaceInfoDetailViewController.swift
//  eTrip
//
//  Created by JeffWang on 2018/5/31.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import UIKit

class PlaceInfoDetailViewController: UIViewController {
    
    var placeInfo: PlaceInfo?
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        guard let titleText = placeInfo?.name else {
            navBarItem.title = "景點介紹"
            return
        }
        navBarItem.title = titleText
    }
}
