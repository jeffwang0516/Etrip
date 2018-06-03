//
//  FavoriteViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let viewTitle = "我的收藏"
    // User id for test
    let testUserId = "TCA"
    
    let db = DBManager.instance
    
    @IBOutlet weak var tableView: UITableView!
    var placeInfoListToDisplay: [PlaceInfo] = []
    var favoriteLandmark: [PlaceInfo] = []
    var favoriteRestaurant: [PlaceInfo] = []
    var favoriteHotel: [PlaceInfo] = []
    
    @IBOutlet weak var landmarkButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var hotelButton: UIButton!
    
    let colorClicked = UIColor(red: 92/255, green: 0, blue: 0, alpha: 1)
    let colorUnclicked = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = viewTitle
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.favoriteLandmark = db.getFavoritePlaces(of: testUserId, with: Int(PlaceForm.landmark.rawValue))
        self.favoriteRestaurant = db.getFavoritePlaces(of: testUserId, with: Int(PlaceForm.restaurant.rawValue))
        self.favoriteHotel = db.getFavoritePlaces(of: testUserId, with: Int(PlaceForm.hotel.rawValue))
        
        self.placeInfoListToDisplay = self.favoriteLandmark
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchFavorite(_ sender: UIButton) {
        switch sender {
            case landmarkButton:
                landmarkButton.backgroundColor = colorClicked
                restaurantButton.backgroundColor = colorUnclicked
                hotelButton.backgroundColor = colorUnclicked
                
                placeInfoListToDisplay = self.favoriteLandmark
                //search favoriteLM and list in table view
            case restaurantButton:
                restaurantButton.backgroundColor = colorClicked
                landmarkButton.backgroundColor = colorUnclicked
                hotelButton.backgroundColor = colorUnclicked
                
                placeInfoListToDisplay = self.favoriteRestaurant
                //search favoriteRest and list in table view
            case hotelButton:
                hotelButton.backgroundColor = colorClicked
                landmarkButton.backgroundColor = colorUnclicked
                restaurantButton.backgroundColor = colorUnclicked
                
                placeInfoListToDisplay = self.favoriteHotel
                //search favoriteHotel and list in table view
            default:
                landmarkButton.backgroundColor = colorClicked
                restaurantButton.backgroundColor = colorUnclicked
                hotelButton.backgroundColor = colorUnclicked
                //search favoriteLM and list in table view
        }
        
        self.tableView.reloadData()
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenPlaceDetailFromFavorite" {
            guard let cell = sender as? UITableViewCell else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpeningDetail(for: segue, sender: cell)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: UITableViewCell) {
        
        let placeInfoViewController = segue.destination as! PlaceInfoDetailViewController
        let senderPath = self.tableView.indexPath(for: sender)!
        let placeInfo = placeInfoListToDisplay[senderPath.row]
        placeInfoViewController.placeInfo = placeInfo
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeInfoListToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeCell = tableView.dequeueReusableCell(withIdentifier: "PlaceCellFavorite", for: indexPath) as! PlaceTableViewCell
        let placeInfo = placeInfoListToDisplay[indexPath.row]
        
        placeCell.updateUIDisplays(name: placeInfo.name, address: placeInfo.address, rateScore: placeInfo.score, image: placeInfo.getUIImage(),ticket: placeInfo.ticket.hashValue)
        
        return placeCell
    }
    
    
}

