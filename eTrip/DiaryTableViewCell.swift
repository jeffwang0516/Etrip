//
//  DiaryTableViewCell.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/6/4.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstDateMonth: UILabel!
    @IBOutlet weak var firstDateDay: UILabel!
    @IBOutlet weak var secondDateMonth: UILabel!
    @IBOutlet weak var secondDateDay: UILabel!
    
    @IBOutlet weak var diaryName: UILabel!
    
    @IBOutlet weak var placeImg1: UIImageView!
    @IBOutlet weak var placeImg2: UIImageView!
    @IBOutlet weak var placeImg3: UIImageView!
    
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
        self.placeImg1.image = defaultImage
        self.placeImg2.image = defaultImage
        self.placeImg3.image = defaultImage2
        
        
    }

}
