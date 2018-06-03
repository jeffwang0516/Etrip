//
//  DiaryDetail.swift
//  eTrip
//
//  Created by JeffWang on 2018/6/4.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation

class DiaryDetail {
    let diaryId: String
    let userid: String
    let day: Int32
    let content: Int32
    let startTime: Int32
    let endTime: Int32
    let tag: Int32
    let name: String
    
    init(diaryId: String, userid: String, day: Int32, content: Int32, startTime: Int32, endTime: Int32, tag: Int32, name: String) {
        self.diaryId = diaryId
        self.userid = userid
        self.day = day
        self.content = content
        self.startTime = startTime
        self.endTime = endTime
        self.tag = tag
        self.name = name
    }
}

extension DiaryDetail: Comparable {
    static func == (lhs: DiaryDetail, rhs: DiaryDetail) -> Bool {
        return lhs.day == rhs.day && lhs.startTime == rhs.startTime
    }
    
    static func < (lhs: DiaryDetail, rhs: DiaryDetail) -> Bool {
        if lhs.day != rhs.day {
            return lhs.day < rhs.day
        }
        return lhs.startTime < rhs.startTime
    }
}
