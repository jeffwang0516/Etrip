//
//  DatePickerDialogViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/6/12.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class DatePickerDialogViewController: UIViewController {

    var parentView: AutoPlanViewController!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.minimumDate = Date()
        self.datePicker.maximumDate = Date()+6*24*60*60
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrePage(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmDateSelection(_ sender: UIButton) {
        self.parentView.updateDate(selectedDate: self.datePicker.date)
        
        self.dismiss(animated: true)
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
