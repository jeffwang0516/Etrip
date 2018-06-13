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

    var googleAPIKey = "AIzaSyCyD8-Y9BQMszppbpw_xu34X3okXgKS8CI"
    let backupKey = ["AIzaSyD8wDCzUntISMHr3CNFvMVVWCHUhJSHM78", "AIzaSyCq0tqZWsWzTiRxFC3ve0wU2ufQSreZwt8"]
    var currentBackupIndex = 0
    
    let viewTitle = "自動規劃"
    let db = DBManager.instance
    let testUserId = "TCA"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationManager: CLLocationManager!
    var currentLat: Double = 25.2218608856201
    var currentLng: Double = 121.645889282227
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
    
    var placeAlreadyPlanned: [PlaceInfo] = []
    
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
        self.districtDropDown.menuHeight = 160.0
        self.districtDropDown.delegate = self
        
        if let firstCity = firstCity, let firstDistrict = firstDistrict {
            if let addrid = db.getAddressIdByAddressNames(city: firstCity, district: firstDistrict) {
                self.activityIndicator.startAnimating()
                DispatchQueue.main.async {
                    self.placeSuggestions = self.db.searchForPlaceInfos(by: Int(addrid), of: Int(PlaceForm.landmark.rawValue))
                    self.favoritePlaces = self.db.getFavoritePlaces(of: self.testUserId, with: Int(PlaceForm.landmark.rawValue), in: Int(addrid))
                    self.refreshTable()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        
    }
    var timeRetrieved: Int = 0
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
        self.startAddress.text = "請定位..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    @IBAction func dayMinus(_ sender: Any) {

        let newInt = selectedDay - 1
        if newInt < 1 {
            selectedDay = 1
        }else{
            selectedDay = newInt
        }
    }
    @IBAction func dayPlus(_ sender: Any) {

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
        
        self.favoritePlacesTableView.reloadData()
        if self.favoritePlaces.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.favoritePlacesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
            autoPlanDialogView.parentView = self
            autoPlanDialogView.planningDetailsByDays = self.planningDetailsByDays
            autoPlanDialogView.userid = testUserId
            autoPlanDialogView.dayCount = selectedDay
            autoPlanDialogView.startDate = selectedDate
            autoPlanDialogView.endDate = selectedDate + TimeInterval((selectedDay-1)*24*60*60)
            
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // AutoPlanning func
    var planningDetailsByDays: [[DiaryDetail]] = []
    
    @IBAction func startPlanning(_ sender: UIButton) {
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.global().async {
            self.planningDetailsByDays = self.runAutoPlanning()
            
            // Manual perform segue
            DispatchQueue.main.async{
                self.view.isUserInteractionEnabled = true
                self.performSegue(withIdentifier: "OpenStartPlan", sender: sender)
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    private func runAutoPlanning() -> [[DiaryDetail]] {
        // TEST API
//        DispatchQueue.global().async {
//        self.timeRetrieved = self.retrieveTimeFromGoogleAPI("40.6655101,-73.89188969999998", "40.6905615,-73.9976592", isDriving: transportIsCar)
//        print("TESTAPI:" , self.timeRetrieved)
////        }
//
//        for a in db.searchForDiningPlaces(near: 3152, considerOf: 1200) {
//            print(a.name)
//        }
//        return []
        
        let transport: Int = transportIsCar ? 3 : 1
        
        self.chosenPlaces = combineChosenLists()
//        for place in chosenPlaces {
//            print(place.name)
//        }
        let diaryId = self.getAutoDiaryIdByCurTime()
        
        print(diaryId)
        
        var diaryDetail: [[DiaryDetail]] = []
        var prevDayHotel: PlaceInfo? = nil
        var isLastDay = false
        
        placeAlreadyPlanned = []
        
        for day in 0..<selectedDay {

            print("Processing day \(day+1)")
            if day == selectedDay - 1 { isLastDay = true }
            
            // Record plans of single day
            var diaryDetailForDay: [DiaryDetail] = []
            
            
            if prevDayHotel != nil {
                diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: prevDayHotel!.id, startTime: 0, endTime: 900, tag: 1, name: prevDayHotel!.name, form: prevDayHotel!.form))
            } else {
                diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: 0, startTime: 0, endTime: 900, tag: 1, name: "home", form: PlaceForm.home))
            }
            
            var planTime: Int = 900
            var startPlace: PlaceInfo? = nil
            var nextPlaceLand: PlaceInfo? = nil
            var staytime = 0
            
            if prevDayHotel != nil { startPlace = prevDayHotel }
            else {
                startPlace = PlaceInfo(id: 0, name: "home", address: currentAddress, form: PlaceForm.home, image: NSData(base64Encoded: "")!, ticket: 0, staytime: 0, hightime: 0, phone: "", abstract: "", lat: currentLat, lng: currentLng, score: Score(average: 0, total: 0))
                
            }
            
            // Prevent to plan multiple of the following in one day
            var isLunchPlanned = false
            var isDinnerPlanned = false
            var isHotelPlanned = false
            
            let city = self.cityDropdown.contentTextField.text
            let district = self.districtDropDown.contentTextField.text
            let destAddressId = Int(db.getAddressIdByAddressNames(city: city!, district: district!)!)
            let destNearbyAddrIds = db.getNearbyAddressIds(of: destAddressId)
            
            while planTime < 2400 {
                
                if 1100 < planTime && planTime < 1300 && isLunchPlanned == false {
                    print("Plantime Lunch: \(planTime)")
                    isLunchPlanned = true
                    
                    
                    // Search for lunch place
//                    nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForDiningPlaces(near: Int(startPlace!.id), considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                    nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(by: destAddressId, of: Int(PlaceForm.restaurant.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                    if nextPlaceLand == nil {
                        print("nil lunch")
                        for addrId in destNearbyAddrIds {
                            nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(by: addrId, of: Int(PlaceForm.restaurant.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                            if nextPlaceLand != nil {
                                print("found lunch in nearby")
                                break
                                
                            }
                        }
                        
                        if nextPlaceLand == nil {
                            print("found lunch in ALL")
                            nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(with: "", of: Int(PlaceForm.restaurant.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                        }
                    }
                    
                    
                    staytime = Int(nextPlaceLand!.staytime)
                    
   
                } else if 1630 < planTime && planTime < 1900 && isDinnerPlanned == false {
                    print("Plantime dinner: \(planTime)")
                    isDinnerPlanned = true
                    // Search for dinner place
//                    nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForDiningPlaces(near: Int(startPlace!.id), considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                    nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(by: destAddressId, of: Int(PlaceForm.restaurant.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                    if nextPlaceLand == nil {
                        print("nil dinner")
                        for addrId in destNearbyAddrIds {
                            nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(by: addrId, of: Int(PlaceForm.restaurant.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                            if nextPlaceLand != nil {
                                print("found dinner in nearby")
                                break
                                
                            }
                        }
                        
                        if nextPlaceLand == nil {
                            print("found dinner in ALL")
                            nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(with: "", of: Int(PlaceForm.restaurant.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                        }
                    }
                    
                    staytime = Int(nextPlaceLand!.staytime)
                    
                    
                } else if 1530 <= planTime && planTime <= 2200 && isHotelPlanned == false && isLastDay == false {
                    print("Plantime Hotel: \(planTime)")
                    isHotelPlanned = true
                    // Search for hotel
                    nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForHotels(in: destAddressId), planTime: planTime, isDriving: self.transportIsCar)
                    if nextPlaceLand == nil {
                        print("nil hotel")
                        for addrId in destNearbyAddrIds {
                            nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForHotels(in: addrId), planTime: planTime, isDriving: self.transportIsCar)
                            if nextPlaceLand != nil {
                                print("found hotel in nearby")
                                break
                                
                            }
                        }
                        
                        if nextPlaceLand == nil {
                            print("found hotel in ALL")
                            nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(with: "", of: Int(PlaceForm.hotel.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                        }
                    }
                    
                    staytime = 100
                    
                    prevDayHotel = nextPlaceLand
                    
                    // Add transport
                    diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: Int32(transport), startTime: Int32(planTime), endTime: Int32(addTime(planTime, timeRetrieved)), tag: 2, name: db.getTransportationName(of: Int32(transport)), form: db.getPlaceForm(of: Int32(transport))))
                    
                    // Add place
                    if let nextPlaceLand = nextPlaceLand {
                        diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: nextPlaceLand.id, startTime: Int32(addTime(planTime, timeRetrieved)), endTime: 2400, tag: 1, name: db.getPlaceName(of: Int32(nextPlaceLand.id)), form: db.getPlaceForm(of: Int32(nextPlaceLand.id))))
                        
                        planTime = addTime(addTime(planTime, timeRetrieved), staytime)
                    }
                    break
                } else if 1800 <= planTime && planTime <= 2400 && isLastDay == true {
                    print("Plantime EndOfTrip: \(planTime)")
                    // Plan for End Of Trip
                    let startLatLng = "\(startPlace!.lat),\(startPlace!.lng)"
                    let destLatLng = "\(self.currentLat),\(self.currentLng)"

                    let transTimeSec = self.retrieveTimeFromGoogleAPI(startLatLng, destLatLng, isDriving: self.transportIsCar)
                    
                    staytime = 100
                    let transTime = (transTimeSec/3600)*100 + (transTimeSec%3600/60)
                    
                    // Add transport
                    diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: Int32(transport), startTime: Int32(planTime), endTime: Int32(addTime(planTime, transTime)), tag: 2, name: db.getTransportationName(of: Int32(transport)), form: db.getPlaceForm(of: Int32(transport))))
                    
                    // Add HOME
                    
                    diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: 0, startTime: Int32(addTime(planTime, transTime)), endTime: 2400, tag: 1, name: "", form: PlaceForm.home))
                    
                    // END Planning HERE!
                    break
                    
                } else {
                    if (indoorIsChecked && outdoorIsChecked) || (!indoorIsChecked && !outdoorIsChecked) {
                        // Both checked or both not
                        print("Plantime LandMark: \(planTime)")
                        nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForLandmarks(with: LandmarkWay.all, in: destAddressId, considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                        
                        
                        if nextPlaceLand == nil {
                            print("nil Landmark inout")
                            for addrId in destNearbyAddrIds {
                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForLandmarks(with: LandmarkWay.all, in: addrId, considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                                if nextPlaceLand != nil {
                                    print("found Landmark inout in nearby")
                                    break
                                    
                                }
                            }
                            
                            if nextPlaceLand == nil {
                                print("found Landmark inout in ALL")
                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(by: destAddressId, of: Int(PlaceForm.landmark.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
//                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(with: "", of: Int(PlaceForm.landmark.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                            }
                        }
                        
                    } else if indoorIsChecked {
                        nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForLandmarks(with: LandmarkWay.indoor, in: destAddressId, considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                        if nextPlaceLand == nil {
                            print("nil Landmark in")
                            for addrId in destNearbyAddrIds {
                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForLandmarks(with: LandmarkWay.indoor, in: addrId, considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                                if nextPlaceLand != nil {
                                    print("found Landmark in in nearby")
                                    break
                                    
                                }
                            }
                            
                            if nextPlaceLand == nil {
                                print("found Landmark in in ALL")
                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(by: destAddressId, of: Int(PlaceForm.landmark.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                                //                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(with: "", of: Int(PlaceForm.landmark.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                            }
                        }
                        
                        
                    } else if outdoorIsChecked {
                        nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForLandmarks(with: LandmarkWay.outdoor, in: destAddressId, considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                        if nextPlaceLand == nil {
                            print("nil Landmark out")
                            for addrId in destNearbyAddrIds {
                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForLandmarks(with: LandmarkWay.outdoor, in: addrId, considerOf: planTime), planTime: planTime, isDriving: self.transportIsCar)
                                if nextPlaceLand != nil {
                                    print("found Landmark out in nearby")
                                    break
                                    
                                }
                            }
                            
                            if nextPlaceLand == nil {
                                print("found Landmark out in ALL")
                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(by: destAddressId, of: Int(PlaceForm.landmark.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                                //                                nextPlaceLand = self.findNextPlace(from: startPlace!, possiblePlaces: db.searchForPlaceInfos(with: "", of: Int(PlaceForm.landmark.rawValue)), planTime: planTime, isDriving: self.transportIsCar)
                            }
                        }
                    }
                    
                    staytime = Int(nextPlaceLand!.staytime)
//                    planTime = addTime(addTime(planTime, timeRetrieved), Int(nextPlaceLand!.staytime))
                }
                
                // Add transport
                diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: Int32(transport), startTime: Int32(planTime), endTime: Int32(addTime(planTime, timeRetrieved)), tag: 2, name: db.getTransportationName(of: Int32(transport)), form: db.getPlaceForm(of: Int32(transport))))
                
                // Add place
                if let nextPlaceLand = nextPlaceLand {
                    diaryDetailForDay.append(DiaryDetail(diaryId: diaryId, userid: testUserId, day: Int32(day + 1), content: nextPlaceLand.id, startTime: Int32(addTime(planTime, timeRetrieved)), endTime: Int32(addTime(addTime(planTime, timeRetrieved), staytime)), tag: 1, name: db.getPlaceName(of: Int32(nextPlaceLand.id)), form: db.getPlaceForm(of: Int32(nextPlaceLand.id))))
                    
                    planTime = addTime(addTime(planTime, timeRetrieved), staytime)
                }
                
                // Find following plans
                startPlace = nextPlaceLand
                
            }
            diaryDetail.append(diaryDetailForDay)
        }
   
        return diaryDetail
    }
    
    private func findNextPlace(from startPlace: PlaceInfo, possiblePlaces: [PlaceInfo], planTime: Int, isDriving: Bool) -> PlaceInfo? {
//        print(possiblePlaces)
        var waitForArrange: [PlaceInfo] = []
        
        for possible in possiblePlaces {
            for chosen in self.chosenPlaces {
                if possible.id == chosen.id {
                    if !self.checkIfPlaceChosen(chosenList: self.placeAlreadyPlanned, placeid: chosen.id) {
                        waitForArrange.append(chosen)
                    }
                }
            }
        }
        
        if waitForArrange.count == 0 { waitForArrange = possiblePlaces }
        
        var finalPlanPlace: PlaceInfo? = nil

        for place in waitForArrange {
            if !self.checkIfPlaceChosen(chosenList: self.placeAlreadyPlanned, placeid: place.id) {
                
                
                let startLatLng = "\(startPlace.lat),\(startPlace.lng)"
                let destLatLng = "\(place.lat),\(place.lng)"
                
                // TEST API
                
                let transTimeSec = self.retrieveTimeFromGoogleAPI(startLatLng, destLatLng, isDriving: isDriving)
                
                
                let transTime = (transTimeSec/3600)*100 + (transTimeSec%3600/60)
                
//                var planTimePredict = addTime(addTime(planTime, transTime), Int(place.staytime))
//                let checkIfItHasRelatedPlace = db.searchForDiningPlaces(near: Int(place.id))
//                if checkIfItHasRelatedPlace.count <= 0 {
//                    print("\(place.id) \(place.name) no! time: \(planTimePredict)")
//                    continue
//                }
                
                if place.form != PlaceForm.hotel {
                    if place.hightime/10000 < addTime(planTime, transTime) && addTime(planTime, transTime) < place.hightime%10000 {
                        self.timeRetrieved = transTime
                        print("TESTAPI:" , timeRetrieved)
                        finalPlanPlace = place
                        break
                        
                    }
                } else {
                    finalPlanPlace = place
                    break
                }
                
            }
            
        }
//        print(finalPlanPlace)
        if finalPlanPlace != nil {
            placeAlreadyPlanned.append(finalPlanPlace!)
//            print("Append \(finalPlanPlace!.id) \(finalPlanPlace!.name)")
        }
        
        return finalPlanPlace
    }
    
    private func addTime(_ a: Int, _ b: Int) -> Int{
        if (a+b)%100 < 60 {
            return a + b
        } else {
            return (a/100 + b/100)*100 + (a%100 + b%100)/60*100 + (a%100 + b%100)%60
        }
    }
    private func retrieveTimeFromGoogleAPI(_ startCoord: String, _ endCoord: String, isDriving: Bool) -> Int{
        var mode = "driving"
        if isDriving == false { mode = "transit" }
        
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(startCoord)&destinations=\(endCoord)&mode=\(mode)&key=\(googleAPIKey)"
        guard let url = URL(string: urlString) else { return 0}
 
            //Implement JSON decoding and parsing
            do {
    
                let data =  try Data(contentsOf: url)
                let json =  try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                
                // Check if exceeds LIMIT
                if json["status"] as! String == "OVER_QUERY_LIMIT" {
                    print("GOOGLE OVER_QUERY_LIMIT error")
                    if currentBackupIndex >= backupKey.count {
                        print("All google API key OVER LIMIT")
                    } else {
                        print("Using backup GoogleAPI key: \(currentBackupIndex)")
                    }
                    self.googleAPIKey = backupKey[currentBackupIndex]
                    currentBackupIndex = currentBackupIndex + 1
                    return retrieveTimeFromGoogleAPI(startCoord, endCoord, isDriving: isDriving)
                }
                
                let json1 = json["rows"] as! NSArray
                let json2 = json1[0] as! NSDictionary
                let json3 = json2["elements"] as! NSArray
                let dic = json3[0] as! NSDictionary
                if dic["status"] as! String == "ZERO_RESULTS" {
                    return 1800
                }
                let dis = dic["distance"] as! NSDictionary, dur  = dic["duration"] as! NSDictionary
                
              
                if let timeVal = dur["value"]
                {
               
                    //Get back to the main queue
                    return timeVal as! Int

                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
//
//
//            }.resume()
        return 0
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
        dateFormatter.dateFormat = "yyMMddhhmmss"
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
                if let addrid = db.getAddressIdByAddressNames(city: cityName, district: districtName) {
                    self.activityIndicator.startAnimating()
                    DispatchQueue.main.async {
                        self.placeSuggestions = self.db.searchForPlaceInfos(by: Int(addrid), of: Int(PlaceForm.landmark.rawValue))
                        self.favoritePlaces = self.db.getFavoritePlaces(of: self.testUserId, with: Int(PlaceForm.landmark.rawValue), in: Int(addrid))
                        self.refreshTable()
                        self.activityIndicator.stopAnimating()
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

