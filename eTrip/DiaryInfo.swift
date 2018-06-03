//
//  DiaryInfo.swift
//  eTrip
//
<<<<<<< HEAD
//  Created by 蕭恬 on 2018/6/4.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import Foundation
import UIKit

class DiaryInfo {
    
    let id: String
    let name: String
    let preDate: Int
    let postDate: Int
    
    init(id: String, name: String, preDate: Int, postDate: Int) {
        self.id = id
        self.name = name
        self.preDate = preDate
        self.postDate = postDate
    }  
}

=======
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
>>>>>>> e3ddd0a36f04e319bf0988a41956fb4b30810ee4
