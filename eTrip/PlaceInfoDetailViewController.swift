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
    var cellThatTriggered: PlaceTableViewCell?
    
    @IBOutlet weak var placeImg: UIImageView!
    @IBOutlet weak var placeName: UILabel!
//    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var likeImg: UIButton!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var scoreStar: CosmosView!
    
//    @IBOutlet weak var addressText: UILabel!
//    @IBOutlet weak var phoneText: UILabel!
    @IBOutlet weak var addressText: UIButton!
    @IBOutlet weak var phoneText: UIButton!
    
    
    @IBOutlet weak var ticketText: UILabel!
    @IBOutlet weak var introdutionText: UITextView!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    let defaultImage = UIImage(named: "icon")
    
    override func viewWillAppear(_ animated: Bool) {

        if navBarItem != nil {
            navBarItem.title = "景點介紹"
        }
        self.placeName.text = placeInfo?.name
        self.addressText.setTitle(placeInfo?.address, for: UIControlState.normal)
        loadScore()
        if placeInfo?.getUIImage() != nil {
            self.placeImg.image = placeInfo?.getUIImage()
        } else {
            self.placeImg.image = defaultImage
        }
        self.introdutionText.text = (placeInfo?.abstract)!+"。"
        
        setLikeImg()
        
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
            self.phoneText.setTitle(placeInfo?.phone, for: UIControlState.normal)
        }else{
            self.phoneText.setTitle("查無資料。", for: UIControlState.normal)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let placeInfo = placeInfo {
            self.cellThatTriggered?.updateUIDisplays(name: placeInfo.name, address: placeInfo.address, rateScore: placeInfo.score, image: placeInfo.getUIImage(),ticket: placeInfo.ticket.hashValue)
        }
    }
    
    @IBAction func customBackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func changeScore(_ sender: Any) {
        //改評分
    }
    
    @IBAction func changeLike(_ sender: Any) {
        let isChangeLikeSuccess = db.alterFavorites(of: testUserId,placeid: (placeInfo?.id)!)
        setLikeImg()
        
        // Refresh view in favorite view
        let allControllers = navigationController?.viewControllers[0].childViewControllers
        if let favoriteTab = allControllers?[2] as? FavoriteViewController {
            favoriteTab.refreshDataAndTable()
        }
    }
    
    //IBAction likeChange
    func setLikeImg(){
        if db.ifPlaceIsFavorite(of: testUserId, placeid: (placeInfo?.id)!){
            self.likeImg.setImage(UIImage(named: "like"), for: UIControlState.normal)
        }else{
            self.likeImg.setImage(UIImage(named: "unlike"), for: UIControlState.normal)
        }
    }
    
    //IBAction openMap
    @IBAction func openMap(_ sender: Any) {
    }
    
    //IBAction phoneCall
    @IBAction func phoneCall(_ sender: Any) {
        if !(placeInfo?.phone.isEmpty)! {
            if let url = URL(string: "tel://\(placeInfo!.phone)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
    }
    
    func loadScore(){
        let avgScore = NSString(format:"%.1f", (placeInfo?.score.average)!)
        let ratePeopleCount = Int(Double((placeInfo?.score.total)!) / (placeInfo?.score.average)!)
        self.scoreText.text = "\(avgScore) 分,\n共\(ratePeopleCount)人評分"
        if self.scoreStar != nil {
            self.scoreStar.rating = (placeInfo?.score.average)!
        }
        
    }
    
    func refresh() {
        self.placeInfo = db.getPlaceInfo(for: placeInfo!.id).first
        viewWillAppear(true)
        
    }
    //只有繼承UIControl的View才能設Action
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenScoreChangeView" {
            guard let button = sender as? UIButton else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpeningDetail(for: segue, sender: button)
            
        } else if segue.identifier == "OpenMap" {
            guard let button = sender as? UIButton else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpenMap(for: segue, sender: button)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: UIButton) {
        
        
        let scoreChangeViewController = segue.destination as! ScoreChangeViewController
        
        
        
        scoreChangeViewController.placeid = placeInfo?.id
        scoreChangeViewController.prevViewController = self
    }
    
    private func prepareOpenMap(for segue: UIStoryboardSegue, sender: UIButton) {
        
        
        let mapViewController = segue.destination as! MapViewController
        mapViewController.placeInfo = self.placeInfo
    }
}
