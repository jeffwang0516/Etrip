//
//  PlaceInfo.swift
//  eTrip
//
//  Created by JeffWang on 2018/5/27.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import UIKit

enum PlaceForm: Int32 {
    case landmark = 1
    case restaurant = 2
    case hotel = 3
    case all = 123
    case home = 4
}

// Information for whether a landmark is indoor/outdoor preferred
enum LandmarkWay: Int32 {
    case indoor = 1
    case outdoor = 2
    case all = 3
}

struct Score {
    var average = 0.0
    var total = 0
}

class PlaceInfo {
    
    let id: Int32
    let name: String
    let address: String
    let form: PlaceForm
    let image: NSData
    let ticket: Int32
    let staytime: Int32
    let hightime: Int32
    let phone: String
    let abstract: String
    let lat: Double
    let lng: Double
    
    let score: Score
    
    init(id: Int32, name: String, address: String, form: PlaceForm, image: NSData, ticket: Int32, staytime: Int32, hightime: Int32, phone: String, abstract: String, lat: Double, lng: Double, score: Score) {
        self.id = id
        self.name = name
        self.address = address
        self.form = form
        self.image = image
        self.ticket = ticket
        self.staytime = staytime
        self.hightime = hightime
        self.phone = phone
        self.abstract = abstract
        self.lat = lat
        self.lng = lng
        self.score = score
    }
    
    func getUIImage() -> UIImage? {
        guard let img = UIImage(data: image as Data) else {
            return nil
        }
        return img
        
    }
    
    
    
}

extension PlaceInfo: Comparable {
    static func == (lhs: PlaceInfo, rhs: PlaceInfo) -> Bool {
        return lhs.score.average == rhs.score.average && lhs.score.total == rhs.score.total
    }
    
    static func < (lhs: PlaceInfo, rhs: PlaceInfo) -> Bool {
        if lhs.score.average != rhs.score.average {
            return lhs.score.average < rhs.score.average
        }
        return lhs.score.total <= rhs.score.total
    }
}
