//
//  FavoriteViewController.swift
//  eTrip
//
//  Created by 蕭恬 on 2018/5/30.
//  Copyright © 2018年 JeffWang. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet weak var landmarkButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var hotelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchFavorite(_ sender: UIButton) {
        switch sender {
        case landmarkButton:
            landmarkButton.backgroundColor = UIColor(red: 92/255, green: 0, blue: 0, alpha: 1)

            restaurantButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            hotelButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            //search favoriteLM and list in table view
        case restaurantButton:
            restaurantButton.backgroundColor = UIColor(red: 92/255, green: 0, blue: 0, alpha: 1)
            landmarkButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            hotelButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            //search favoriteRest and list in table view
        case hotelButton:
            hotelButton.backgroundColor = UIColor(red: 92/255, green: 0, blue: 0, alpha: 1)
            landmarkButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            restaurantButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            //search favoriteHotel and list in table view
        default:
            landmarkButton.backgroundColor = UIColor(red: 92/255, green: 0, blue: 0, alpha: 1)
            restaurantButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            hotelButton.backgroundColor = UIColor(red: 177/255, green: 49/255, blue: 45/255, alpha: 1)
            //search favoriteLM and list in table view
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
