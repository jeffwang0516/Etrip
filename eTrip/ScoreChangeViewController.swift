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
    let testUserId = "TCA"
    let db = DBManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        scoreStar.rating =
//        scoreStar.text = 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveNewScore(_ sender: Any) {
        //input placeid+userid+score
        
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
