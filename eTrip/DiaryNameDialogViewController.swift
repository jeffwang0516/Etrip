//
//  DiaryNameDialogViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/6/12.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class DiaryNameDialogViewController: UIViewController {

    var parentView: AutoPlanDialogViewController?
    
    @IBOutlet weak var textBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func confirmAction(_ sender: UIButton) {
        if let parentView = parentView {
            if let text = textBox.text {
                self.dismiss(animated: true)
                parentView.confirmSave(title: text)
            }
        }
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
