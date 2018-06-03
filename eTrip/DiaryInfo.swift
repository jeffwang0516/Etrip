//
//  DiaryInfo.swift
//  eTrip
//
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

