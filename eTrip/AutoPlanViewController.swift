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
    let db = DBManager.instance
    let testUserId = "TCA"
    
    @IBOutlet weak var cityDropdown: ZHDropDownMenu!
    @IBOutlet weak var districtDropDown: ZHDropDownMenu!
    
    var placeSuggestions: [PlaceInfo] = []
    @IBOutlet weak var suggestionsTableView: UITableView!
    
    var favoritePlaces: [PlaceInfo] = []
    @IBOutlet weak var favoritePlacesTableView: UITableView!
    
    @IBOutlet weak var date: UIButton!
    var selectedDate: Date!{
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            //        print(selectedDate)
            let dateString = dateFormatter.string(from: selectedDate)
            let splitedDate = dateString.split(separator: "-")
            
            self.date.setTitle("\(splitedDate[0])年\(splitedDate[1])月\(splitedDate[2])日", for: UIControlState.normal)
        }
    }
    
    @IBOutlet weak var day: UILabel!
    var selectedDay: Int!{
        didSet {
            self.day.text = "\(selectedDay!)日"
        }
    }
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
        self.updateDate(selectedDate: Date())
        self.selectedDay = 3
        
        // Dropdowns init
        self.cityDropdown.options = db.getAllCityNames()
        let firstCity = self.cityDropdown.options.first
        self.cityDropdown.defaultValue = firstCity
        self.cityDropdown.menuId = 1
        self.cityDropdown.delegate = self
        
        if firstCity != nil{
            self.districtDropDown.options = db.getCityDistrict(city: firstCity!)
        }
        let firstDistrict = self.districtDropDown.options.first
        
        if firstDistrict != nil {
            self.districtDropDown.defaultValue = firstDistrict
        }
        
        self.districtDropDown.menuId = 2
        self.districtDropDown.delegate = self
        
        if let firstCity = firstCity, let firstDistrict = firstDistrict {
            if let id = db.getAddressIdByAddressNames(city: firstCity, district: firstDistrict) {
                DispatchQueue.main.async {
                    self.placeSuggestions = self.db.searchForPlaceInfos(by: Int(id), of: Int(PlaceForm.landmark.rawValue))
                    
                    self.refreshTable()
                }
            }
        }
        
        self.favoritePlaces = db.getFavoritePlaces(of: testUserId, with: Int(PlaceForm.landmark.rawValue))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transportIsCar = true
        indoorIsChecked = true
        outdoorIsChecked = true
        // Do any additional setup after loading the view.
        self.suggestionsTableView.delegate = self
        self.suggestionsTableView.dataSource = self
        
        self.favoritePlacesTableView.delegate = self
        self.favoritePlacesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    @IBAction func dayMinus(_ sender: Any) {
//        let i = day.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
//        let newString = NSArray(array: i!).componentsJoined(by: "")
//        let newInt = Int(newString)!-1
//        if newInt < 1 {
//            day.text = "1日"
//        }else{
//            day.text = "\(newInt)日"
//        }
        let newInt = selectedDay - 1
        if newInt < 1 {
            selectedDay = 1
        }else{
            selectedDay = newInt
        }
    }
    @IBAction func dayPlus(_ sender: Any) {
//        let i = day.text?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
//        let newString = NSArray(array: i!).componentsJoined(by: "")
//        let newInt = Int(newString)!+1
//        if newInt > 5 {
//            day.text = "5日"
//        }else{
//            day.text = "\(newInt)日"
//        }
        let newInt = selectedDay + 1
        if newInt > 5 {
            selectedDay = 5
        }else{
            selectedDay = newInt
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
    
    func refreshTable() {
        self.suggestionsTableView.reloadData()
        if self.placeSuggestions.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.suggestionsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenDatePicker" {
            
            let datePickerView = segue.destination as! DatePickerDialogViewController
            datePickerView.parentView = self
            
        } else if segue.identifier == "OpenStartPlan" {
            let autoPlanDialogView = segue.destination as! AutoPlanDialogViewController
            autoPlanDialogView.planningDetails = self.startAutoPlanning()
            autoPlanDialogView.userid = testUserId
            autoPlanDialogView.dayCount = selectedDay
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func startAutoPlanning() -> [DiaryDetail] {
        var detail: [DiaryDetail] = []
        
        return detail
    }
}

extension AutoPlanViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == suggestionsTableView {
            return placeSuggestions.count > 10 ? 10 : placeSuggestions.count
        } else if tableView == favoritePlacesTableView {
            return favoritePlaces.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == suggestionsTableView {
            let suggestCell = tableView.dequeueReusableCell(withIdentifier: "SuggestionSelectCell", for: indexPath) as! AutoPlanCheckBoxCell
            let placeInfo = placeSuggestions[indexPath.row]
            suggestCell.title = placeInfo.name
            suggestCell.isChecked = false
            
            return suggestCell
        } else {
            let favorCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteSelectCell", for: indexPath) as! AutoPlanCheckBoxCell
            let placeInfo = favoritePlaces[indexPath.row]
            favorCell.title = placeInfo.name
            favorCell.isChecked = false
            //        suggestCell.setChecked()
            
            return favorCell
        }
        
        
        
    }
    
}

extension AutoPlanViewController: ZHDropDownMenuDelegate {
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        
        
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        // City Selected
        if menu.menuId == 1 {
            let cityName = self.cityDropdown.options[index]
            
            self.districtDropDown.options = db.getCityDistrict(city: cityName)
            self.districtDropDown.defaultValue = "請選擇"
            
        } else {
            // District selected
            let districtName = self.districtDropDown.options[index]
            if let cityName = self.cityDropdown.contentTextField.text {
                if let id = db.getAddressIdByAddressNames(city: cityName, district: districtName) {
                    DispatchQueue.main.async {
                        self.placeSuggestions = self.db.searchForPlaceInfos(by: Int(id), of: Int(PlaceForm.landmark.rawValue))
                        
                        self.refreshTable()
                    }
                }
            }
            
        }
    }
}

