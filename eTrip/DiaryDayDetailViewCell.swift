//
//  DiaryDayDetailViewCell.swift
//  eTrip
//
//  Created by JeffWang on 2018/6/5.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import UIKit

class DiaryDayDetailViewCell: UITableViewCell {
    
    @IBOutlet weak var placeTypeImg: UIImageView!
    
    @IBOutlet weak var timeLineImg: UIImageView!
    
    @IBOutlet weak var placeAbstractText: UILabel!
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    let imgCollection = [
        UIImage(named: "landscape_green_square"),
        UIImage(named: "restaurant_red_square"),
        UIImage(named: "house_blue_square")
    ]
    
    
    func updateUIDisplays(detail: DiaryDetail) {
//        detail.
        if detail.tag == 1 {
            timeLineImg.image = UIImage(named: "time_line_resume")
            placeTypeImg.image = imgCollection[Int(detail.form.rawValue) - 1]
            
            placeAbstractText.text = detail.name
            startTime.text = String(detail.startTime)
            endTime.text = String(detail.endTime)
            
            
        } else {
            timeLineImg.image = UIImage(named: "time_line")
            placeTypeImg.image = UIImage(named: "transport_car")
            placeAbstractText.text = ""
            startTime.text = ""
            endTime.text = ""
        }
        
        
    }
    
    
    
}
