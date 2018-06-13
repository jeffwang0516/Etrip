//
//  DiaryInfo.swift
//  eTrip
//
//  Created by JeffWang on 2018/6/4.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation

class DiaryInfo {
    
    let diaryId: String
    let name: String
    let preDate: Int32
    let postDate: Int32
    
    init(diaryId: String, name: String, preDate: Int32, postDate: Int32) {
        self.diaryId = diaryId
        self.name = name
        self.preDate = preDate
        self.postDate = postDate
    }
}

extension DiaryInfo: Comparable {
    static func == (lhs: DiaryInfo, rhs: DiaryInfo) -> Bool {
        return lhs.preDate == rhs.preDate && lhs.postDate == rhs.postDate
    }
    
    static func < (lhs: DiaryInfo, rhs: DiaryInfo) -> Bool {
        if lhs.preDate != rhs.preDate {
            return lhs.preDate < rhs.preDate
        }
        return lhs.postDate < rhs.postDate
    }
}
