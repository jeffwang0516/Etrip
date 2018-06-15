//
//  AutoPlanSuggestViewCell.swift
//  eTrip
//
//  Created by JeffWang on 2018/6/12.
//  Copyright © 2018 JeffWang. All rights reserved.
//

import Foundation
import UIKit

class AutoPlanCheckBoxCell: UITableViewCell {
    
    @IBOutlet weak var checkImgBox: UIImageView!
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                checkImgBox.image = UIImage(named: "checked")
            } else {
                checkImgBox.image = UIImage(named: "uncheck")
            }
        }
    }
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    func alterCheck() {
        self.isChecked = !isChecked
    }
}
