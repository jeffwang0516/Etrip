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
    private let sqlFilePath = Bundle.main.url(forResource: "etrip", withExtension: "db")!
    static let instance = DBManager()
    private var db: OpaquePointer?
    
    private init() {
        if let path = copyDBInDocuments(initDatabasePath: sqlFilePath)?.relativePath {
            if sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
                print("DB successfully connected \(path)")
            } else {
                print("Error opening database")
            }
        }
        
    }
    
    // Put initial etrip.db to documents, because it's readonly in Bundle files
    private func copyDBInDocuments(initDatabasePath: URL?) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
       
        
        if var documentDirectory:URL = urls.first {

            documentDirectory.setTemporaryResourceValue(true, forKey: .isExcludedFromBackupKey)

            // This is where the database should be in the documents directory
            let finalDatabaseURL = documentDirectory.appendingPathComponent("etrip.db")
            
            var ifExist = false
            do {
                ifExist = try finalDatabaseURL.checkResourceIsReachable()
            } catch _{
                print("checkResourceIsReachable FAILED")
            }

            if ifExist {
                return finalDatabaseURL
            } else {
                if let bundleURL = initDatabasePath {
                    do {
                        try fileManager.copyItem(at: bundleURL, to: finalDatabaseURL)
                    } catch _ {
                        print("Couldn't copy file to final location!")
                        return nil
                    }

                    return finalDatabaseURL

                } else {
                    print("Couldn't find initial database in the bundle!")
                }
            }
            
        } else {
            print("Couldn't get documents directory")
        }
        
        return nil
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    func test() {
        print("TESTs:")
//        print(getAllCityNames())
//        print(getCityDistrict(city: "臺北市"))
//        print(getAddressById(100))
//        print(searchForPlaceInfos(with: "舊金山", of: 4))
//        print(getScore(of: 334))
//        print("PlaceFavorite: ", ifPlaceIsFavorite(of: "TCA", placeid: 3))
//        print("ALTER: ", alterFavorites(of: "TCA", placeid: 3))
//
//        print("PlaceFavoriteAFTER: ", ifPlaceIsFavorite(of: "TCA", placeid: 3))
//        print(getFavoritePlaces(of: "TCA", with: Int(PlaceForm.all.rawValue)))
//        print(getRatings(of: 2, by: "frog"))
//        print("-----")
//        let dining = searchForDiningPlaces(near: 2, considerOf: 1700)
//        for dine in dining {
//            print(dine.name)
//        }
//        let landmarks = searchForLandmarks(with: LandmarkWay.all, in: 208, considerOf: 1600)
//        for ld in landmarks {
//            print(ld.name)
//        }
//        print("-----")
//        let hotels = searchForHotels(in: 208)
//        for ht in hotels {
//            print(ht.name)
//        }
//        print("-----")
//        for trans in getAvailableTransportation(in: 208) {
//            print(trans)
//        }
//        print("-----")
//        let diary = getDiary(of: "TCA")
//        for dr in diary {
//            print(dr.diaryId, dr.name, dr.preDate, dr.postDate)
//        }
//        print("-----")
//        let detail = getDiaryDetail(with: "201706201233", of: "TCA")
//        for dt in detail {
//            print(dt.day, dt.name, dt.startTime, dt.endTime)
//        }
//        let dt1: [DiaryDetail] = [DiaryDetail(diaryId: "11112", userid: "TCA", day: 1, content: 7, startTime: 1000, endTime: 1030, tag: 1, name: getPlaceName(of: 7))]
//        let dt = addDiary(diaryName: "ASXD", details: dt1, preDate: 20180101, postDate: 20180103)
//        let detail = getDiaryDetail(with: "11112", of: "TCA")
//        for dt in detail {
//            print(dt.day, dt.name, dt.startTime, dt.endTime)
//        }
//        print(deleteDiary(diaryid: "11112", userid: "TCA"))

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
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
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
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
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
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
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
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
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
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
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
//        let queryString = "SELECT * FROM landmarkticket WHERE placeid = \(placeId);"
        let queryString = "select identity,ticket from landmarkticket,IdentityInfo where landmarkticket.identityid=IdentityInfo.identityid and placeid = \(placeId);"

        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var ticketInfos: [TicketInfo] = []
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let identity = sqlite3_column_text(queryStatement, 0)
                let price = sqlite3_column_int(queryStatement, 1)
                
                let ticket = TicketInfo(identity: String(cString: identity!), cost: Int(price))
                
                ticketInfos.append(ticket)
            }
            
        } else {
            print("getTickcetInfos(\(placeId)) query not exist")
        }
        return ticketInfos
    }
    
    
    // Favorites
    func ifPlaceIsFavorite(of userid: String, placeid: Int32) -> Bool {
        let queryString = "SELECT * FROM favorite WHERE userid = '\(userid)' AND placeid = \(placeid);"
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                return true
            }
            
        } else {
            print("ifPlaceIsFavorite query not prepared")
        }
        
        return false
    }
    
    func alterFavorites(of userid: String, placeid: Int32) -> Bool {
        // Either Add or Del from one's favorite list, return successful or not
        let isFavorite = ifPlaceIsFavorite(of: userid, placeid: placeid)

        var queryString = ""
        
        if !isFavorite {
            queryString = "INSERT INTO favorite values('\(userid)', \(placeid));"
        } else {
            queryString = "DELETE FROM favorite WHERE userid = '\(userid)' AND placeid = \(placeid);"
        }
        print(queryString)
        if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK{
            print("alterFavorites query not prepared")
            return false
        }
        
        return true
    }
    
    func getFavoritePlaces(of userid: String, with form: Int) -> [PlaceInfo] {
        
        var queryString = "SELECT place.* FROM place, favorite WHERE userid = '\(userid)' AND place.placeid = favorite.placeid"
        queryString = addFormRule(to: queryString, with: form)
        return queryOfPlaceInfos(with: queryString)

    }
    

    // Ratings
    func getRatings(of placeid: Int, by userid: String) -> Int? {
        let queryString = "SELECT * FROM score WHERE userid = '\(userid)' and placeid=\(placeid);"
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let score = sqlite3_column_int(queryStatement, 2)
                return Int(score)
            }
            
        } else {
            print("getRatings query not prepared")
        }
        return nil
    }
    
    
    // AutoPlanning Related:
    // Nearby queries & Time constrained queries
    func searchForDiningPlaces(near placeid: Int, considerOf timeFactor: Int) -> [PlaceInfo] {
        let queryString = "SELECT place.* FROM place WHERE placeid IN ( SELECT placeid_rest FROM landrest WHERE placeid_land=\(placeid)) AND ((hightime/10000)-(hightime%10000/10000)) <= \(timeFactor) AND hightime%10000 >= \(timeFactor);"
        return queryOfPlaceInfos(with: queryString)
    }
    
    func searchForLandmarks(with way: LandmarkWay, in addressid: Int, considerOf timeFactor: Int) -> [PlaceInfo]  {
        var queryString = "SELECT place.* FROM place, landmarkway WHERE place.placeid=landmarkway.placeid AND formid = 1 AND ((hightime/10000)-(hightime%10000/10000)) <= \(timeFactor) AND hightime%10000 >= \(timeFactor) AND addressid = \(addressid)"
        if way != LandmarkWay.all {
            queryString.append(" AND wayid = \(way.rawValue);")
        } else {
            queryString.append(";")
        }
        
        return queryOfPlaceInfos(with: queryString)
    }
    
    func searchForHotels(in addressid: Int) -> [PlaceInfo]  {
        let queryString = "SELECT * from place WHERE formid = 3 AND addressid = \(addressid);"
        return queryOfPlaceInfos(with: queryString)
    }
    
    func getAvailableTransportation(in addressid: Int) -> [String]  {
        var trans: [String] = []
        let queryString = "SELECT trans FROM trans,transinfo WHERE trans.transid=transinfo.transid and addressid=\(addressid);"
        
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let transType = sqlite3_column_text(queryStatement, 0) {
                    trans.append(String(cString: transType))
                }
            }
            
        } else {
            print("getAvailableTransportation query not prepared")
        }
        return trans
    }
    
    
    // Diary
    
    func getDiary(of userid: String) -> [DiaryInfo] {
        var diaries: [DiaryInfo] = []
        let queryString = "SELECT * FROM diary WHERE userid='\(userid)';"
        
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let diaryid = sqlite3_column_text(queryStatement, 0), let name = sqlite3_column_text(queryStatement, 2) {
                
                    let preDate = sqlite3_column_int(queryStatement, 3)
                    let postDate = sqlite3_column_int(queryStatement, 4)
                    diaries.append(DiaryInfo(diaryId: String(cString: diaryid), name: String(cString: name), preDate: preDate, postDate: postDate) )
                
                }
            }
            
        } else {
            print("getDiary query not prepared")
        }
        return diaries.sorted(by: <)
    }
    
    func getDiaryDetail(with diaryId: String, of userid: String) -> [DiaryDetail] {
        var diaryDetails: [DiaryDetail] = []
        let queryString = "SELECT * FROM diarydetail WHERE diaryid=\(diaryId) AND userid='\(userid)';"
        
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let diaryid = sqlite3_column_text(queryStatement, 0), let userid = sqlite3_column_text(queryStatement, 1) {
                    let day = sqlite3_column_int(queryStatement, 2)
                    let content = sqlite3_column_int(queryStatement, 3)
                    let startTime = sqlite3_column_int(queryStatement, 4)
                    let endTime = sqlite3_column_int(queryStatement, 5)
                    let tag = sqlite3_column_int(queryStatement, 6)
                    
                    var name = ""
                    if tag == 1 {
                        name = getPlaceName(of: content)
                    } else {
                        name = getTransportationName(of: content)
                    }
                    diaryDetails.append(DiaryDetail(diaryId: String(cString: diaryid), userid: String(cString: userid), day: day, content: content, startTime: startTime, endTime: endTime, tag: tag, name: name))
                    
                }
            }
            
        } else {
            print("getDiaryDetail query not prepared")
        }
        return diaryDetails.sorted(by: <)
    }
    
    func addDiary(diaryName: String, details: [DiaryDetail], preDate: Int32, postDate: Int32) -> Bool{
        guard let firstDatail = details.first else {
            return false
        }
        
        let queryString = "insert into diary values('\(firstDatail.diaryId)','\(firstDatail.userid)','\(diaryName)', \(preDate), \(postDate));"
        
        if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK{
            print("addDiary query not prepared")
            return false
        }
        
        for item in details {
            let queryString2 = "insert into diarydetail values('\(item.diaryId)','\(item.userid)', \(item.day), \(item.content), \(item.startTime), \(item.endTime), \(item.tag));"
            
            if sqlite3_exec(db, queryString2, nil, nil, nil) != SQLITE_OK{
                print("addDiaryDetail query not prepared")
                return false
            }
        }
        return true
    }
    
    func deleteDiary(diaryid: String, userid: String) -> Bool{
        let queryString = "delete from diary where diaryid='\(diaryid)' and userid='\(userid)';"
        let queryString2 = "delete from diarydetail where diaryid='\(diaryid)' and userid='\(userid)';"
        
        if sqlite3_exec(db, queryString, nil, nil, nil) != SQLITE_OK{
            print("deleteDiary query not prepared")
            return false
        }
        
        if sqlite3_exec(db, queryString2, nil, nil, nil) != SQLITE_OK{
            print("deleteDiaryDeatails query not prepared")
            return false
        }
        
        return true
    }
    
    /*** Private Helper Functions Below NOT FOR CALL ***/
    private func getScore(of placeid: Int32) -> Score{
        let queryString = "SELECT * FROM score WHERE placeid = \(placeid);"
        var queryStatement: OpaquePointer? = nil

        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var count = 0.0
        var total = 0.0
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let score = sqlite3_column_int(queryStatement, 2)
                total = total + Double(score)
                count = count +  1
            }
        } else {
            print("getScore(\(placeid)) query not exist")
        }
        let avg = total/count
        return Score(average: avg, total: Int(total))
    }
    
    private func getPlaceName(of placeid: Int32) -> String {
        let queryString = "SELECT name FROM place WHERE placeid = \(placeid);"
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                if let name = sqlite3_column_text(queryStatement, 0) {
                    return String(cString: name)
                }
                
            }
        } else {
            print("private getPlaceName query not exist")
        }
        
        return ""
    }
    
    private func getTransportationName(of transid: Int32) -> String {
        let queryString = "SELECT trans FROM transinfo WHERE transid = \(transid);"
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                if let name = sqlite3_column_text(queryStatement, 0) {
                    return String(cString: name)
                }
                
            }
        } else {
            print("private getTransportationName query not exist")
        }
        
        return ""
    }
    
    private func queryOfPlaceInfos(with queryString: String) -> [PlaceInfo] {
        var queryStatement: OpaquePointer? = nil
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
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
