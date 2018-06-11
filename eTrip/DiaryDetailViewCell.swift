//
//  DiaryDetailViewCell.swift
//  eTrip
//
//  Created by JeffWang on 2018/6/4.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import UIKit

class DiaryDetailViewCell: UITableViewCell {
    
    let db = DBManager.instance
    
    var day: Int = 1
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var planImg1: UIImageView!
    @IBOutlet weak var planLabel1: UILabel!
    @IBOutlet weak var planImg2: UIImageView!
    @IBOutlet weak var planLabel2: UILabel!
    @IBOutlet weak var planImg3: UIImageView!
    @IBOutlet weak var planLabel3: UILabel!
    @IBOutlet weak var planImg4: UIImageView!
    @IBOutlet weak var planLabel4: UILabel!
    @IBOutlet weak var arrow1: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow3: UIImageView!
    @IBOutlet weak var arrow4: UIImageView!
    
    let imgCollection = [
        UIImage(named: "landscape_green_square"),
        UIImage(named: "restaurant_red_square"),
        UIImage(named: "house_blue_square")
    ]
    
   
    
    var diaryDetailOfDay: [DiaryDetail] = []
    
    func updateUIDisplays(diaryId: String, userid: String, day: Int) {
        
        self.dayLabel.text = "DAY \(day)"
        self.diaryDetailOfDay = db.getDiaryDetailWithoutTrans(with: diaryId, of: userid, of: day)
        
        guard diaryDetailOfDay.count >= 1 else {
            hideFirst()
            return
        }
        let item1 = diaryDetailOfDay[0]
        self.planLabel1.text = item1.name
        self.planImg1.image = imgCollection[Int(item1.form.rawValue) - 1]
        
        guard diaryDetailOfDay.count >= 2 else {
            hideSec()
            return
        }
        let item2 = diaryDetailOfDay[1]
        self.planLabel2.text = item2.name
        self.planImg2.image = imgCollection[Int(item2.form.rawValue) - 1]
        

        guard diaryDetailOfDay.count >= 3 else {
            hideThird()
            return
        }
        let item3 = diaryDetailOfDay[2]
        self.planLabel3.text = item3.name
        self.planImg3.image = imgCollection[Int(item3.form.rawValue) - 1]

        guard diaryDetailOfDay.count >= 4 else {
            hideForth()
            return
        }
        let item4 = diaryDetailOfDay[3]
        self.planLabel4.text = item4.name
        self.planImg4.image = imgCollection[Int(item4.form.rawValue) - 1]
       
        
    }
    
    private func hideFirst() {
        self.planImg1.isHidden = true
        self.planLabel1.isHidden = true
        
        hideSec()
    }
    private func hideSec() {
        self.planImg2.isHidden = true
        self.planLabel2.isHidden = true
        self.arrow1.isHidden = true
        
        hideThird()
    }
    private func hideThird() {
        self.planImg3.isHidden = true
        self.planLabel3.isHidden = true
        self.arrow2.isHidden = true
        
        hideForth()
    }
    private func hideForth() {
        self.planImg4.isHidden = true
        self.planLabel4.isHidden = true
        self.arrow4.isHidden = true
        self.arrow3.isHidden = true
    }
}
