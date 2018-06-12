//
//  DiaryViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {
    
    let viewTitle = "行程日記"
    let testUserId = "TCA"
    let db = DBManager.instance
    
    @IBOutlet weak var tableView: UITableView!
    
    var diaryInfos: [DiaryInfo] = []
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = viewTitle
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        diaryInfos = db.getDiary(of: testUserId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 268.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshDataAndTable() {
        diaryInfos = db.getDiary(of: testUserId)
        self.tableView.reloadData()
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
        if segue.identifier == "OpenDiaryDetail" {
            guard let cell = sender as? UITableViewCell else {
                fatalError("Mis-configured storyboard! The sender should be a cell.")
            }
            self.prepareOpeningDetail(for: segue, sender: cell)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func prepareOpeningDetail(for segue: UIStoryboardSegue, sender: UITableViewCell) {
        
        let diaryDetailViewController = segue.destination as! DiaryDetailViewController
        let senderPath = self.tableView.indexPath(for: sender)!
        let diary = diaryInfos[senderPath.row]
//        let diaryDetails = db.getDiaryDetail(with: diary.diaryId, of: testUserId)
        diaryDetailViewController.dayCount = db.getDiaryTotalDays(with: diary.diaryId, of: testUserId)
        diaryDetailViewController.diaryid = diary.diaryId
        diaryDetailViewController.userid = testUserId
    }

}
extension DiaryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diaryCell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryTableViewCell
        let diaryInfo = diaryInfos[indexPath.row]
        
        diaryCell.updateUIDisplays(name: diaryInfo.name, preDate: String(diaryInfo.preDate), postDate: String(diaryInfo.postDate), diaryID: diaryInfo.diaryId)
        
        return diaryCell
    }
    
    
}
