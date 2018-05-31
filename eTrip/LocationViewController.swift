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
    
    @IBOutlet weak var tableView: UITableView!
    var placeInfos: [PlaceInfo] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = viewTitle
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        
        placeCell.updateUIDisplays(name: placeInfo.name, address: placeInfo.address, rateScore: placeInfo.score, image: placeInfo.getUIImage())
        
        return placeCell
    }
    
}
