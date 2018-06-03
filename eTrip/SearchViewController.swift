//
//  SearchViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {

    let viewTitle = "搜尋"
    let db = DBManager.instance
    
    @IBOutlet weak var landmarkButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var hotelButton: UIButton!
    
    var isLandMarkButtonClicked = true
    var isRestaurantButtonClicked = true
    var isHotelButtonClicked = true
    var placeFormCodeForQuery = Int(PlaceForm.all.rawValue)
    
    @IBOutlet weak var tableView: UITableView!
    var placeInfos: [PlaceInfo] = []
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = viewTitle
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Query only while first time loading
        if placeInfos.count == 0 {
            self.placeInfos = self.db.searchForPlaceInfos(with: "", of: Int(PlaceForm.all.rawValue))
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 249.0/255.0, green: 199.0/255.0, blue: 60.0/255.0, alpha: 1.0)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        activityIndicator.isHidden = true
        
        landmarkButton.backgroundColor = UIColor.clear
        restaurantButton.backgroundColor = UIColor.clear
        hotelButton.backgroundColor = UIColor.clear
        buttonHightlight(landmarkButton)
        buttonHightlight(restaurantButton)
        buttonHightlight(hotelButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let colorClicked = UIColor(red: 92/255, green: 0, blue: 0, alpha: 1)
    let colorUnclicked = UIColor(red: 177/255, green: 177/255, blue: 177/255, alpha: 1)
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender {
            case landmarkButton:
                if isLandMarkButtonClicked {
                    buttonLowlight(landmarkButton)
                    isLandMarkButtonClicked = false
                } else {
                    buttonHightlight(landmarkButton)
                    isLandMarkButtonClicked = true
                }
            
            //search favoriteLM and list in table view
            case restaurantButton:
                if isRestaurantButtonClicked {
                    buttonLowlight(restaurantButton)
                    isRestaurantButtonClicked = false
                } else {
                    buttonHightlight(restaurantButton)
                    isRestaurantButtonClicked = true
                }
            //search favoriteRest and list in table view
            case hotelButton:
                if isHotelButtonClicked {
                    buttonLowlight(hotelButton)
                    isHotelButtonClicked = false
                } else {
                    buttonHightlight(hotelButton)
                    isHotelButtonClicked = true
                }
            //search favoriteHotel and list in table view
            default:
                buttonHightlight(landmarkButton)
                buttonHightlight(restaurantButton)
                buttonHightlight(hotelButton)
                //search favoriteLM and list in table view
        }
        
        var form = ""
        if isLandMarkButtonClicked { form.append("\(PlaceForm.landmark.rawValue)")}
        if isRestaurantButtonClicked { form.append("\(PlaceForm.restaurant.rawValue)")}
        if isHotelButtonClicked { form.append("\(PlaceForm.hotel.rawValue)")}
        
        guard let code = Int(form) else {
            self.placeFormCodeForQuery = Int(PlaceForm.all.rawValue)
            return
        }
        self.placeFormCodeForQuery = code
    }
    
    func buttonLowlight(_ button: UIButton){
        button.setTitleColor(colorUnclicked, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 18)
    }
    func buttonHightlight(_ button: UIButton){
        button.setTitleColor(colorClicked, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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
        if segue.identifier == "OpenPlaceDetailFromSearch" {
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
        let placeInfo = placeInfos[senderPath.row]
        placeInfoViewController.placeInfo = placeInfo
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeCell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let placeInfo = placeInfos[indexPath.row]
        
//        placeCell.updateUIDisplays(name: placeInfo.name, address: placeInfo.address, rateScore: placeInfo.score, image: placeInfo.getUIImage())
        placeCell.updateUIDisplays(name: placeInfo.name, address: placeInfo.address, rateScore: placeInfo.score, image: placeInfo.getUIImage(),ticket: placeInfo.ticket.hashValue)
        
        
        return placeCell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
   
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchString = searchBar.text,  searchString.count > 0 else {
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        self.tableView.isUserInteractionEnabled = false
        DispatchQueue.global().async {
//            print(self.placeFormCodeForQuery)
            self.placeInfos = self.db.searchForPlaceInfos(with: searchString, of: self.placeFormCodeForQuery)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.isUserInteractionEnabled = true
            }          
        }
    
        self.searchBar.endEditing(true)
        searchActive = false;
    }
}
