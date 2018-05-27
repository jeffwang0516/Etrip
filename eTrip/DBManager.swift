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
    func test() {
        print("TEST")
        print(getAllCityNames())
        print(getCityDistrict(city: "臺北市"))
        print(getAddressById(6)!)
        print(searchForPlaceInfos(with: "舊金山", of: 4))
        
    }
    
    private func queryOfPlaceInfos(with queryString: String) -> [PlaceInfo] {
        var queryStatement: OpaquePointer? = nil
        var placeInfos: [PlaceInfo] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var placeInfo: PlaceInfo
                let placeForm = sqlite3_column_int(queryStatement, 7)
                
                let id = sqlite3_column_int(queryStatement, 0)
                let name = sqlite3_column_text(queryStatement, 1)
                let addressid = sqlite3_column_int(queryStatement, 2)
                let road = sqlite3_column_text(queryStatement, 3)
                let no = sqlite3_column_text(queryStatement, 4)
                var addressNo = ""
                
                if "0" == String(cString: no!) { addressNo.append("\(String(cString: no!)) 號")}
                var address = getAddressById(addressid)
                address?.append(String(cString: road!))
                address?.append(addressNo)
                
                let phone = sqlite3_column_text(queryStatement, 8)
                let imageBlob = sqlite3_column_blob(queryStatement, 9)
                let imageLength = sqlite3_column_bytes(queryStatement, 9)
                let abstract = sqlite3_column_text(queryStatement, 10)
                let staytime = sqlite3_column_int(queryStatement, 5)
                let hightime = sqlite3_column_int(queryStatement, 6)
                
                var ticket: Int32 = -1
                
                // Not a Landmark
                if placeForm != PlaceForm.landmark.rawValue {
                    placeInfo = PlaceInfo(id: id, name: String(cString: name!), address: address!, form: PlaceForm(rawValue: placeForm)!,
                                          image: NSData(bytes: imageBlob, length: Int(imageLength)), ticket: ticket, staytime: staytime, hightime: hightime, phone: String(cString: phone!), abstract: String(cString: abstract!))
                    
                    
                    
                } else {
                    ticket = getNormalTicketId(of: id)
                    placeInfo = PlaceInfo(id: id, name: String(cString: name!), address: address!, form: PlaceForm(rawValue: placeForm)!,
                                          image: NSData(bytes: imageBlob, length: Int(imageLength)), ticket: ticket, staytime: staytime, hightime: hightime, phone: String(cString: phone!), abstract: String(cString: abstract!))
                }
                
                placeInfos.append(placeInfo)
                
            }
            
        } else {
            print("queryOfPlaceInfos() query not prepared")
        }
        return placeInfos
    }
    
    
    func searchForPlaceInfos(with searchText: String, of form: Int) -> [PlaceInfo]{
        var queryString = "SELECT * FROM place WHERE name LIKE '%\(searchText)%'"
        if form != 4 {
            queryString.append(" AND formid = \(form)")
        }
        queryString.append(";")
        
        return queryOfPlaceInfos(with: queryString)
        
    }
    
    func searchForPlaceInfos(by addressid: Int, of form: Int) -> [PlaceInfo]{
        var queryString = "SELECT * FROM place WHERE addressid = \(addressid)"
        if form != 4 {
            queryString.append(" AND formid = \(form)")
        }
        queryString.append(";")
        
        return queryOfPlaceInfos(with: queryString)
    }
    
    func getNormalTicketId(of placeId: Int32) -> Int32{
        let queryString = "SELECT ticket FROM landmarkticket WHERE placeid = \(placeId) AND identity = '普通票';"
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
    deinit {
        sqlite3_close(db)
    }
}
