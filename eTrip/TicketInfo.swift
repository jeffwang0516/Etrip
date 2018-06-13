//
//  TicketInfo.swift
//  eTrip
//
//  Created by JeffWang on 2018/5/27.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation

class TicketInfo {
    let identity: String
    let cost: Int
    
    init(identity: String, cost: Int) {
        
        self.identity = identity
        self.cost = cost
    }
}
