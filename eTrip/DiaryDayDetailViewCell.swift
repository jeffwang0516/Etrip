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
        UIImage(named: "house_blue_square"),
        UIImage(named: "home")
    ]
    
    
    func updateUIDisplays(detail: DiaryDetail) {
//        detail.
        if detail.tag == 1 {
            timeLineImg.image = UIImage(named: "time_line_resume")
            placeTypeImg.image = imgCollection[Int(detail.form.rawValue) - 1]
            
            placeAbstractText.text = detail.name
            
            var startHour,startMin,endHour,endMin:String
            if detail.startTime/100 < 10{
                startHour = "0\(String(detail.startTime/100))"
            }else{
                startHour = String(detail.startTime/100)
            }
            
            if detail.startTime%100 < 10{
                startMin = "0\(String(detail.startTime%100))"
            }else{
                startMin = String(detail.startTime%100)
            }
            
            if detail.endTime/100 < 10{
                endHour = "0\(String(detail.endTime/100))"
            }else{
                endHour = String(detail.endTime/100)
            }
            
            if detail.endTime%100 < 10{
                endMin = "0\(String(detail.endTime%100))"
            }else{
                endMin = String(detail.endTime%100)
            }
            
//            startTime.text = String(detail.startTime)
            startTime.text = "\(startHour):\(startMin)"
//            endTime.text = String(detail.endTime)
            endTime.text = "\(endHour):\(endMin)"
            
        } else {
            timeLineImg.image = UIImage(named: "time_line")
            if detail.content == 3 {
                placeTypeImg.image = UIImage(named: "transport_car")
            } else {
                placeTypeImg.image = UIImage(named: "transport_bus")
            }
            placeAbstractText.text = ""
            startTime.text = ""
            endTime.text = ""
        }
        
        
    }
    
    
    
}
