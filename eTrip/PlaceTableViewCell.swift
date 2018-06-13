//
//  PlaceTableViewCell.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var rateScoreLabel: UILabel!
    
    @IBOutlet weak var ticketLabel: UILabel!
    let defaultImage = UIImage(named: "icon")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected,
                          animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUIDisplays(name: String, address: String, rateScore: Score, image: UIImage?,ticket: Int) {
        self.placeNameLabel.text = name
        self.addressLabel.text = address
        let avgScore = NSString(format:"%.1f", rateScore.average)
        let ratePeopleCount = Int(Double(rateScore.total) / rateScore.average)
        self.rateScoreLabel.text = "\(avgScore) 分, 共\(ratePeopleCount)人評分"
        if image != nil {
            self.previewImageView.image = image
        } else {
            self.previewImageView.image = defaultImage
        }
        if ticket == -1{
            self.ticketLabel.text = "查無資料。"
        }else{
            self.ticketLabel.text = String(ticket)
        }
        
    }
    func updateUIDisplays(name: String, address: String, rateScore: Score, image: UIImage?) {
        self.placeNameLabel.text = name
        self.addressLabel.text = address
        let avgScore = NSString(format:"%.1f", rateScore.average)
        let ratePeopleCount = Int(Double(rateScore.total) / rateScore.average)
        self.rateScoreLabel.text = "\(avgScore) 分, 共\(ratePeopleCount)人評分"
        if image != nil {
            self.previewImageView.image = image
        } else {
            self.previewImageView.image = defaultImage
        }
        
    }
    

}
