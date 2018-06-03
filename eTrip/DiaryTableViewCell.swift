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
//        self.firstDateMonth.text = 
//        self.firstDateDay.text =
//        self.secondDateMonth.text =
//        self.secondDateDay.text =
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
        
        
    }

}
