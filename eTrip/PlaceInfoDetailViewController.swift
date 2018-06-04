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
    let testUserId = "TCA"
    let db = DBManager.instance
    
    @IBOutlet weak var placeImg: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var scoreText: UILabel!
    
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    @IBOutlet weak var ticketText: UILabel!
    @IBOutlet weak var introdutionText: UITextView!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    let defaultImage = UIImage(named: "icon")
    
    override func viewWillAppear(_ animated: Bool) {
        navBarItem.title = "景點介紹"
        self.placeName.text = placeInfo?.name
        self.addressText.text = placeInfo?.address
        let avgScore = NSString(format:"%.1f", (placeInfo?.score.average)!)
        let ratePeopleCount = Int(Double((placeInfo?.score.total)!) / (placeInfo?.score.average)!)
        self.scoreText.text = "\(avgScore) 分,\n共\(ratePeopleCount)人評分"
        if placeInfo?.getUIImage() != nil {
            self.placeImg.image = placeInfo?.getUIImage()
        } else {
            self.placeImg.image = defaultImage
        }
        self.introdutionText.text = (placeInfo?.abstract)!+"。"
        if db.ifPlaceIsFavorite(of: testUserId, placeid: (placeInfo?.id)!){
            self.likeImg.image = UIImage(named: "like")
        }else{
            self.likeImg.image = UIImage(named: "unlike")
        }
        let ticketInfos = db.getTickcetInfos(of: (placeInfo?.id.hashValue)!)
        var ticketString = ""
        for (i,ticketInfo) in ticketInfos.enumerated(){
            if i == 0{
                ticketString += "\(ticketInfo.identity):\(ticketInfo.cost)"
            }else if i % 2 == 0 {
                ticketString += "\n\(ticketInfo.identity):\(ticketInfo.cost)"
            }else{
                ticketString += "\t\t\(ticketInfo.identity):\(ticketInfo.cost)"
            }
        }
        
        if ticketString.isEmpty{
            self.ticketText.text = "查無資料。"
        }else{
            self.ticketText.text = ticketString
        }
        
        if !(placeInfo?.phone.isEmpty)! {
            self.phoneText.text = placeInfo?.phone
        }else{
            self.phoneText.text = "查無資料。"
        }
        
        
    }
    
    @IBAction func changeScore(_ sender: Any) {
        //改評分
    }
    
    //IBAction likeChange
    //IBAction openMap
    //IBAction phoneCall
    //只有繼承UIControl的View才能設Action
}
