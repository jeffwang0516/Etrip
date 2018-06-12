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
    var parentView: AutoPlanViewController?
    var startDate: Date?
    var endDate: Date?
    var dayCount: Int = 1
    var userid: String!
    var planningDetailsByDays: [[DiaryDetail]]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        self.tableView.rowHeight = 210.0
        print("TEST:DIALOG\(dayCount)")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func backToPrePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenSaveConfirm" {
            let diaryNameDialog = segue.destination as! DiaryNameDialogViewController
            diaryNameDialog.parentView = self
        } else if segue.identifier == "OpenDayDetailFromAutoPlan" {
        
            guard let cell = sender as? DiaryDetailViewCell else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpeningDetail(for: segue, sender: cell)
            
            // Load it with single day planningDetails, not ALL
//            diaryDayDetailController.diaryDetails = planningDetails!
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: DiaryDetailViewCell) {
        
        let diaryDayDetailViewController = segue.destination as! DiaryDayDetailViewController
        let senderPath = self.tableView.indexPath(for: sender)!
        let day = senderPath.row
        if let dayDetail = planningDetailsByDays?[day] {
            diaryDayDetailViewController.diaryDetails = dayDetail
        }
        
    }
    
    func confirmSave(title: String?) {
        // Save to DB
        //TODO
        if let title = title, title.count > 0 {
            print("Implement Saved: \(title)")
            saveToDB(title: title)
        } else {

            let dateString = dateFormatterFunc(Date())
            print("Implement Saved: \(dateString)")
            saveToDB(title: dateString)
        }
        
        self.dismiss(animated: true)
    }
    
    private func saveToDB(title: String) {
        var allPlans: [DiaryDetail] = []
        if let allDayPlans = planningDetailsByDays {
            for dayPlan in allDayPlans {
                for plan in dayPlan {
                    allPlans.append(plan)
                }
            }
        }
        
        DispatchQueue.global().async {
            if let startDate = Int32(self.dateFormatterFunc(self.startDate!)), let endDate = Int32(self.dateFormatterFunc(self.endDate!)) {
                
                self.db.addDiary(diaryName: title, details: allPlans, preDate: startDate, postDate: endDate)

                // Refresh view in diary view
                DispatchQueue.main.async {
                    if let parentView = self.parentView {
                        let allControllers = parentView.navigationController?.viewControllers[0].childViewControllers
//                        print(allControllers)
                        if let diaryView = allControllers?[4] as? DiaryViewController {
                            diaryView.refreshDataAndTable()
                        }
                    }
                    
                }
                
            }
        }
    }
    
    private func dateFormatterFunc(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: date)
    }
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
        
        if let dayDetail = planningDetailsByDays?[indexPath.row] {
            diaryDetailCell.updateUIDisplaysForAutoPlan(planDetails: dayDetail, day: indexPath.row + 1)
        }
        
        return diaryDetailCell
    }
    
}
