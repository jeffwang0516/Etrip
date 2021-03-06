//
//  DiaryDetailViewController.swift
//  eTrip
//
//  Created by JeffWang on 2018/6/4.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import UIKit

class DiaryDetailViewController: UITableViewController {
    
    let db = DBManager.instance
    
    var dayCount: Int = 1
    var diaryid: String!
    var userid: String!
    
    override func viewDidLoad() {
        self.tableView.rowHeight = 210.0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayCount
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diaryDetailCell = tableView.dequeueReusableCell(withIdentifier: "DiaryDetailCell", for: indexPath) as! DiaryDetailViewCell
        
        diaryDetailCell.updateUIDisplays(diaryId: diaryid, userid: userid, day: indexPath.row + 1)
        
        return diaryDetailCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenDayDetail" {
            guard let cell = sender as? DiaryDetailViewCell else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpeningDetail(for: segue, sender: cell)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: DiaryDetailViewCell) {
        
        let diaryDayDetailViewController = segue.destination as! DiaryDayDetailViewController
        let senderPath = self.tableView.indexPath(for: sender)!
        let day = senderPath.row + 1
        
        diaryDayDetailViewController.diaryDetails = db.getDiaryDetail(with: diaryid, of: userid, of: day)// sender.diaryDetailOfDay
//        print(sender.diaryDetailOfDay)
        
    }
}
