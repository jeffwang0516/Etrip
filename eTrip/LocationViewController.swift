//
//  LocationViewController.swift
//  eTrip
//
//  Created by JeffWang on 2018/5/31.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    let viewTitle = "地區排行"
    
    let db = DBManager.instance
    
    @IBOutlet weak var cityDropdown: ZHDropDownMenu!
    @IBOutlet weak var districtDropDown: ZHDropDownMenu!
    
    @IBOutlet weak var tableView: UITableView!
    var placeInfos: [PlaceInfo] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = viewTitle
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.cityDropdown.options = db.getAllCityNames()
        let firstCity = self.cityDropdown.options.first
        self.cityDropdown.defaultValue = firstCity
        
        self.cityDropdown.showBorder = false
        self.cityDropdown.menuId = 1
        self.cityDropdown.delegate = self
        
        if firstCity != nil{
            self.districtDropDown.options = db.getCityDistrict(city: firstCity!)
        }
        self.districtDropDown.menuId = 2
        self.districtDropDown.delegate = self
    }
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.placeInfos = self.db.searchForPlaceInfos(with: "", of: Int(PlaceForm.all.rawValue))
            self.tableView.reloadData()
        }
    }
    
    @IBAction func buttonAllAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.placeInfos = self.db.searchForPlaceInfos(with: "", of: Int(PlaceForm.all.rawValue))
            self.refreshTable()
        }
    }
    
    func refreshTable() {
        self.tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        if segue.identifier == "OpenPlaceDetailFromLoacation" {
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

extension LocationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeCell = tableView.dequeueReusableCell(withIdentifier: "PlaceCellLocation", for: indexPath) as! PlaceTableViewCell
        let placeInfo = placeInfos[indexPath.row]
        
        placeCell.updateUIDisplays(name: placeInfo.name, address: placeInfo.address, rateScore: placeInfo.score, image: placeInfo.getUIImage(),ticket: placeInfo.ticket.hashValue)
        
        return placeCell
    }
    
}

extension LocationViewController: ZHDropDownMenuDelegate {
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        
        
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        // City Selected
        if menu.menuId == 1 {
            let cityName = self.cityDropdown.options[index]
            
            self.districtDropDown.options = db.getCityDistrict(city: cityName)
            self.districtDropDown.defaultValue = "請選擇"
            
        } else {
            // District selected
            let districtName = self.districtDropDown.options[index]
            if let cityName = self.cityDropdown.contentTextField.text {
                if let id = db.getAddressIdByAddressNames(city: cityName, district: districtName) {
                    DispatchQueue.main.async {
                        self.placeInfos = self.db.searchForPlaceInfos(by: Int(id), of: Int(PlaceForm.all.rawValue))
                    
                        self.refreshTable()
                    }
                }
            }
            
        }
    }
}
