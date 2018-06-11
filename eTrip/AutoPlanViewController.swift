//
//  AutoPlaneViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class AutoPlanViewController: UIViewController {

    let viewTitle = "自動規劃"
    @IBOutlet var Button: UIButton!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    
    @IBAction func showclicked(_ sender: UIButton) {
            let date = datePicker.date
            
            // 创建一个日期格式器
            let dformatter = DateFormatter()
            // 为日期格式器设置格式字符串
            dformatter.dateFormat = "yyyy年MM月dd日"
            // 使用日期格式器格式化日期、时间
            let datestr = dformatter.string(from: date)
            
            let message =  "\(datestr)"
            
            // 创建一个UIAlertController对象（消息框），并通过该消息框显示用户选择的日期、时间
            let alertController = UIAlertController(title: ""/*當前日期*/,
                                                    message: message,
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: ""/*"确定"*/, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
//http://www.hangge.com/blog/cache/detail_547.html
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = viewTitle
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.brown, forKey: "textColor")//改成棕色了
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
