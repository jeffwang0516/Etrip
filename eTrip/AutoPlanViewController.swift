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
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var startAddress: UILabel!
    
    @IBOutlet weak var carImg: UIButton!
    @IBOutlet weak var busImg: UIButton!
    var transportIsCar:Bool!{
        didSet{
            if transportIsCar{
                carImg.setImage(UIImage(named: "transport_car_true"), for: UIControlState.normal)
                busImg.setImage(UIImage(named: "transport_bus_false"), for: UIControlState.normal)
            }else{
                carImg.setImage(UIImage(named: "transport_car_false"), for: UIControlState.normal)
                busImg.setImage(UIImage(named: "transport_bus_true"), for: UIControlState.normal)
            }
        }
    }  //true=car,false=bus
    
    @IBOutlet weak var indoorCheckImg: UIButton!
    var indoorIsChecked:Bool!{
        didSet{
            if indoorIsChecked{
                indoorCheckImg.setImage(UIImage(named: "checked-1"), for: UIControlState.normal)
            }else{
                indoorCheckImg.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
            }
        }
    }
    
    @IBOutlet weak var outdoorCheckImg: UIButton!
    var outdoorIsChecked:Bool!{
        didSet{
            if outdoorIsChecked{
                outdoorCheckImg.setImage(UIImage(named: "checked-1"), for: UIControlState.normal)
            }else{
                outdoorCheckImg.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = viewTitle
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        transportIsCar = true
        indoorIsChecked = true
        outdoorIsChecked = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dayMinus(_ sender: Any) {
        let i = day.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let newString = NSArray(array: i!).componentsJoined(by: "")
        let newInt = Int(newString)!-1
        if newInt < 1 {
            day.text = "1日"
        }else{
            day.text = "\(newInt)日"
        }
    }
    @IBAction func dayPlus(_ sender: Any) {
        let i = day.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let newString = NSArray(array: i!).componentsJoined(by: "")
        let newInt = Int(newString)!+1
        if newInt > 5 {
            day.text = "5日"
        }else{
            day.text = "\(newInt)日"
        }
    }
    
    @IBAction func changeTransport(_ sender: UIButton) {
        if sender == self.carImg{
            transportIsCar = true
        }
        if sender == self.busImg{
            transportIsCar = false
        }
    }
    
    
    @IBAction func changeIndoor(_ sender: Any) {
        indoorIsChecked = !indoorIsChecked
    }
    
    @IBAction func changeOutdoor(_ sender: Any) {
        outdoorIsChecked = !outdoorIsChecked
    }
    
    @IBAction func detectAddress(_ sender: Any) {
        
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
