//
//  DiaryTableViewCell.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/6/4.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    let db = DBManager.instance
    let testUserId = "TCA"
    @IBOutlet weak var firstDateMonth: UILabel!
    @IBOutlet weak var firstDateDay: UILabel!
    @IBOutlet weak var secondDateMonth: UILabel!
    @IBOutlet weak var secondDateDay: UILabel!
    
    @IBOutlet weak var diaryName: UILabel!
    
    @IBOutlet weak var placeImg1: UIImageView!
    @IBOutlet weak var placeImg2: UIImageView!
    @IBOutlet weak var placeImg3: UIImageView!
    var isImg1Set: Bool=false
    var isImg2Set: Bool=false
    var isImg3Set: Bool=false

    let defaultImage = UIImage(named: "empty_frog1")
    let defaultImage2 = UIImage(named: "empty_frog2")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUIDisplays(name: String, preDate: String, postDate: String, diaryID: String) {
        self.diaryName.text = name
        
        let start = preDate.index(preDate.startIndex, offsetBy: 4)
        let mid = preDate.index(preDate.startIndex, offsetBy: 6)
        
        let month = preDate[start..<mid]
        let day = preDate[mid...]
        
        self.firstDateMonth.text = String(month)
        self.firstDateDay.text = String(day)
        
        let month2 = postDate[start..<mid]
        let day2 = postDate[mid...]
        
        self.secondDateMonth.text = String(month2)
        self.secondDateDay.text = String(day2)
//
//
//        if image1 != nil {
//            self.placeImg1.image = image1
//        }
//
//        if image2 != nil {
//            self.placeImg2.image = image2
//        }
//
//        if image3 != nil {
//            self.placeImg3.image = image3
//        }
        var diaryDetials = db.getDiaryDetailWithoutTrans(with: diaryID, of:testUserId, of: 1)
        for diaryDetial in diaryDetials{
            let places = db.getPlaceInfo(for: diaryDetial.content)
            if places.count > 0 {
                let image = places[0].getUIImage()
                if image != nil {
                    if !isImg1Set{
                        self.placeImg1.image = image
                        self.isImg1Set = true
                    }else if !isImg2Set{
                        self.placeImg2.image = image
                        self.isImg2Set = true
                    }else if !isImg3Set{
                        self.placeImg3.image = image
                        self.isImg3Set = true
                        break
                    }
                }
            }
        }
       
//        self.placeImg1.image = defaultImage
//        self.placeImg2.image = defaultImage
//        self.placeImg3.image = defaultImage2
        
        
    }

}
