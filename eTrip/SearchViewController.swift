//
//  SearchViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Query only while first time loading
        if placeInfos.count == 0 {
            self.placeInfos = self.db.searchForPlaceInfos(with: "", of: Int(PlaceForm.all.rawValue))
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        activityIndicator.isHidden = true
        
        landmarkButton.backgroundColor = colorClicked
        restaurantButton.backgroundColor = colorClicked
        hotelButton.backgroundColor = colorClicked
//        searchBar.contro
//
//        self.searchController = ({
//            let controller = UISearchController(searchResultsController: nil)
//            controller.searchBar.delegate = self
//        })()
//
//        self.searchController.isActive = true
//        self.searchController.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let colorClicked = UIColor(red: 92/255, green: 0, blue: 0, alpha: 1)
    let colorUnclicked = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender {
            case landmarkButton:
                if isLandMarkButtonClicked {
                    landmarkButton.backgroundColor = colorUnclicked
                    isLandMarkButtonClicked = false
                } else {
                    landmarkButton.backgroundColor = colorClicked
                    isLandMarkButtonClicked = true
                }
            
            //search favoriteLM and list in table view
            case restaurantButton:
                if isRestaurantButtonClicked {
                    restaurantButton.backgroundColor = colorUnclicked
                    isRestaurantButtonClicked = false
                } else {
                    restaurantButton.backgroundColor = colorClicked
                    isRestaurantButtonClicked = true
                }
            //search favoriteRest and list in table view
            case hotelButton:
                if isHotelButtonClicked {
                    hotelButton.backgroundColor = colorUnclicked
                    isHotelButtonClicked = false
                } else {
                    hotelButton.backgroundColor = colorClicked
                    isHotelButtonClicked = true
                }
            //search favoriteHotel and list in table view
            default:
                landmarkButton.backgroundColor = colorUnclicked
                restaurantButton.backgroundColor = colorUnclicked
                hotelButton.backgroundColor = colorUnclicked
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
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        placeCell.updateUIDisplays(name: placeInfo.name, address: placeInfo.address, rateScore: placeInfo.score, image: placeInfo.getUIImage())
        
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
