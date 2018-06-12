//
//  AutoPlaneViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AutoPlanViewController: UIViewController {

    let viewTitle = "自動規劃"
    let db = DBManager.instance
    let testUserId = "TCA"
    
    var locationManager: CLLocationManager!
    var currentLat: Double = 0.0
    var currentLng: Double = 0.0
    var currentAddress: String = ""
    
    @IBOutlet weak var cityDropdown: ZHDropDownMenu!
    @IBOutlet weak var districtDropDown: ZHDropDownMenu!
    
    var placeSuggestions: [PlaceInfo] = []
    @IBOutlet weak var suggestionsTableView: UITableView!
    
    var favoritePlaces: [PlaceInfo] = []
    @IBOutlet weak var favoritePlacesTableView: UITableView!
    
    var chosenPlaces: [PlaceInfo] = []
    var chosenLandmarks: [PlaceInfo] = []
    var chosenFavorites: [PlaceInfo] = []
    
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
        
        self.setupDetermineLocation()
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
        print("Detecting")
        self.startAddress.text = "定位中..."
        startDetectingLocation()
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
            autoPlanDialogView.planningDetailsByDays = self.startAutoPlanning()
            autoPlanDialogView.userid = testUserId
            autoPlanDialogView.dayCount = selectedDay
            autoPlanDialogView.startDate = selectedDate
            autoPlanDialogView.endDate = selectedDate + TimeInterval((selectedDay-1)*24*60*60)
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // AutoPlanning func
    
    private func startAutoPlanning() -> [[DiaryDetail]] {
        
        self.chosenPlaces = combineChosenLists()
//        for place in chosenPlaces {
//            print(place.name)
//        }
        let diaryId = self.getAutoDiaryIdByCurTime()
        var diaryDetail: [[DiaryDetail]] = []
        var prevDayHotel: PlaceInfo? = nil
        var isLastDay = false
        
        for day in 0..<selectedDay {

            if day == selectedDay - 1 { isLastDay = true }
            
            // Record plans of single day
            var diaryDetailForDay: [DiaryDetail] = []
            
            
            if prevDayHotel != nil {
                diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: prevDayHotel!.id, startTime: 0, endTime: 900, tag: 1, name: prevDayHotel!.name, form: prevDayHotel!.form))
            } else {
                diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: 0, startTime: 0, endTime: 900, tag: 1, name: "home", form: PlaceForm.home))
            }
            
            var planTime: Int = 900
            var placeLand: PlaceInfo? = nil
            var nextPlaceLand: PlaceInfo? = nil
            
            if prevDayHotel != nil { placeLand = prevDayHotel }
            else {
                placeLand = PlaceInfo(id: 0, name: "home", address: currentAddress, form: PlaceForm.home, image: NSData(base64Encoded: "")!, ticket: 0, staytime: 0, hightime: 0, phone: "", abstract: "", lat: currentLat, lng: currentLng, score: Score(average: 0, total: 0))
                
            }
            
            // Prevent to plan multiple of the following in one day
            var isLunchPlanned = false
            var isDinnerPlanned = false
            var isHotelPlanned = false
            
            while planTime < 2000 {
                
                if 1100 < planTime && planTime < 1300 && isLunchPlanned == false {
                    isLunchPlanned = true
                    // Search for lunch place
                    
                    
                } else if 1700 < planTime && planTime < 1900 && isDinnerPlanned == false {
                    isDinnerPlanned = true
                    // Search for dinner place
                } else if 1600 <= planTime && planTime <= 1900 && isHotelPlanned == false && isLastDay == false {
                    isHotelPlanned = true
                    // Search for hotel
                } else if 1800 <= planTime && planTime <= 2400 && isLastDay == true {
                    // Plan for End Of Trip
                    
                    
                } else {
                    if (indoorIsChecked && outdoorIsChecked) || (!indoorIsChecked && !outdoorIsChecked) {
                        // Both checked or both not
                        
                    } else if indoorIsChecked {
                        
                    } else if outdoorIsChecked {
                        
                    }
                }
                
            }
        }
   
        return diaryDetail
    }
    
    private func combineChosenLists() -> [PlaceInfo]{
        
        var chosen = self.chosenLandmarks
        for place in chosenFavorites {
            if checkIfPlaceChosen(chosenList: chosen, placeid: place.id) == false {
                chosen.append(place)
            }
        }
        
        return chosen
    }
    
    private func checkIfPlaceChosen(chosenList: [PlaceInfo], placeid: Int32) -> Bool {
        for place in chosenList {
            if place.id == placeid {
                return true
            }
        }
        return false
    }
    
    private func getAutoDiaryIdByCurTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyyMMdd"
        //        print(selectedDate)
        return dateFormatter.string(from: Date())
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
            suggestCell.isChecked = checkIfLandmarkChosen(placeid: placeInfo.id)
            
            return suggestCell
        } else {
            let favorCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteSelectCell", for: indexPath) as! AutoPlanCheckBoxCell
            let placeInfo = favoritePlaces[indexPath.row]
            favorCell.title = placeInfo.name
            favorCell.isChecked = checkIfFavoriteChosen(placeid: placeInfo.id)
            
            return favorCell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("SELECT")
        if tableView == suggestionsTableView {

            let placeInfo = placeSuggestions[indexPath.row]
            
            if !checkIfLandmarkChosen(placeid: placeInfo.id) {
                chosenLandmarks.append(placeInfo)
            } else {
                var indexToRemove = -1
                for (index, place) in chosenLandmarks.enumerated() {
                    if place.id == placeInfo.id {
                        indexToRemove = index
                        break
                    }
                }
    
                if indexToRemove >= 0 {
                    chosenLandmarks.remove(at: indexToRemove)
                }
            }
            
            tableView.reloadData()

        } else {
            
            let placeInfo = favoritePlaces[indexPath.row]
            
            if !checkIfFavoriteChosen(placeid: placeInfo.id) {
                chosenFavorites.append(placeInfo)
            } else {
                var indexToRemove = -1
                for (index, place) in chosenFavorites.enumerated() {
                    if place.id == placeInfo.id {
                        indexToRemove = index
                        break
                    }
                }
                
                if indexToRemove >= 0 {
                    chosenFavorites.remove(at: indexToRemove)
                }
            }
            
            tableView.reloadData()
        }
    }
    
    private func checkIfLandmarkChosen(placeid: Int32) -> Bool {
        for place in chosenLandmarks {
            if place.id == placeid {
                return true
            }
        }
        return false
    }
    
    private func checkIfFavoriteChosen(placeid: Int32) -> Bool {
        for place in chosenFavorites {
            if place.id == placeid {
                return true
            }
        }
        return false
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

extension AutoPlanViewController: CLLocationManagerDelegate {
    
    func setupDetermineLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startDetectingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        self.currentLat = userLocation.coordinate.latitude
        self.currentLng = userLocation.coordinate.longitude
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
//        print(locationManager.location)
        lookUpCurrentLocation { location in
//            print(location?.country, location?.locality, location?.name)
            if let addr = location?.name {
                self.startAddress.text = addr
                self.currentAddress = addr
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        completionHandler(firstLocation)
                    }
                    else {
                        // An error occurred during geocoding.
                        completionHandler(nil)
                    }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
}

