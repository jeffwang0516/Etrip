//
//  DBManager.swift
//  eTrip
//
//  Created by JeffWang on 2018/5/27.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import SQLite3

class DBManager{
    private let sqlFilePath = Bundle.main.path(forResource: "etrip", ofType: "db")!
    static let instance = DBManager()
    private var db: OpaquePointer?
    
    private init() {
        if sqlite3_open(sqlFilePath, &db) == SQLITE_OK {
            print("DB successfully connected \(sqlFilePath)")
        } else {
            print("Error opening database")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    func test() {
        print("TEST")
        print(getAllCityNames())
        print(getCityDistrict(city: "臺北市"))
        print(getAddressById(100))
        print(searchForPlaceInfos(with: "舊金山", of: 4))
        print(getScore(of: 334)) 
        
    }
    
    
    // Places query
    func searchForPlaceInfos(with searchText: String, of form: Int) -> [PlaceInfo]{
        var queryString = "SELECT * FROM place WHERE name LIKE '%\(searchText)%'"
        queryString = addFormRule(to: queryString, with: form)
        
        return queryOfPlaceInfos(with: queryString)
    }
    
    func searchForPlaceInfos(by addressid: Int, of form: Int) -> [PlaceInfo]{
        var queryString = "SELECT * FROM place WHERE addressid = \(addressid)"
        queryString = addFormRule(to: queryString, with: form)

        return queryOfPlaceInfos(with: queryString)
    }
    
    func searchForPlaceInfos(by addressid: Int, with wayid: LandmarkWay) -> [PlaceInfo]{

        if wayid == LandmarkWay.all {
            let queryString = "SELECT * FROM place WHERE addressid = \(addressid);"
            return queryOfPlaceInfos(with: queryString)
        }
        
        let queryString = "SELECT distinct place.* from place,landmarkway where (formid = 1 and place.placeid=landmarkway.placeid and addressid =\(addressid) and wayid =\(wayid.rawValue) ) or (formid = 2 and addressid =\(addressid)) or (formid = 3 and addressid =\(addressid));"
        
        return queryOfPlaceInfos(with: queryString)
    }
    
    
    // PlaceInfo Related
    func getAbstract(of placeId: Int) -> String{
        let queryString = "SELECT abstract FROM landmarkticket WHERE placeid = \(placeId);"
        var queryStatement: OpaquePointer? = nil
        var abstract: String = ""
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let text = sqlite3_column_text(queryStatement, 0)
                abstract = String(cString: text!)
            }
            
        } else {
            print("getAbstract(\(placeId)) query not exist")
        }
        return abstract
    }
    
    func getAllCityNames() -> [String]{
        let queryString = "SELECT DISTINCT city FROM address;"
        var queryStatement: OpaquePointer? = nil
        var names: [String] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 0)
                let name = String(cString: queryResultCol1!)
                
                names.append(name)
            }
        } else {
            print("getAllCityNames() query not prepared")
        }
        return names
    }
    
    func getCityDistrict(city: String) -> [String]{
        let queryString = "SELECT district FROM address WHERE city='\(city)';"
        var queryStatement: OpaquePointer? = nil
        var names: [String] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 0)
                let name = String(cString: queryResultCol1!)
                
                names.append(name)
            }
            
        } else {
            print("getCityDistrict() query not prepared")
        }
        return names
    }
    
    func getAddressById(_ id: Int32) -> String?{
        let queryString = "SELECT * FROM address WHERE addressid= \(id);"
        var queryStatement: OpaquePointer? = nil
        var address: String?
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                address = String(cString: queryResultCol1!) + String(cString: queryResultCol2!)
            }
            
        } else {
            print("getAddressById() query not prepared")
        }
        return address
    }
    
    
    // Tickets
    func getNormalTicketId(of placeId: Int32) -> Int32{
        let queryString = "SELECT ticket FROM landmarkticket WHERE placeid = \(placeId) AND identityid = 1;"
        var queryStatement: OpaquePointer? = nil
        var ticketId: Int32 = -1
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
             
                ticketId = sqlite3_column_int(queryStatement, 0)
            }   
        } else {
            print("getNormalTicketId(\(placeId)) query not exist")
        }
        return ticketId
    }
    
    func getTickcetInfos(of placeId: Int) -> [TicketInfo]{
        let queryString = "SELECT * FROM landmarkticket WHERE placeid = \(placeId);"
        var queryStatement: OpaquePointer? = nil
        var ticketInfos: [TicketInfo] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let identity = sqlite3_column_text(queryStatement, 1)
                let price = sqlite3_column_int(queryStatement, 2)
                
                let ticket = TicketInfo(identity: String(cString: identity!), cost: Int(price))
                
                ticketInfos.append(ticket)
            }
            
        } else {
            print("getTickcetInfos(\(placeId)) query not exist")
        }
        return ticketInfos
    }
    
    
    // Favorites
    func ifPlaceIsFavorite(of userid: String, placeid: Int) -> Bool {
       
        return false
    }
    
    func alterFavorites(of userid: String, placeid: Int) -> Bool {
        // Either Add or Del from one's favorite list, return successful or not
        
        return false
    }
    
    func getFavoritePlaces(of userid: Int) -> [PlaceInfo] {
        // TODO
        let queryString = ""
        return queryOfPlaceInfos(with: queryString)
    }
    
    // Ratings
    func getRatings(of placeid: Int, by userid: String) -> Int {
        
        return 0
    }
    
    
    // AutoPlanning Related:
    // Nearby queries & Time constrained queries
    func searchForDiningPlaces(near placeid: Int, considerOf timeFactor: Int) -> [PlaceInfo] {
        // TODO
        let queryString = ""
        return queryOfPlaceInfos(with: queryString)
    }
    
    func searchForLandmarks(with wayid: LandmarkWay, near addressid: Int, considerOf timeFactor: Int) -> [PlaceInfo]  {
        // TODO
        let queryString = ""
        return queryOfPlaceInfos(with: queryString)
    }
    
    func searchForHotels(near addressid: Int) -> [PlaceInfo]  {
        // TODO
        let queryString = ""
        return queryOfPlaceInfos(with: queryString)
    }
    
    func getAvailableTransportation(near addressid: Int) -> [PlaceInfo]  {
        // TODO
        let queryString = ""
        return queryOfPlaceInfos(with: queryString)
    }
    
    
    // Diary
    
    /*** Private Helper Functions Below NOT FOR CALL ***/
    private func getScore(of placeId: Int32) -> Score{
        let queryString = "SELECT * FROM score WHERE placeid = \(placeId);"
        var queryStatement: OpaquePointer? = nil
        var count = 0.0
        var total = 0.0
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let score = sqlite3_column_int(queryStatement, 2)
                total = total + Double(score)
                count = count +  1
            }
        } else {
            print("getScore(\(placeId)) query not exist")
        }
        let avg = total/count
        return Score(average: avg, total: Int(total))
    }
    
    private func queryOfPlaceInfos(with queryString: String) -> [PlaceInfo] {
        var queryStatement: OpaquePointer? = nil
        var placeInfos: [PlaceInfo] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var placeInfo: PlaceInfo
                let placeForm = sqlite3_column_int(queryStatement, 6)
                
                let id = sqlite3_column_int(queryStatement, 0)
                var nameString = ""
                if let name = sqlite3_column_text(queryStatement, 1) {
                    nameString = String(cString: name)
                }
                let addressid = sqlite3_column_int(queryStatement, 2)
                var road = ""
                if let roadno = sqlite3_column_text(queryStatement, 3) {
                    road = String(cString: roadno)
                }
                
                var address = getAddressById(addressid)
                address?.append(road)
                
                var phoneString = ""
                if let phone = sqlite3_column_text(queryStatement, 7) {
                    phoneString = String(cString: phone)
                }
                
                let imageBlob = sqlite3_column_blob(queryStatement, 8)
                let imageLength = sqlite3_column_bytes(queryStatement, 8)
                var abstractText = ""
                if let abstract = sqlite3_column_text(queryStatement, 9) {
                    abstractText = String(cString: abstract)
                }
                let staytime = sqlite3_column_int(queryStatement, 4)
                let hightime = sqlite3_column_int(queryStatement, 5)
                let lat = sqlite3_column_double(queryStatement, 10)
                let lng = sqlite3_column_double(queryStatement, 11)
                
                var ticket: Int32 = -1
                
                // Not a Landmark
                if placeForm != PlaceForm.landmark.rawValue {
                    placeInfo = PlaceInfo(id: id, name: nameString, address: address!, form: PlaceForm(rawValue: placeForm)!,
                                          image: NSData(bytes: imageBlob, length: Int(imageLength)), ticket: ticket, staytime: staytime, hightime: hightime, phone: phoneString, abstract: abstractText, lat: lat, lng: lng, score: getScore(of: id))
                    
                    
                    
                } else {
                    ticket = getNormalTicketId(of: id)
                    placeInfo = PlaceInfo(id: id, name: nameString, address: address!, form: PlaceForm(rawValue: placeForm)!,
                                          image: NSData(bytes: imageBlob, length: Int(imageLength)), ticket: ticket, staytime: staytime, hightime: hightime, phone: phoneString, abstract: abstractText, lat: lat, lng: lng, score: getScore(of: id))
                }
                
                placeInfos.append(placeInfo)
                
            }
            
        } else {
            print("queryOfPlaceInfos() query not prepared")
        }
        
        return placeInfos.sorted(by: >)
    }
    
    private func addFormRule(to originalQueryString: String, with form: Int) -> String {
        
        var queryString = originalQueryString
        
        switch form {
        case 1, 2, 3:
            queryString.append(" AND formid = \(form);")
        case 12:
            queryString.append(" AND formid != 3;")
        case 23:
            queryString.append(" AND formid != 1;")
        case 13:
            queryString.append(" AND formid != 2;")
        default:
            queryString.append(";")
        }
        
        return queryString
    }
}
