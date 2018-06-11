//
//  DiaryDayDetailViewController.swift
//  eTrip
//
//  Created by JeffWang on 2018/6/5.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import UIKit

class DiaryDayDetailViewController: UIViewController {
    
    let db = DBManager.instance
    @IBOutlet weak var dayLabel: UILabel!
    var diaryDetails: [DiaryDetail] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 80.0
        
        if let day = diaryDetails.first?.day {
            dayLabel.text = "DAY \(String(Int(day)))"
        }
        
    }
    
    @IBAction func customBackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenPlaceDetailModally" {
            guard let cell = sender as? DiaryDayDetailViewCell else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpeningDetail(for: segue, sender: cell)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: DiaryDayDetailViewCell) {
        
        
        let placeInfoDetailViewController = segue.destination as! PlaceInfoDetailViewController
        let senderPath = self.tableView.indexPath(for: sender)!
        
        let diaryDetail = diaryDetails[senderPath.row]
        placeInfoDetailViewController.placeInfo = db.getPlaceInfo(for: diaryDetail.content).first
        
    }
}

extension DiaryDayDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayDetailCell = tableView.dequeueReusableCell(withIdentifier: "DayDetailCell", for: indexPath) as! DiaryDayDetailViewCell
        let dayDetailItem = diaryDetails[indexPath.row]
        if dayDetailItem.tag == 2 {
            dayDetailCell.isUserInteractionEnabled = false;
        }

        dayDetailCell.updateUIDisplays(detail: dayDetailItem)

        return dayDetailCell
    }

}
