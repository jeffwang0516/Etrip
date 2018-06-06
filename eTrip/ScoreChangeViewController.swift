//
//  ScoreChangeViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/6/6.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class ScoreChangeViewController: UIViewController {
    @IBOutlet weak var scoreStar: CosmosView!
    var placeid: Int32!
    let testUserId = "TCA"
    let db = DBManager.instance
    var prevViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userScore = db.getRatings(of: Int(placeid), by: testUserId) {
            scoreStar.rating = Double(userScore)
            scoreStar.text = String(userScore)
//            print(userScore)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshPreviousView() {
        if let prevCtrl = prevViewController as? PlaceInfoDetailViewController {
            prevCtrl.refresh()
        }
    }
    @IBAction func backToPrePage(_ sender: Any) {
        self.dismiss(animated: true)
        refreshPreviousView()
    }
    
    @IBAction func saveNewScore(_ sender: Any) {
        //input placeid+userid+score
        
//        print(scoreStar.rating)
        if placeid != nil {
           db.setRating(of: Int(placeid), by: testUserId, score: Int(scoreStar.rating))
        }
        
        self.dismiss(animated: true)
        refreshPreviousView()
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
