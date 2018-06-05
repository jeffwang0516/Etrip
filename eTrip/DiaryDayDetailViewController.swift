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
    
    @IBOutlet weak var dayLabel: UILabel!
    var diaryDetails: [DiaryDetail] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 60.0
        
        if let day = diaryDetails.first?.day {
            dayLabel.text = "DAY \(String(Int(day)))"
        }
        
    }
    
    @IBAction func customBackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
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

        dayDetailCell.updateUIDisplays(detail: dayDetailItem)

        return dayDetailCell
    }

}
