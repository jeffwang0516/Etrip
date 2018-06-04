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
    
    var dayCount: Int = 1
    var diaryDetails: [DiaryDetail] = []
    
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
        
        diaryDetailCell.dayLabel.text = "DAY \(1)"
//        let item1 = diaryDetails[0]
//        diaryDetailCell
  
        // TODO
        
        return diaryDetailCell
    }
}
