//
//  AutoPlanDialogViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/6/12.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class AutoPlanDialogViewController: UIViewController {
    
    let db = DBManager.instance
    
    var dayCount: Int = 1
    var userid: String!
    var planningDetails: [DiaryDetail]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        self.tableView.rowHeight = 210.0
        print("TEST:DIALOG\(dayCount)")
    }
    
    @IBAction func backToPrePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenSaveConfirm" {
            let diaryNameDialog = segue.destination as! DiaryNameDialogViewController
            diaryNameDialog.parentView = self
        } else if segue.identifier == "OpenDayDetailFromAutoPlan" {
            let diaryDayDetailController = segue.destination as! DiaryDayDetailViewController
            
            // Load it with single day planningDetails, not ALL
//            diaryDayDetailController.diaryDetails = planningDetails!
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func confirmSave(title: String?) {
        // Save to DB
        //TODO
        if let title = title, title.count > 0 {
            print("Implement Saved: \(title)")
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyyMMdd"

            let dateString = dateFormatter.string(from: Date())
            print("Implement Saved: \(dateString)")
        }
        
        self.dismiss(animated: true)
    }
//    private func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: DiaryDetailViewCell) {
//        
//        let diaryDayDetailViewController = segue.destination as! DiaryDayDetailViewController
//        let senderPath = self.tableView.indexPath(for: sender)!
//        let day = senderPath.row + 1
//        
//        diaryDayDetailViewController.diaryDetails = db.getDiaryDetail(with: diaryid, of: userid, of: day)// sender.diaryDetailOfDay
//        //        print(sender.diaryDetailOfDay)
//        
//    }
}


extension AutoPlanDialogViewController: UITableViewDelegate, UITableViewDataSource{
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diaryDetailCell = tableView.dequeueReusableCell(withIdentifier: "DiaryDetailCell", for: indexPath) as! DiaryDetailViewCell
        
//        diaryDetailCell.updateUIDisplays(diaryId: diaryid, userid: userid, day: indexPath.row + 1)
        
        return diaryDetailCell
    }
    
}
